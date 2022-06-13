Then('I enter {string} into the contract name field') do |contract_name|
  @contract_name = contract_name
  procurement_page.contract_name_field.set(contract_name)
end

Then('I have a procurement with the name {string}') do |contract_name|
  create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:initial], user: @user, contract_name: contract_name)
end

Given('I have an empty procurement for entering requirements named {string}') do |contract_name|
  create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:empty_entering_requirements], user: @user, contract_name: contract_name)
end

Given('I have an empty procurement for entering requirements named {string} with the following servcies:') do |contract_name, service_codes_table|
  create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:empty_entering_requirements], user: @user, contract_name: contract_name, service_codes: service_codes_table.raw.flatten)
end

Given('I have an empty procurement with buildings named {string} with the following servcies:') do |contract_name, service_codes_table|
  procurement = create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:empty_entering_requirements], user: @user, contract_name: contract_name, service_codes: service_codes_table.raw.flatten)

  @user.buildings.each do |building|
    procurement.procurement_buildings.create(building: building, active: true)
  end
end

Given('I have a completed procurement for entering requirements named {string} with buildings missing regions') do |contract_name|
  procurement = create(FRMAEOWRK_AND_STATE_TO_FACTORY[@framework][:entering_requirements], user: @user, contract_name: contract_name)
  buildings = (1..3).map { |index| create(:facilities_management_building, building_name: "Test building #{index}", user: @user, address_postcode: 'ST161AA', address_region: nil, address_region_code: nil) }

  buildings.each do |building|
    procurement.procurement_buildings.create(building: building, active: true, service_codes: procurement.service_codes)
  end

  procurement.procurement_building_services.each { |pbs| pbs.update(service_standard: 'A') } if @framework == 'RM3830'
end

FRMAEOWRK_AND_STATE_TO_FACTORY = {
  'RM3830' => {
    initial: :facilities_management_rm3830_procurement,
    empty_entering_requirements: :facilities_management_rm3830_procurement_entering_requirements,
    entering_requirements: :facilities_management_rm3830_procurement_entering_requirements_complete
  },
  'RM6232' => {
    initial: :facilities_management_rm6232_procurement_what_happens_next,
    empty_entering_requirements: :facilities_management_rm6232_procurement_entering_requirements_empty,
    entering_requirements: :facilities_management_rm6232_procurement_entering_requirements
  }
}.freeze

Then('the procurement {string} is on the dashboard') do |contract_name|
  expect(procurement_page).to have_link(contract_name)
end