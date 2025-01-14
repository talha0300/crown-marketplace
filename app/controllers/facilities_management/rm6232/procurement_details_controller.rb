module FacilitiesManagement
  module RM6232
    class ProcurementDetailsController < FacilitiesManagement::ProcurementDetailsController
      private

      def set_procurement
        @procurement = Procurement.find(params[:procurement_id])
      end

      RECOGNISED_DETAILS_EDIT_STEPS = %i[contract_name annual_contract_value tupe contract_period services buildings].freeze
      RECOGNISED_DETAILS_SHOW_PAGES = %i[contract_period services buildings buildings_and_services].freeze
    end
  end
end
