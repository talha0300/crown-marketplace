Given 'I sign in and navigate to my account' do
  visit facilities_management_new_user_session_path
  create_user_with_details
  fill_in 'email', with: @user.email
  fill_in 'password', with: nil
  click_on 'Sign in'
  expect(page.find('h1')).to have_content(@user.email)
end

Given('I have buildings') do
  create(:facilities_management_building, building_name: 'Test building', user: @user)
  create(:facilities_management_building_london, building_name: 'Test London building', user: @user)
end

Then 'I am on the {string} page' do |title|
  expect(page.find('h1')).to have_content(title)
end

Then 'I am on the page with secondary heading {string}' do |title|
  expect(page.find('h2')).to have_content(title.to_s)
end

Then('I should see the following secondary headings:') do |table|
  expect(page.all('h2').map(&:text)).to include(*table.raw.flatten)
end

When 'I click on {string}' do |button_text|
  click_on(button_text)
end

Then('the following content should be displayed on the page:') do |table|
  page_text = page.find('#main-content').text

  table.raw.flatten.each do |item|
    expect(page_text).to include(item)
  end
end

Then('I should see the following error messages:') do |table|
  expect(page).to have_css('div.govuk-error-summary')
  expect(page.find('.govuk-error-summary__list').find_all('a').map(&:text).reject(&:empty?)).to eq table.raw.flatten
end

Then('I open the {string} details') do |summary_text|
  page.find('details > summary', text: summary_text).click
end

Then('I enter the following details into the form:') do |table|
  table.raw.to_h.each do |field, value|
    fill_in field, with: value
  end
end

Then('I navigate to the building summary page for {string}') do |building_name|
  visit facilities_management_buildings_path
  click_on building_name
  step "I am on the buildings summary page for '#{building_name}'"
end

Given('I click on the {string} return link') do |link_text|
  page.find('.govuk-link, .govuk-link--no-visited-state', text: link_text).click
end

Given('I click on the {string} back link') do |link_text|
  page.find('.govuk-back-link', text: link_text).click
end

When('I navigate to the procurement {string}') do |contract_name|
  step 'I click on "Continue a procurement"'
  step "I click on '#{contract_name}'"
end

And('I click on the button with text {string}') do |button_text|
  page.find("input[value='#{button_text}']").send_keys(:return)
end

And('I click on the link with text {string}') do |button_text|
  page.find('a', text: button_text).send_keys(:return)
end

And('I start a procurement') do
  step "I click on 'Start a procurement'"
  step "I am on the 'What happens next' page"
  step "I click on 'Continue'"
  step "I am on the 'Contract name' page"
  step "I enter 'Test procurement' into the contract name field"
  step "I click on 'Save and continue'"
  step "I am on the 'Requirements' page"
end

Then('I pause') do
  # binding.pry
  pending 'This step is used for debugging features'
end