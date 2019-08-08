require 'holidays'
require 'pg'

# rubocop:disable Metrics/ParameterLists (with a s)
# rubocop:disable Metrics/AbcSize
#
# # facilities management calculator based on Damolas spreadsheet -  the first set framework calculations are repeated with a benchmark rate to give two values
# # 1. Unit of measure of deliverables required
#
# # 3. Benchmarked costs
# # the calculations are simple and sequential based on previous totals which are then used for subsequent calculations - calculations are either summing or multiplication
# # cafm = computer aided facilities management
# # tupe = transfer underlying protection of employment

module FMCalculator
  class Calculator
    attr_writer :uom, :framework_rate

    @benchmark_rates = nil
    @framework_rates = nil

    def initialize(contract_length_years, service_ref, uom_vol, occupants, tupe_flag, london_flag, cafm_flag, helpdesk_flag,
                   rates, rate_card = nil, supplier_name = nil, building_data = nil)
      @contract_length_years = contract_length_years
      @subsequent_length_years = contract_length_years - 1
      @service_ref = service_ref
      @uom_vol = uom_vol
      @occupants = occupants
      @tupe_flag = tupe_flag
      @london_flag = london_flag
      @cafm_flag = cafm_flag
      @helpdesk_flag = helpdesk_flag
      @subtotal2 = 0
      @uomd = 0
      @clean = 0
      @variance = 0
      @subtotal1 = 0
      @cafm = 0
      @helpdesk = 0
      @mobilisation = 0
      @year1 = 0
      @manage = 0
      @year1total = 0
      @profit = 0
      @year1totalcharges = 0
      @benchmark_rate = 0
      @framework_rate = 0
      @benchmarkedcosts = 0
      @benchclean = 0
      @tupe = 0
      @benchcafm = 0
      @benchhelpdesk = 0
      @benchsubtotal2 = 0
      @benchsubtotal3 = 0
      @benchvariance = 0

      @benchmark_rates = rates[:benchmark_rates]
      @framework_rates = rates[:framework_rates]
      @rate_card = rate_card
      @supplier_name = supplier_name
      @building_data = building_data
    end

    # unit of measurable deliverables = framework_rate * unit of measure volume
    def uomd
      @framework_rate = @framework_rates[@service_ref].to_f

      # benchmark rate set here
      @benchmark_rate = @benchmark_rates[@service_ref].to_f

      @uomd =
        if @supplier_name && @rate_card.data['Discounts'][@supplier_name][@service_ref]
          (1 - @rate_card.data['Discounts'][@supplier_name][@service_ref]['Disc %'].to_f) * @uom_vol * @rate_card.data['Prices'][@supplier_name][@service_ref][@building_data['fm-building-type']].to_f
        else
          @uom_vol * @framework_rate
        end
    rescue StandardError => e
      raise e
    end

    # cleaning consumables
    def clean
      @clean =
        if @supplier_name
          @occupants * @rate_card.data['Variances'][@supplier_name]['Cleaning Consumables per Building User (£)']
        else
          @occupants * @framework_rates['M146']
        end
    end

    # subtotal1 = unit of measurable deliverables + cleaning consumables
    def subtotal1
      @subtotal1 = @uomd + @clean
    end

    # London location variance based on being in london and a framework rate multiplied by subtotal1
    def variance
      if @london_flag == 'Y'
        @variance =
          if @supplier_name
            @subtotal1 * @rate_card.data['Variances'][@supplier_name]['London Location Variance Rate (%)'].to_f
          else
            @subtotal1 * @benchmark_rates['M144'].to_f
          end
      else
        0
      end
    end

    # subtotal2 = subtotal1 + variance
    def subtotal2
      @subtotal2 = @subtotal1 + @variance
    end

    # if cafm flag is set then subtotal * framework rate
    def cafm
      if @cafm_flag == 'Y'
        @cafm =
          if @supplier_name
            @subtotal2 * @rate_card.data['Prices'][@supplier_name]['M.1'][@building_data['fm-building-type']].to_f
          else
            @subtotal2 * @framework_rates['M136']
          end
      else
        0
      end
    end

    # if helpdesk_flag is set then multiply by subtotal2
    def helpdesk
      if @helpdesk_flag == 'Y'
        @helpdesk =
          if @supplier_name
            @subtotal2 * @rate_card.data['Prices'][@supplier_name]['M.1'][@building_data['fm-building-type']].to_f
          else
            @subtotal2 * @framework_rates['M138']
          end
      else
        0
      end
    end

    # subtotal3 = subtotal2 + cafm + helpdesk
    def subtotal3
      @subtotal3 = @subtotal2 + @cafm + @helpdesk
    end

    # mobilisation = subtotal3 * framework_rate
    def mobilisation
      @mobilisation =
        if @supplier_name
          @subtotal3 * @rate_card.data['Variances'][@supplier_name]['Mobilisation Cost (DA %)'].to_f
        else
          @subtotal3 * @framework_rates['M5']
        end
    end

    # if tupe_flag set then calculate tupe risk premium = subtotal3 * framework rate
    def tupe
      if @tupe_flag == 'Y'
        @tupe =
          if @supplier_name
            @subtotal3 * @rate_card.data['Variances'][@supplier_name]['TUPE Risk Premium (DA %)'].to_f
          else
            @subtotal3 * @framework_rates['M148']
          end
      else
        0
      end
    end

    # total  year 1 deliverables value
    def year1
      @year1 = @subtotal3 + @mobilisation + @tupe
    end

    # Management overhead
    def manage
      @manage =
        if @supplier_name
          @year1 * @rate_card.data['Variances'][@supplier_name]['Management Overhead %']
        else
          @year1 * @framework_rates['M140']
        end
    end

    # Corporate overhead
    def corporate
      @corporate =
        if @supplier_name
          @year1 * @rate_card.data['Variances'][@supplier_name]['Corporate Overhead %']
        else
          @year1 * @framework_rates['M141']
        end
    end

    # Year 1 total charges subtotal
    def year1total
      @year1total = @year1 + @manage + @corporate
    end

    # framework profit
    def profit
      @profit =
        if @supplier_name
          @year1 * @rate_card.data['Variances'][@supplier_name]['Profit %']
        else
          @year1 * @framework_rates['M142']
        end
    end

    # year 1 total charges
    def year1totalcharges
      @year1totalcharges = @year1total + @profit
    end

    # subsequent year(s) total charges
    def subyearstotal
      @subyearstotal =
        if @supplier_name
          @subsequent_length_years *
            (@year1totalcharges -
              (((@mobilisation + (@mobilisation * @rate_card.data['Variances'][@supplier_name]['Management Overhead %']) +
                (@mobilisation * @rate_card.data['Variances'][@supplier_name]['Corporate Overhead %'])) *
                  (@rate_card.data['Variances'][@supplier_name]['Profit %'] + 1))))
        else
          @subsequent_length_years * (@year1totalcharges - (((@mobilisation + (@mobilisation * @framework_rates['M140']) + (@mobilisation * @framework_rates['M141'])) * (@framework_rates['M142'] + 1))))
        end
    end

    # total charges
    def totalcharges
      @year1totalcharges += @subyearstotal
    end

    # benchmarked costs start = benchmark rates * unit of mesasure volume
    def benchmarkedcosts
      benchmark_rate = @benchmark_rates[@service_ref].to_f
      @benchmarkedcosts = benchmark_rate * @uom_vol
    end

    # cleaning consumables using benchmark rate
    def benchclean
      @benchclean = @occupants * @framework_rates['M146']
    end

    # benchmark subtotal1
    def benchsubtotal1
      @benchsubtotal1 = @benchmarkedcosts + @benchclean
    end

    # benchmark variation if london_flag set
    def benchvariation
      if @london_flag == 'Y'
        @benchvariance = @benchsubtotal1 * @benchmark_rates['M144'].to_f
      else
        0
      end
    end

    # benchmark subtotal2
    def benchsubtotal2
      @benchsubtotal2 = @benchvariance + @benchsubtotal1
    end

    # benchmark cafm if flag set
    def benchcafm
      @benchcafm =
        if @cafm_flag == 'Y'
          @framework_rates['M136'] * @benchsubtotal2
        else
          0
        end
    end

    # benchmark helpsdesk costs if helpdesk_flag set
    def benchhelpdesk
      if @helpdesk_flag == 'Y'
        @benchhelpdesk = @benchsubtotal2 * @framework_rates['M138']
      else
        0
      end
    end

    # bench mark subtotal 3
    def benchsubtotal3
      @benchsubtotal3 = @benchsubtotal2 + @benchcafm + @benchhelpdesk
    end

    # benchmark mobilisation costs
    def benchmobilisation
      @benchmobilisation = @benchsubtotal3 * @framework_rates['M5']
    end

    # benchmark tupe costs if flag set
    def benchtupe
      @benchtupe =
        if @tupe_flag == 'Y'
          @benchsubtotal3 * @framework_rates['M148']
        else
          @benchtupe = 0
        end
    end

    # bench mark total year1 deliverables value
    def benchyear1
      @benchyear1 = @benchsubtotal3 + @benchmobilisation + @benchtupe
    end

    # benchmark mananagement overhead costs
    def benchmanage
      @benchmanage = @benchyear1 * @framework_rates['M140']
    end

    # bench mark corporate overhead cost
    def benchcorporate
      @benchcorporate = @benchyear1 * @framework_rates['M141']
    end

    # total year 1 charges subtotal
    def benchyear1total
      @benchyear1total = @benchyear1 + @benchmanage + @benchcorporate
    end

    # bench mark profit
    def benchprofit
      @benchprofit = @benchyear1 * @framework_rates['M142']
    end

    # bench mark year 1 total charges
    def benchyear1totalcharges
      @benchyear1totalcharges = @benchyear1total + @benchprofit
    end

    # bench mark subsequent year(s) total charges
    def benchsubyearstotal
      @benchsubyearstotal = @subsequent_length_years * (@benchyear1totalcharges - (((@benchmobilisation + (@benchmobilisation * @framework_rates['M140']) + (@benchmobilisation * @framework_rates['M141'])) * (@framework_rates['M142'] + 1))))
    end

    # total bench mark charges
    def benchtotalcharges
      @benchyear1totalcharges += @benchsubyearstotal
    end

    # entry point to calculate sum of the unit of measure
    def sumunitofmeasure
      uomd
      clean
      subtotal1
      variance
      subtotal2
      cafm
      helpdesk
      subtotal3
      mobilisation
      tupe
      year1
      manage
      corporate
      year1total
      profit
      year1totalcharges + subyearstotal
    end

    # entry point to calculate bench marked sum
    def benchmarkedcostssum
      benchmarkedcosts
      benchclean
      benchsubtotal1
      benchvariation
      benchsubtotal2
      benchcafm
      benchhelpdesk
      benchsubtotal3
      benchmobilisation
      benchtupe
      benchyear1
      benchmanage
      benchcorporate
      benchyear1total
      benchprofit
      benchyear1totalcharges + benchsubyearstotal
    end
  end
end

# rubocop:enable Metrics/ParameterLists (with a s)
# rubocop:enable Metrics/AbcSize
