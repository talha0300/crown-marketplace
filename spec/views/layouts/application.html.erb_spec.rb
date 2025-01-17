require 'rails_helper'

RSpec.describe 'layouts/application.html.erb', type: :view do
  let(:support_link_feedback_address) { 'https://www.smartsurvey.co.uk/s/J1VQQI/' }

  before do
    allow(view).to receive(:user_signed_in?).and_return(false)
    allow(view).to receive(:ccs_homepage_url).and_return('https://CCSHOMEPAGE')
    allow(view).to receive(:service_path_base).and_return('/supply-teachers')

    cookies[:crown_marketplace_cookie_options_v1] = {
      value: {
        'settings_viewed' => true,
        'google_analytics_enabled' => true,
        'glassbox_enabled' => true
      }.to_json
    }

    allow(cookies.class).to receive(:new).and_return(cookies)
    allow(Marketplace).to receive(:google_analytics_tracking_id).and_return('123')
    allow(Marketplace).to receive(:google_tag_manager_tracking_id).and_return('456')
    allow(Marketplace).to receive(:fm_survey_link).and_return(support_link_feedback_address)
  end

  describe 'feedback links' do
    let(:support_link_selector) do
      %(a[href="#{support_form_link}"])
    end

    let(:feedback_link_selector) do
      %(a[href="#{support_link_feedback_address}"])
    end

    context 'when feedback email address is present' do
      let(:feedback_email_address) { 'feedback@something.com' }
      let(:support_form_link) { 'https://www.crowncommercial.gov.uk/contact' }

      it 'displays link to feedback email address in beta banner' do
        render

        expect(rendered).to have_css(".govuk-phase-banner #{feedback_link_selector}")
      end

      it 'displays link to support email address above footer' do
        render

        expect(rendered).to have_css(".footer-feedback #{support_link_selector}")
      end
    end
  end

  it 'includes google analytics partial' do
    stub_template 'shared/google/_analytics.html.erb' => 'GA GA GA GA'
    render
    expect(rendered).to match(/GA GA GA GA/)
  end

  it 'includes google tag manager partials' do
    stub_template 'shared/google/_tag_manager_body.html.erb' => 'GTM BODY'
    stub_template 'shared/google/_tag_manager_head.html.erb' => 'GTM HEAD'
    render
    expect(rendered).to match(/GTM BODY/)
    expect(rendered).to match(/GTM HEAD/)
  end

  it 'renders the page title stored in the locale file' do
    render
    expected = t('layouts.application.title')
    expect(rendered).to have_css('title', text: expected, visible: :hidden)
  end

  it 'adds an optional prefix to the page title' do
    view.content_for(:page_title_prefix) { 'Prefix' }
    render
    expected = "Prefix: #{t('layouts.application.title')}"
    expect(rendered).to have_css('title', text: expected, visible: :hidden)
  end
end
