# rubocop:disable Metrics/BlockLength
require 'sidekiq/web'
require 'user_constraint.rb'
Rails.application.routes.draw do
  get '/', to: 'home#index'
  get '/status', to: 'home#status'
  get '/cookies', to: 'home#cookies'
  get '/landing-page', to: 'home#landing_page'

  mount Sidekiq::Web => '/sidekiq-log', :constraints => UserConstraint.new

  namespace 'supply_teachers', path: 'supply-teachers' do
    get '/', to: 'home#index'
    get '/cognito', to: 'gateway#index', cognito_enabled: true
    get '/gateway', to: 'gateway#index'
    get '/temp-to-perm-fee', to: 'home#temp_to_perm_fee'
    get '/fta-to-perm-fee', to: 'home#fta_to_perm_fee'
    get '/master-vendors', to: 'suppliers#master_vendors', as: 'master_vendors'
    get '/neutral-vendors', to: 'suppliers#neutral_vendors', as: 'neutral_vendors'
    get '/all-suppliers', to: 'suppliers#all_suppliers', as: 'all_suppliers'
    get '/agency-payroll-results', to: 'branches#index', slug: 'agency-payroll-results'
    get '/fixed-term-results', to: 'branches#index', slug: 'fixed-term-results', as: 'fixed_term_results'
    get '/nominated-worker-results', to: 'branches#index', slug: 'nominated-worker-results'
    resources :branches, only: %i[index show]
    resources :downloads, only: :index
    # unless Rails.env.production? # not be available on production environments yet
    namespace :admin do
      resources :uploads, only: %i[index new create show] do
        get 'approve'
        get 'reject'
        get 'uploading'
      end
      get '/in_progress', to: 'uploads#in_progress'
    end
    # end
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'facilities_management', path: 'facilities-management' do
    get '/', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    # get '/value-band', to: 'select_locations#select_location'
    get '/select-locations', to: 'select_locations#select_location', as: 'select_FM_locations'
    # get '/select-services', to: 'select_services#select_services', as: 'select_FM_services'
    # post '/select-services', to: 'select_services#select_services', as: 'select_FM_services'
    match 'select-services', to: 'select_services#select_services', as: 'select_FM_services', via: %i[get post]
    get '/suppliers/long-list', to: 'long_list#long_list'
    post '/suppliers/longList' => 'long_list#long_list'
    post '/standard-contract/questions', to: 'standard_contract_questions#standard_contract_questions'
    # post '/buildings-list', to: 'buildings#buildings'
    match '/buildings-list', to: 'buildings#buildings', via: %i[get post]
    post '/buildings/new-building', to: 'buildings#new_building'
    post '/buildings/new-building-address', to: 'buildings#manual_address_entry_form'
    post '/buildings/new-building-address/save-building' => 'buildings#save_building'
    post '/buildings/building-type', to: 'buildings#building_type'
    post '/buildings/update_building' => 'buildings#update_building'
    post '/buildings/select-services', to: 'buildings#select_services_per_building'

    post '/buildings/units-of-measurement', to: 'buildings#units_of_measurement'
    post '/buildings/save-uom-value' => 'buildings#save_uom_value'
    post '/services/save-lift-data' => 'select_services#save_lift_data'
    get '/buildings/region', to: 'buildings#region_info'
    get '/suppliers', to: 'suppliers#index'
    post '/buildings/delete_building' => 'buildings#delete_building'

    get '/start', to: 'journey#start', as: 'journey_start'
    # post '/contract-start', to: 'contract#start_of_contract'
    match '/contract-start', to: 'contract#start_of_contract', via: %i[get post]

    get '/summary', to: 'summary#index'
    post '/summary', to: 'summary#index'
    get '/directaward', to: 'direct_award#calc_eligibility'
    post '/cache/set', to: 'cache#set'
    post '/cache/get', to: 'cache#retrieve'
    post '/cache/clear_by_key', to: 'cache#clear_by_key'
    post '/cache/clear', to: 'cache#clear_all'
    get '/reset', to: 'buildings#reset_buildings_tables'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'management_consultancy', path: 'management-consultancy' do
    get '/', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    get '/suppliers', to: 'suppliers#index'
    get '/suppliers/download', to: 'suppliers#download', as: 'suppliers_download'
    get '/suppliers/:id', to: 'suppliers#show', as: 'supplier'
    get '/html/select-lot', to: 'html#select_lot'
    get '/html/select-services', to: 'html#select_services'
    get '/html/select-location', to: 'html#select_location'
    get '/html/supplier-detail', to: 'html#supplier_detail'
    get '/html/download-the-supplier-list', to: 'html#download_the_supplier_list'
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
    resources :uploads, only: :create if Marketplace.upload_privileges?
  end

  namespace 'apprenticeships', path: 'apprenticeships' do
    get '/', to: 'home#index'
    get '/gateway', to: 'gateway#index'
    get '/search', to: 'home#search'
    get '/search_results', to: 'home#search_results'
    get '/supplier_search', to: 'home#supplier_search'
    get '/supplier_search2', to: 'home#supplier_search2'
    get '/find_apprentices', to: 'home#find_apprentices'
    get '/find_apprentices2', to: 'home#find_apprentices2'
    get '/find_apprentices3', to: 'home#find_apprentices3'
    get '/find_apprentices4', to: 'home#find_apprentices4'
    get '/find_apprentices5', to: 'journey#find_apprentices5'
    get '/outline', to: 'home#outline'
    get '/requirements', to: 'home#requirements'
    get '/requirement', to: 'home#requirement'
    get '/building_services', to: 'home#building_services'
    get '/training_provider', to: 'home#training_provider'
    get '/training_provider_list', to: 'home#training_provider_list'
    get '/sorry', to: 'home#sorry'
    get '/signup', to: 'home#signup'
    get '/understanding', to: 'home#understanding'
    get '/training_details', to: 'home#training_details'
    get '/download_provider', to: 'home#download_provider'
    resources :suppliers, only: %i[index show]
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  namespace 'ccs_patterns', path: 'ccs-patterns' do
    get '/', to: 'home#index'
    get '/dynamic-accordian', to: 'home#dynamic_accordian'
    get '/supplier-results-v1', to: 'home#supplier_results_v1'
    get '/supplier-results-v2', to: 'home#supplier_results_v2'
    get '/small-checkboxes', to: 'home#small_checkboxes'
    get '/titles-checkboxes', to: 'home#titles_checkboxes'
    get '/numbered-pagination', to: 'home#numbered_pagination'
    get '/table-5050', to: 'home#table_5050'
    get '/supplier-detail', to: 'home#supplier_detail'
    get '/errors-find-apprentices', to: 'home#errors_find_apprentices'
    get '/errors-find-apprentices2', to: 'home#errors_find_apprentices2'
    get '/errors-find-apprentices3', to: 'home#errors_find_apprentices3'
    get '/errors-find-apprentices4', to: 'home#errors_find_apprentices4'
    get '/errors-requirements', to: 'home#errors_requirements'
    get '/cog-sign-in', to: 'home#cog_sign_in'
    get '/cog-sign-in-password-prompt-change', to: 'home#cog_sign_in_password_prompt_change'
    get '/cog-register', to: 'home#cog_register'
    get '/cog-register-enter-confirmation-code', to: 'home#cog_register_enter_confirmation_code'
    get '/cog-email', to: 'home#cog_email'
    get '/cog-email2', to: 'home#cog_email2'
    get '/cog-register-domain-not-on-whitelist', to: 'home#cog_register_domain_not_on_whitelist'
    get '/cog-forgot-password-request', to: 'home#cog_forgot_password_request'
    get '/cog-forgot-password-reset', to: 'home#cog_forgot_password_reset'
    get '/cog-forgot-password-reset2', to: 'home#cog_forgot_password_reset2'
    get '/cog-forgot-password-confirmation', to: 'home#cog_forgot_password_confirmation'
  end

  namespace 'legal_services', path: 'legal-services' do
    get '/', to: 'home#index'
    get '/service-not-suitable', to: 'home#service_not_suitable'
    get '/suppliers/download_shortlist', to: 'suppliers#download_shortlist'
    get '/suppliers/no-suppliers-found', to: 'suppliers#no_suppliers_found'
    get '/suppliers/cg-no-suppliers-found', to: 'suppliers#cg_no_suppliers_found'
    resources :suppliers, only: %i[index show]
    get '/start', to: 'journey#start', as: 'journey_start'
    get '/:slug', to: 'journey#question', as: 'journey_question'
    get '/:slug/answer', to: 'journey#answer', as: 'journey_answer'
  end

  get '/errors/404'
  get '/errors/422'
  get '/errors/500'
  get '/errors/maintenance'

  get '/auth/cognito', as: :cognito_sign_in
  get '/auth/cognito/callback' => 'auth#callback'
  if Marketplace.dfe_signin_enabled?
    get '/auth/dfe', as: :dfe_sign_in
    get '/auth/dfe/callback' => 'auth#callback'
  end
  post '/sign-out' => 'auth#sign_out', as: :sign_out

  # scope module: :postcode do
  #  resources :postcodes, only: :show
  # end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :postcodes, only: :show
      post '/postcode/:slug', to: 'uploads#postcodes'
    end
  end

  get '/:journey/start', to: 'journey#start', as: 'journey_start'
  get '/:journey/:slug', to: 'journey#question', as: 'journey_question'
  get '/:journey/:slug/answer', to: 'journey#answer', as: 'journey_answer'
end
# rubocop:enable Metrics/BlockLength
