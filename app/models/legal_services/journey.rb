module LegalServices
  class Journey < GenericJourney
    include Rails.application.routes.url_helpers

    def initialize(slug, params)
      byebug
      paths = JourneyPaths.new(self.class.journey_name)
      byebug
      first_step_class = ChooseOrganisationType
      super(first_step_class, slug, params, paths)
    end

    def self.journey_name
      'legal-services'
    end

    def start_path
      legal_services_path
    end
  end
end
