require 'rails_helper'

RSpec.describe FacilitiesManagement::SummaryReport, type: :model do
  # before do
  # end

  let(:start_date) { Time.zone.today + 1 }
  let(:data) do
    {
      'posted_locations' => ['UKC1', 'UKC2'],
      posted_services: ['C.21', 'C.15', 'C.10', 'C.11', 'C.14', 'C.3', 'C.4', 'C.13', 'C.7', 'C.5', 'C.20', 'C.17', 'C.1', 'C.18', 'C.9', 'C.8', 'C.6', 'C.22', 'C.12', 'C.16', 'C.2', 'C.19', 'D.6', 'D.1', 'D.5', 'D.3', 'D.4', 'D.2', 'E.1', 'E.9', 'E.5', 'E.6', 'E.7', 'E.8', 'E.4', 'E.3', 'E.2', 'F.1', 'F.2', 'F.3', 'F.4', 'F.5', 'F.6', 'F.7', 'F.8', 'F.9', 'F.10', 'G.8', 'G.13', 'G.5', 'G.2', 'G.4', 'G.10', 'G.11', 'G.16', 'G.14', 'G.3', 'G.15', 'G.9', 'G.1', 'G.12', 'G.7', 'G.6', 'H.16', 'H.9', 'H.12', 'H.7', 'H.3', 'H.10', 'H.4', 'H.2', 'H.1', 'H.5', 'H.15', 'H.6', 'H.13', 'H.8', 'H.11', 'H.14', 'I.3', 'I.1', 'I.2', 'I.4', 'J.8', 'J.2', 'J.3', 'J.4', 'J.9', 'J.10', 'J.11', 'J.6', 'J.1', 'J.5', 'J.12', 'J.7', 'K.1', 'K.5', 'K.7', 'K.2', 'K.4', 'K.6', 'K.3', 'L.1', 'L.2', 'L.3', 'L.4', 'L.5', 'L.6', 'L.7', 'L.8', 'L.9', 'L.10', 'L.11', 'M.1', 'N.1', 'O.1'],
      locations: "('\"UKC1\"','\"UKC2\"')",
      services: "('\"C.21\"','\"C.15\"','\"C.10\"','\"C.11\"','\"C.14\"','\"C.3\"','\"C.4\"','\"C.13\"','\"C.7\"','\"C.5\"','\"C.20\"','\"C.17\"','\"C.1\"','\"C.18\"','\"C.9\"','\"C.8\"','\"C.6\"','\"C.22\"','\"C.12\"','\"C.16\"','\"C.2\"','\"C.19\"','\"D.6\"','\"D.1\"','\"D.5\"','\"D.3\"','\"D.4\"','\"D.2\"','\"E.1\"','\"E.9\"','\"E.5\"','\"E.6\"','\"E.7\"','\"E.8\"','\"E.4\"','\"E.3\"','\"E.2\"','\"F.1\"','\"F.2\"','\"F.3\"','\"F.4\"','\"F.5\"','\"F.6\"','\"F.7\"','\"F.8\"','\"F.9\"','\"F.10\"','\"G.8\"','\"G.13\"','\"G.5\"','\"G.2\"','\"G.4\"','\"G.10\"','\"G.11\"','\"G.16\"','\"G.14\"','\"G.3\"','\"G.15\"','\"G.9\"','\"G.1\"','\"G.12\"','\"G.7\"','\"G.6\"','\"H.16\"','\"H.9\"','\"H.12\"','\"H.7\"','\"H.3\"','\"H.10\"','\"H.4\"','\"H.2\"','\"H.1\"','\"H.5\"','\"H.15\"','\"H.6\"','\"H.13\"','\"H.8\"','\"H.11\"','\"H.14\"','\"I.3\"','\"I.1\"','\"I.2\"','\"I.4\"','\"J.8\"','\"J.2\"','\"J.3\"','\"J.4\"','\"J.9\"','\"J.10\"','\"J.11\"','\"J.6\"','\"J.1\"','\"J.5\"','\"J.12\"','\"J.7\"','\"K.1\"','\"K.5\"','\"K.7\"','\"K.2\"','\"K.4\"','\"K.6\"','\"K.3\"','\"L.1\"','\"L.2\"','\"L.3\"','\"L.4\"','\"L.5\"','\"L.6\"','\"L.7\"','\"L.8\"','\"L.9\"','\"L.10\"','\"L.11\"','\"M.1\"','\"N.1\"','\"O.1\"')",
      start_date: start_date
    }
  end

  let(:building1) do
    {
      building_json:
      { 'id': '6C6E4BC4-2F56-F3F1-CA20-95106609D5BB', 'gia': 3400, 'name': 'phoenix house', 'region': 'London', 'address': { 'fm-address-town': 'London', 'fm-address-county': 'London', 'fm-address-line-1': '151 Buckingham Palace Road', 'fm-address-postcode': 'SW1W 9SZ' }, 'isLondon': 'No', 'services': [{ 'code': 'C-21', 'name': 'Airport and aerodrome maintenance services' }, { 'code': 'C-15', 'name': 'Audio visual (AV) equipment maintenance' }, { 'code': 'C-10', 'name': 'Automated barrier control system maintenance' }, { 'code': 'C-11', 'name': 'Building management system (BMS) maintenance' }, { 'code': 'C-14', 'name': 'Catering equipment maintenance' }, { 'code': 'C-3', 'name': 'Environmental cleaning' }, { 'code': 'C-4', 'name': 'Fire detection and firefighting systems maintenance' }, { 'code': 'C-13', 'name': 'High voltage (HV) and switchgear maintenance' }, { 'code': 'C-7', 'name': 'Internal and external building fabric maintenance' }, { 'code': 'C-5', 'name': 'Lifts, hoists and conveyance systems maintenance' }, { 'code': 'C-20', 'name': 'Locksmith services' }, { 'code': 'C-17', 'name': 'Mail room equipment maintenance' }, { 'code': 'C-1', 'name': 'Mechanical and electrical engineering maintenance' }, { 'code': 'C-18', 'name': 'Office machinery servicing and maintenance' }, { 'code': 'C-9', 'name': 'Planned / group re-lamping service' }, { 'code': 'C-8', 'name': 'Reactive maintenance services' }, { 'code': 'C-6', 'name': 'Security, access and intruder systems maintenance' }, { 'code': 'C-22', 'name': 'Specialist maintenance services' }, { 'code': 'C-12', 'name': 'Standby power system maintenance' }, { 'code': 'C-16', 'name': 'Television cabling maintenance' }, { 'code': 'C-2', 'name': 'Ventilation and air conditioning system maintenance' }, { 'code': 'C-19', 'name': 'Voice announcement system maintenance' }, { 'code': 'D-6', 'name': 'Cut flowers and christmas trees' }, { 'code': 'D-1', 'name': 'Grounds maintenance services' }, { 'code': 'D-5', 'name': 'Internal planting' }, { 'code': 'D-3', 'name': 'Professional snow & ice clearance' }, { 'code': 'D-4', 'name': 'Reservoirs, ponds, river walls and water features maintenance' }, { 'code': 'D-2', 'name': 'Tree surgery (arboriculture)' }, { 'code': 'E-1', 'name': 'Asbestos management' }, { 'code': 'E-9', 'name': 'Building information modelling and government soft landings' }, { 'code': 'E-5', 'name': 'Compliance plans, specialist surveys and audits' }, { 'code': 'E-6', 'name': 'Conditions survey' }, { 'code': 'E-7', 'name': 'Electrical testing' }, { 'code': 'E-8', 'name': 'Fire risk assessments' }, { 'code': 'E-4', 'name': 'Portable appliance testing' }, { 'code': 'E-3', 'name': 'Statutory inspections' }, { 'code': 'E-2', 'name': 'Water hygiene maintenance' }, { 'code': 'F-1', 'name': 'Chilled potable water' }, { 'code': 'F-2', 'name': 'Retail services / convenience store' }, { 'code': 'F-3', 'name': 'Deli/coffee bar' }, { 'code': 'F-4', 'name': 'Events and functions' }, { 'code': 'F-5', 'name': 'Full service restaurant' }, { 'code': 'F-6', 'name': 'Hospitality and meetings' }, { 'code': 'F-7', 'name': 'Outside catering' }, { 'code': 'F-8', 'name': 'Trolley service' }, { 'code': 'F-9', 'name': 'Vending services (food & beverage)' }, { 'code': 'F-10', 'name': 'Residential catering services' }, { 'code': 'G-8', 'name': 'Cleaning of communications and equipment rooms' }, { 'code': 'G-13', 'name': 'Cleaning of curtains and window blinds' }, { 'code': 'G-5', 'name': 'Cleaning of external areas' }, { 'code': 'G-2', 'name': 'Cleaning of integral barrier mats' }, { 'code': 'G-4', 'name': 'Deep (periodic) cleaning' }, { 'code': 'G-10', 'name': 'Housekeeping' }, { 'code': 'G-11', 'name': 'It equipment cleaning' }, { 'code': 'G-16', 'name': 'Linen and laundry services' }, { 'code': 'G-14', 'name': 'Medical and clinical cleaning' }, { 'code': 'G-3', 'name': 'Mobile cleaning services' }, { 'code': 'G-15', 'name': 'Pest control services' }, { 'code': 'G-9', 'name': 'Reactive cleaning (outside cleaning operational hours)' }, { 'code': 'G-1', 'name': 'Routine cleaning' }, { 'code': 'G-12', 'name': 'Specialist cleaning' }, { 'code': 'G-7', 'name': 'Window cleaning (external)' }, { 'code': 'G-6', 'name': 'Window cleaning (internal)' }, { 'code': 'H-16', 'name': 'Administrative support services' }, { 'code': 'H-9', 'name': 'Archiving (on-site)' }, { 'code': 'H-12', 'name': 'Cable management' }, { 'code': 'H-7', 'name': 'Clocks' }, { 'code': 'H-3', 'name': 'Courier booking and external distribution' }, { 'code': 'H-10', 'name': 'Furniture management' }, { 'code': 'H-4', 'name': 'Handyman services' }, { 'code': 'H-2', 'name': 'Internal messenger service' }, { 'code': 'H-1', 'name': 'Mail services' }, { 'code': 'H-5', 'name': 'Move and space management - internal moves' }, { 'code': 'H-15', 'name': 'Portable washroom solutions' }, { 'code': 'H-6', 'name': 'Porterage' }, { 'code': 'H-13', 'name': 'Reprographics service' }, { 'code': 'H-8', 'name': 'Signage' }, { 'code': 'H-11', 'name': 'Space management' }, { 'code': 'H-14', 'name': 'Stores management' }, { 'code': 'I-1', 'name': 'Reception service' }, { 'code': 'I-3', 'name': 'Car park management and booking' }, { 'code': 'I-2', 'name': 'Taxi booking service' }, { 'code': 'I-4', 'name': 'Voice announcement system operation' }, { 'code': 'J-8', 'name': 'Additional security services' }, { 'code': 'J-2', 'name': 'Cctv / alarm monitoring' }, { 'code': 'J-3', 'name': 'Control of access and security passes' }, { 'code': 'J-4', 'name': 'Emergency response' }, { 'code': 'J-9', 'name': 'Enhanced security requirements' }, { 'code': 'J-10', 'name': 'Key holding' }, { 'code': 'J-11', 'name': 'Lock up / open up of buyer premises' }, { 'code': 'J-6', 'name': 'Management of visitors and passes' }, { 'code': 'J-1', 'name': 'Manned guarding service' }, { 'code': 'J-5', 'name': 'Patrols (fixed or static guarding)' }, { 'code': 'J-12', 'name': 'Patrols (mobile via a specific visiting vehicle)' }, { 'code': 'J-7', 'name': 'Reactive guarding' }, { 'code': 'K-1', 'name': 'Classified waste' }, { 'code': 'K-5', 'name': 'Clinical waste' }, { 'code': 'K-7', 'name': 'Feminine hygiene waste' }, { 'code': 'K-2', 'name': 'General waste' }, { 'code': 'K-4', 'name': 'Hazardous waste' }, { 'code': 'K-6', 'name': 'Medical waste' }, { 'code': 'K-3', 'name': 'Recycled waste' }, { 'code': 'L-1', 'name': 'Childcare facility' }, { 'code': 'L-2', 'name': 'Sports and leisure' }, { 'code': 'L-3', 'name': 'Driver and vehicle service' }, { 'code': 'L-4', 'name': 'First aid and medical service' }, { 'code': 'L-5', 'name': 'Flag flying service' }, { 'code': 'L-6', 'name': 'Journal, magazine and newspaper supply' }, { 'code': 'L-7', 'name': 'Hairdressing services' }, { 'code': 'L-8', 'name': 'Footwear cobbling services' }, { 'code': 'L-9', 'name': 'Provision of chaplaincy support services' }, { 'code': 'L-10', 'name': 'Housing and residential accommodation management' }, { 'code': 'L-11', 'name': 'Training establishment management and booking service' }, { 'code': 'M-1', 'name': 'CAFM system' }, { 'code': 'N-1', 'name': 'Helpdesk services' }, { 'code': 'O-1', 'name': 'Management of billable works' }], 'fm-building-type': 'General office - Customer Facing' }
    }
  end

  let(:building2) do
    {
      building_json:
      { 'id': 'F22D1C3A-6A5A-E496-7032-FE2AE034778A', 'gia': 3002, 'name': 'c4', 'region': 'London', 'address': { 'fm-address-town': 'London', 'fm-address-county': 'London', 'fm-address-line-1': '1 Horseferry Road', 'fm-address-postcode': 'SW1P 2BA' }, 'isLondon': 'No' }
    }
  end

  let(:building3) do
    {
      building_json:
      { 'id': 'DBBFD384-2098-2F35-A847-4D3521B3CC1E', 'gia': 3002, 'name': 'c4', 'region': 'London', 'address': { 'fm-address-town': 'London', 'fm-address-county': 'London', 'fm-address-line-1': '1 Horseferry Road', 'fm-address-postcode': 'SW1P 2BA' }, 'isLondon': 'No', 'services': [{ 'code': 'C-21', 'name': 'Airport and aerodrome maintenance services' }, { 'code': 'C-15', 'name': 'Audio visual (AV) equipment maintenance' }, { 'code': 'C-10', 'name': 'Automated barrier control system maintenance' }, { 'code': 'C-11', 'name': 'Building management system (BMS) maintenance' }, { 'code': 'C-14', 'name': 'Catering equipment maintenance' }, { 'code': 'C-3', 'name': 'Environmental cleaning' }, { 'code': 'C-4', 'name': 'Fire detection and firefighting systems maintenance' }, { 'code': 'C-13', 'name': 'High voltage (HV) and switchgear maintenance' }, { 'code': 'C-7', 'name': 'Internal and external building fabric maintenance' }, { 'code': 'C-5', 'name': 'Lifts, hoists and conveyance systems maintenance' }, { 'code': 'C-20', 'name': 'Locksmith services' }, { 'code': 'C-17', 'name': 'Mail room equipment maintenance' }, { 'code': 'C-1', 'name': 'Mechanical and electrical engineering maintenance' }, { 'code': 'C-18', 'name': 'Office machinery servicing and maintenance' }, { 'code': 'C-9', 'name': 'Planned / group re-lamping service' }, { 'code': 'C-8', 'name': 'Reactive maintenance services' }, { 'code': 'C-6', 'name': 'Security, access and intruder systems maintenance' }, { 'code': 'C-22', 'name': 'Specialist maintenance services' }, { 'code': 'C-12', 'name': 'Standby power system maintenance' }, { 'code': 'C-16', 'name': 'Television cabling maintenance' }, { 'code': 'C-2', 'name': 'Ventilation and air conditioning system maintenance' }, { 'code': 'C-19', 'name': 'Voice announcement system maintenance' }, { 'code': 'D-6', 'name': 'Cut flowers and christmas trees' }, { 'code': 'D-1', 'name': 'Grounds maintenance services' }, { 'code': 'D-5', 'name': 'Internal planting' }, { 'code': 'D-3', 'name': 'Professional snow & ice clearance' }, { 'code': 'D-4', 'name': 'Reservoirs, ponds, river walls and water features maintenance' }, { 'code': 'D-2', 'name': 'Tree surgery (arboriculture)' }, { 'code': 'E-1', 'name': 'Asbestos management' }, { 'code': 'E-9', 'name': 'Building information modelling and government soft landings' }, { 'code': 'E-5', 'name': 'Compliance plans, specialist surveys and audits' }, { 'code': 'E-6', 'name': 'Conditions survey' }, { 'code': 'E-7', 'name': 'Electrical testing' }, { 'code': 'E-8', 'name': 'Fire risk assessments' }, { 'code': 'E-4', 'name': 'Portable appliance testing' }, { 'code': 'E-3', 'name': 'Statutory inspections' }, { 'code': 'E-2', 'name': 'Water hygiene maintenance' }, { 'code': 'F-1', 'name': 'Chilled potable water' }, { 'code': 'F-2', 'name': 'Retail services / convenience store' }, { 'code': 'F-3', 'name': 'Deli/coffee bar' }, { 'code': 'F-4', 'name': 'Events and functions' }, { 'code': 'F-5', 'name': 'Full service restaurant' }, { 'code': 'F-6', 'name': 'Hospitality and meetings' }, { 'code': 'F-7', 'name': 'Outside catering' }, { 'code': 'F-8', 'name': 'Trolley service' }, { 'code': 'F-9', 'name': 'Vending services (food & beverage)' }, { 'code': 'F-10', 'name': 'Residential catering services' }, { 'code': 'G-8', 'name': 'Cleaning of communications and equipment rooms' }, { 'code': 'G-13', 'name': 'Cleaning of curtains and window blinds' }, { 'code': 'G-5', 'name': 'Cleaning of external areas' }, { 'code': 'G-2', 'name': 'Cleaning of integral barrier mats' }, { 'code': 'G-4', 'name': 'Deep (periodic) cleaning' }, { 'code': 'G-10', 'name': 'Housekeeping' }, { 'code': 'G-11', 'name': 'It equipment cleaning' }, { 'code': 'G-16', 'name': 'Linen and laundry services' }, { 'code': 'G-14', 'name': 'Medical and clinical cleaning' }, { 'code': 'G-3', 'name': 'Mobile cleaning services' }, { 'code': 'G-15', 'name': 'Pest control services' }, { 'code': 'G-9', 'name': 'Reactive cleaning (outside cleaning operational hours)' }, { 'code': 'G-1', 'name': 'Routine cleaning' }, { 'code': 'G-12', 'name': 'Specialist cleaning' }, { 'code': 'G-7', 'name': 'Window cleaning (external)' }, { 'code': 'G-6', 'name': 'Window cleaning (internal)' }, { 'code': 'H-16', 'name': 'Administrative support services' }, { 'code': 'H-9', 'name': 'Archiving (on-site)' }, { 'code': 'H-12', 'name': 'Cable management' }, { 'code': 'H-7', 'name': 'Clocks' }, { 'code': 'H-3', 'name': 'Courier booking and external distribution' }, { 'code': 'H-10', 'name': 'Furniture management' }, { 'code': 'H-4', 'name': 'Handyman services' }, { 'code': 'H-2', 'name': 'Internal messenger service' }, { 'code': 'H-1', 'name': 'Mail services' }, { 'code': 'H-5', 'name': 'Move and space management - internal moves' }, { 'code': 'H-15', 'name': 'Portable washroom solutions' }, { 'code': 'H-6', 'name': 'Porterage' }, { 'code': 'H-13', 'name': 'Reprographics service' }, { 'code': 'H-8', 'name': 'Signage' }, { 'code': 'H-11', 'name': 'Space management' }, { 'code': 'H-14', 'name': 'Stores management' }, { 'code': 'I-1', 'name': 'Reception service' }, { 'code': 'I-3', 'name': 'Car park management and booking' }, { 'code': 'I-2', 'name': 'Taxi booking service' }, { 'code': 'I-4', 'name': 'Voice announcement system operation' }, { 'code': 'J-8', 'name': 'Additional security services' }, { 'code': 'J-2', 'name': 'Cctv / alarm monitoring' }, { 'code': 'J-3', 'name': 'Control of access and security passes' }, { 'code': 'J-4', 'name': 'Emergency response' }, { 'code': 'J-9', 'name': 'Enhanced security requirements' }, { 'code': 'J-10', 'name': 'Key holding' }, { 'code': 'J-11', 'name': 'Lock up / open up of buyer premises' }, { 'code': 'J-6', 'name': 'Management of visitors and passes' }, { 'code': 'J-1', 'name': 'Manned guarding service' }, { 'code': 'J-5', 'name': 'Patrols (fixed or static guarding)' }, { 'code': 'J-12', 'name': 'Patrols (mobile via a specific visiting vehicle)' }, { 'code': 'J-7', 'name': 'Reactive guarding' }, { 'code': 'K-1', 'name': 'Classified waste' }, { 'code': 'K-5', 'name': 'Clinical waste' }, { 'code': 'K-7', 'name': 'Feminine hygiene waste' }, { 'code': 'K-2', 'name': 'General waste' }, { 'code': 'K-4', 'name': 'Hazardous waste' }, { 'code': 'K-6', 'name': 'Medical waste' }, { 'code': 'K-3', 'name': 'Recycled waste' }, { 'code': 'L-1', 'name': 'Childcare facility' }, { 'code': 'L-2', 'name': 'Sports and leisure' }, { 'code': 'L-3', 'name': 'Driver and vehicle service' }, { 'code': 'L-4', 'name': 'First aid and medical service' }, { 'code': 'L-5', 'name': 'Flag flying service' }, { 'code': 'L-6', 'name': 'Journal, magazine and newspaper supply' }, { 'code': 'L-7', 'name': 'Hairdressing services' }, { 'code': 'L-8', 'name': 'Footwear cobbling services' }, { 'code': 'L-9', 'name': 'Provision of chaplaincy support services' }, { 'code': 'L-10', 'name': 'Housing and residential accommodation management' }, { 'code': 'L-11', 'name': 'Training establishment management and booking service' }, { 'code': 'M-1', 'name': 'CAFM system' }, { 'code': 'N-1', 'name': 'Helpdesk services' }, { 'code': 'O-1', 'name': 'Management of billable works' }], 'fm-building-type': 'General office - Customer Facing' }
    }
  end

  let(:buildings) do
    [
      OpenStruct.new(building_json: building1),
      OpenStruct.new(building_json: building2),
      OpenStruct.new(building_json: building3)
    ]
  end

  let(:uvals) do
    []
  end
  # after do
  # end

  # context 'when condition' do
  #   it 'succeeds' do
  #     pending 'Not implemented'
  #   end
  # end

  it 'creates summary report' do
    report = FacilitiesManagement::SummaryReport.new(start_date, 'test@example.com', data)

    rates = CCS::FM::Rate.read_benchmark_rates

    # uvals = uom_values(selected_buildings)

    report.calculate_services_for_buildings buildings, uvals, rates

    # report.workout_current_lot
    # p report.assessed_value
    expect(report.assessed_value.round(2)).to be 0.00
  end

  it 'with rate card' do
    rate_card = CCS::FM::RateCard.latest

    rates = CCS::FM::Rate.read_benchmark_rates
    supplier_names = rate_card.data['Prices'].keys
    supplier_names.each do |s|
      # p s

      report = FacilitiesManagement::SummaryReport.new(start_date, 'test@example.com', data)
      # prices = rate_card.data['Prices'].keys.map { |k| rate_card.data['Prices'][k]['C.1'] }
      report.calculate_services_for_buildings buildings, uvals, rates, rate_card, s

      expect(report.assessed_value.round(2)).to be 0.00
    end

    # p rate_card
    expect(rate_card.nil?).to be false
  end

  # rubocop:disable RSpec/ExampleLength
  it 'can calculate prices' do
    # eligible = true if @building_type == 'STANDARD' && (@service_standard == 'A' || @service_standard.nil?) && @priced_at_framework.to_s == 'true' && Integer(@assessed_value) <= 1500000

    rates = CCS::FM::Rate.read_benchmark_rates

    sum_uom = 0
    sum_benchmark = 0

    contract_length_years = 7
    # code = 'A1'
    uom_value = 100
    occupants = 0
    tupe_flag = 'N'
    london_flag = 'N'
    cafm_flag = 'Y'
    helpdesk_flag = 'Y'

    services = ['C1', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C2', 'C20', 'C21', 'C22', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9', 'F1', 'F10', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'G1', 'G10', 'G11', 'G12', 'G13', 'G14', 'G15', 'G16', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8', 'G9', 'H1', 'H10', 'H11', 'H12', 'H13', 'H14', 'H15', 'H16', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'I1', 'I2', 'I3', 'I4', 'J1', 'J10', 'J11', 'J12', 'J2', 'J3', 'J4', 'J5', 'J6', 'J7', 'J8', 'J9', 'K1', 'K2', 'K3', 'K4', 'K5', 'K6', 'K7', 'L1', 'L10', 'L11', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8', 'L9', 'M1', 'N1', 'O1', 'M5', 'M136', 'M138', 'M140', 'M141', 'M142', 'M144', 'M148', 'M146']

    services.each do |code|
      calc_fm = FMCalculator::Calculator.new(contract_length_years, code, uom_value, occupants,
                                             tupe_flag, london_flag, cafm_flag, helpdesk_flag,
                                             rates)
      sum_uom += calc_fm.sumunitofmeasure
      sum_benchmark += calc_fm.benchmarkedcostssum
    end

    expect(sum_uom.round(2)).to be 958366.62
    expect(sum_benchmark.round(2)).to be 949771.07
  end
  # rubocop:enable RSpec/ExampleLength
end