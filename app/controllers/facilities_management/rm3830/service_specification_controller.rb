module FacilitiesManagement
  module RM3830
    class ServiceSpecificationController < FacilitiesManagement::FrameworkController
      before_action :authorize_user

      def show
        parser = ServiceSpecificationParser.new
        @specification = parser.call(params[:service_code].tr('-', '.'), params[:work_package_code])
      end
    end
  end
end
