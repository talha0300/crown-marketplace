require 'rails_helper'

RSpec.describe 'layouts/application.html.erb' do
  it 'displays flash error messages' do
    flash[:error] = 'error-message'

    render
    page = Capybara.string(rendered)

    expect(page).to have_text('error-message')
  end

  it 'displays link to feedback email address' do
    render

    email = Marketplace.feedback_email_address
    expect(rendered).to have_link(href: "mailto:#{email}")
  end
end
