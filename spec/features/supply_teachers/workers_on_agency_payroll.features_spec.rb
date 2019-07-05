require 'rails_helper'

RSpec.feature 'Workers on agency payroll', type: :feature, supply_teachers: true do
  before do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )
  end

  after do
    Geocoder::Lookup::Test.reset
  end

  scenario 'Buyer finds supplier within search range' do
    holborn = create(:supply_teachers_supplier, name: 'holborn')
    create(
      :supply_teachers_rate,
      supplier: holborn,
      job_type: 'qt_sen',
      term: 'twelve_weeks',
      mark_up: 0.35
    )
    create(
      :supply_teachers_branch,
      supplier: holborn,
      location: Geocoding.point(latitude: 51.5149666, longitude: -0.119098)
    )
    westminster = create(:supply_teachers_supplier, name: 'westminster')
    create(
      :supply_teachers_rate,
      supplier: westminster,
      job_type: 'qt_sen',
      term: 'twelve_weeks',
      mark_up: 0.30
    )
    create(
      :supply_teachers_branch,
      supplier: westminster,
      location: Geocoding.point(latitude: 51.5185614, longitude: -0.1437991)
    )
    whitechapel = create(:supply_teachers_supplier, name: 'whitechapel')
    create(
      :supply_teachers_branch,
      supplier: whitechapel,
      location: Geocoding.point(latitude: 51.5106034, longitude: -0.0604652)
    )
    create(
      :supply_teachers_rate,
      supplier: whitechapel,
      job_type: 'senior',
      term: 'twelve_weeks',
      mark_up: 0.30
    )
    liverpool = create(:supply_teachers_supplier, name: 'liverpool')
    create(
      :supply_teachers_branch,
      supplier: liverpool,
      location: Geocoding.point(latitude: 53.409189, longitude: -2.9946932)
    )

    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_worker')
    click_on I18n.t('common.submit')

    choose 'Yes'
    click_on I18n.t('common.submit')

    choose 'Yes'
    click_on I18n.t('common.submit')

    fill_in 'postcode', with: 'WC2B 6TE'
    choose '4 weeks to 8 weeks'
    choose 'Qualified teacher: SEN roles'
    click_on I18n.t('common.submit')

    expect(page).not_to have_text('whitechapel'), 'suppliers without appropriate rates should not be displayed'

    branches = page.all('.supplier-record')
    cheaper_branch = branches.first
    costlier_branch = branches.last

    expect(cheaper_branch.find('h2').text).to eq('westminster')
    expect(cheaper_branch).to have_css('.supplier-record__distance', text: '1.1')
    expect(cheaper_branch).to have_css('.supplier-record__markup-rate', text: '30.0%')

    expect(costlier_branch.find('h2').text).to eq('holborn')
    expect(costlier_branch).to have_css('.supplier-record__distance', text: '0.0')
    expect(costlier_branch).to have_css('.supplier-record__markup-rate', text: '35.0%')

    expect(page).not_to have_text('liverpool')

    click_on '1 mile'
    expect(page.all('.supplier-record').length).to eq(1)
  end
end
