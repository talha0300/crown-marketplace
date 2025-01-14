module FacilitiesManagement
  module Admin
    class FrameworkController < ::ApplicationController
      before_action :authenticate_user!
      before_action :authorize_user
      before_action :raise_if_unrecognised_framework

      protected

      def authorize_user
        authorize! :manage, FacilitiesManagement::Admin
      end

      def rates
        @rates ||= FacilitiesManagement::RM3830::Admin::Rates.all
      end

      def full_services
        services = FacilitiesManagement::RM3830::StaticData.services
        work_packages = FacilitiesManagement::RM3830::StaticData.work_packages
        work_packages_with_rates = FacilitiesManagement::RM3830::Supplier::SupplierRatesHelper.add_rates_to_work_packages(work_packages, rates)
        @full_services = FacilitiesManagement::RM3830::Supplier::SupplierRatesHelper.work_package_to_services(services, work_packages_with_rates)
      end

      def redirect_if_lot_out_of_range
        redirect_to facilities_management_rm3830_admin_path unless ['1a', '1b', '1c'].include? @lot
      end

      def set_supplier
        @supplier = FacilitiesManagement::RM3830::Admin::SuppliersAdmin.find(params[:supplier_framework_datum_id])
        @supplier_id = @supplier.supplier_id.to_sym
      end

      def set_lot
        @lot = params[:lot]
      end
    end
  end
end
