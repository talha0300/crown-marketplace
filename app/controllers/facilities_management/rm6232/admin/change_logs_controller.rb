module FacilitiesManagement
  module RM6232
    module Admin
      class ChangeLogsController < FacilitiesManagement::Admin::FrameworkController
        before_action :redirect_if_unrecognised_change_type, :set_change_log, only: :show

        helper_method :change_type

        def index
          respond_to do |format|
            format.html { @audit_logs = Kaminari.paginate_array(SupplierData.audit_logs).page(params[:page]) }
            format.csv do
              send_data ChangeLogsCsvGenerator.generate_csv, filename: "Full change logs (#{DateTime.now.in_time_zone('London').strftime('%d_%m_%Y %H_%M').squish}).csv", type: 'text/csv'
            end
          end
        end

        def show; end

        private

        def change_type
          @change_type ||= params[:change_type].to_sym
        end

        def set_change_log
          @change_log = if change_type == :upload
                          SupplierData.find(params[:change_log_id])
                        else
                          SupplierData::Edit.find(params[:change_log_id])
                        end
        end

        def redirect_if_unrecognised_change_type
          redirect_to facilities_management_rm6232_admin_change_logs_path unless RECOGNISED_CHANGE_TYPES.include? change_type
        end

        RECOGNISED_CHANGE_TYPES = %i[upload details lot_data].freeze
      end
    end
  end
end
