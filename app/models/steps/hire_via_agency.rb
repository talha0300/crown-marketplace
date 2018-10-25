module Steps
  class HireViaAgency < JourneyStep
    attribute :looking_for
    validates :looking_for, inclusion: ['worker', 'managed_service_provider']

    def next_step_class
      case looking_for
      when 'worker'
        NominatedWorker
      when 'managed_service_provider'
        ManagedServiceProvider
      end
    end
  end
end
