module FacilitiesManagement
  module RM6232
    class UsersController < FacilitiesManagement::UsersController
      private

      def new_service_challenge_path
        facilities_management_rm6232_users_challenge_path(challenge_name: @challenge.new_challenge_name)
      end

      def after_sign_in_path_for(resource)
        stored_location_for(resource) || facilities_management_rm6232_path
      end

      def confirm_user_registration_path
        facilities_management_rm6232_users_confirm_path
      end
    end
  end
end