module FM::RM6232
  module GenerateSupplierLotData
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier::LotData.destroy_all
    end

    def self.generate_suppliers_with_lot_data
      suppliers = FacilitiesManagement::RM6232::Supplier.all

      generate_lot_data(suppliers.shuffle)
    end

    def self.generate_lot_data(suppliers)
      lot_groups = [{ suppliers: suppliers[0..24], lot_code: 'a' }, { suppliers: suppliers[15..35], lot_code: 'b' }, { suppliers: suppliers[25..51], lot_code: 'c' }]

      lot_groups.each do |lot_group|
        SUPPLIER_SPLIT.each do |range, service_method, region_method|
          assign_services_and_regions(lot_group[:suppliers][range], lot_group[:lot_code], send(service_method), send(region_method))
        end

        random_services_and_regions(lot_group[:suppliers][16..], lot_group[:lot_code])
      end
    end

    SUPPLIER_SPLIT = [
      [0..4, :all_services, :all_regions],
      [5..9, :all_services, :regions_england_and_wales],
      [10..12, :hard_fm_services, :all_regions],
      [13..15, :soft_fm_services, :all_regions]
    ].freeze

    def self.all_services
      @all_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.pluck(:code) }.flatten
    end

    def self.all_core_services
      @all_core_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(core: true).pluck(:code) }.flatten
    end

    def self.all_additional_services
      @all_additional_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(core: false).pluck(:code) }.flatten
    end

    def self.hard_fm_services
      @hard_fm_services ||= sorted_service_codes((FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(hard: true).pluck(:code) }.flatten + all_core_services).uniq)
    end

    def self.soft_fm_services
      @soft_fm_services ||= sorted_service_codes((FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.where(soft: true).pluck(:code) }.flatten + all_core_services).uniq)
    end

    def self.assign_services_and_regions(suppliers, lot_code, services, regions)
      suppliers.each do |supplier|
        supplier.lot_data.create(lot_code: lot_code, service_codes: services, region_codes: regions)
      end
    end

    def self.random_services_and_regions(suppliers, lot_code)
      suppliers.each do |supplier|
        supplier.lot_data.create(lot_code: lot_code, service_codes: random_service_codes, region_codes: random_region_codes)
      end
    end

    def self.random_service_codes
      service_sample_size = (number_of_services * (rand(0..15) / 20.0)).to_i

      service_code_selection = all_additional_services.sample(service_sample_size) + all_core_services

      sorted_service_codes(service_code_selection.uniq)
    end

    def self.number_of_services
      @number_of_services ||= all_additional_services.count
    end

    def self.all_regions
      @all_regions ||= FacilitiesManagement::Region.all.reject { |region| region.code == 'OS01' }.map(&:code)
    end

    def self.regions_england_and_wales
      @regions_england_and_wales ||= all_regions.reject { |code| code.starts_with?('UKM') || code.starts_with?('UKN') }
    end

    TOTAL_REGION_COUNT = 73

    def self.random_region_codes
      region_sample_size = (TOTAL_REGION_COUNT * (rand(8..15) / 20.0)).to_i

      all_regions.sample(region_sample_size).sort
    end

    def self.sorted_service_codes(service_codes)
      service_codes.sort_by { |service_code| all_service_codes_sorted.index(service_code) }
    end

    def self.all_service_codes_sorted
      @all_service_codes_sorted ||= FacilitiesManagement::RM6232::Service.order(:work_package_code, :sort_order).pluck(:code)
    end

    def self.lot_data_valid?
      lot_data_valid = FacilitiesManagement::RM6232::Supplier::LotData.all.map { |lot_data| lot_data.services.map(&:code) }.all? { |service_codes| (all_core_services - service_codes).empty? }

      puts 'There is lot data without all the core services, stopping rake task' unless lot_data_valid

      lot_data_valid
    end

    def self.convert_to_json
      dummy_supplier_data = FacilitiesManagement::RM6232::Supplier.all.order(:supplier_name).map do |supplier|
        lot_data = supplier.lot_data.order(:lot_code).map do |data|
          {
            lot_code: data.lot_code,
            service_codes: data.service_codes,
            region_codes: data.region_codes
          }
        end

        {
          id: supplier.id,
          supplier_name: supplier.supplier_name,
          lot_data: lot_data
        }
      end

      file_path = Rails.root.join('data', 'facilities_management', 'rm6232', 'dummy_supplier_data.json')

      File.open(file_path, 'w') { |file| file.write(JSON.pretty_generate(dummy_supplier_data)) }
    end
  end
end

# This task was created to generate the test data
# You should need to run it again as it will change the tests data and break tests
namespace :db do
  namespace :rm6232 do
    desc 'Generate the supplier lot data and converts to JSON'
    task generate_supplier_lot_data: :environment do
      DistributedLocks.distributed_lock(192) do
        ActiveRecord::Base.transaction do
          FM::RM6232::GenerateSupplierLotData.truncate_tables
          FM::RM6232::GenerateSupplierLotData.generate_suppliers_with_lot_data
          FM::RM6232::GenerateSupplierLotData.convert_to_json if FM::RM6232::GenerateSupplierLotData.lot_data_valid?
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end

    desc 'Part of generating the full supplier details'
    task generate_suppliers: :generate_supplier_lot_data do
    end
  end
end