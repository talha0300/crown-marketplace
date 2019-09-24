module FacilitiesManagement
  module Beta
    class ProcurementsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement, only: %i[show edit update]

      def index
        @procurements = current_user.procurements
      end

      def show; end

      def new
        set_suppliers(params[:region_codes], params[:service_codes])

        @supplier_count = CCS::FM::Supplier.supplier_count(params[:region_codes], params[:service_codes])
        @regions = Nuts2Region.where(code: params[:region_codes])
        @services = Service.where(code: params[:service_codes])
        @procurement = current_user.procurements.build(service_codes: params[:service_codes], region_codes: params[:region_codes])
      end

      def create
        @procurement = current_user.procurements.create(procurement_params)

        if @procurement.save
          redirect_to facilities_management_beta_procurement_url(id: @procurement.id)
        else
          render :new
        end
      end

      def edit; end

      def update
        if @procurement.update(procurement_params)
          redirect_to FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, step: params[:step]).route
        else
          render :edit
        end
      end

      def destroy; end

      private

      def procurement_params
        params.require(:facilities_management_procurement)
              .permit(
                :name,
                service_codes: [],
                region_codes: []
              )
      end

      def set_procurement
        @procurement = Procurement.find(params[:id])
      end

      def set_suppliers(region_codes, service_codes)
        @suppliers_lot1a = CCS::FM::Supplier.long_list_suppliers_lot(region_codes, service_codes, '1a')
        @suppliers_lot1b = CCS::FM::Supplier.long_list_suppliers_lot(region_codes, service_codes, '1b')
        @suppliers_lot1c = CCS::FM::Supplier.long_list_suppliers_lot(region_codes, service_codes, '1c')
      end
    end
  end
end
