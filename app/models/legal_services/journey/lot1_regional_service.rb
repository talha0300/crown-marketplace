module LegalServices
  class Journey::Lot1RegionalService
    include Steppable
    def next_step_class
      Journey::Lot1RegionalService
    end
  end
end
