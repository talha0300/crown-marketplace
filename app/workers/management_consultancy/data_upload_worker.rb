require 'rake'
module ManagementConsultancy
  class DataUploadWorker
    include Sidekiq::Worker

    def perform(upload_id)
      upload = ManagementConsultancy::Admin::Upload.find(upload_id)
      suppliers = JSON.parse(File.read(data_file))

      ManagementConsultancy::Upload.upload!(suppliers)

      upload.approve!
    rescue ActiveRecord::RecordInvalid => e
      summary = {
        record: e.record,
        record_class: e.record.class.to_s,
        errors: e.record.errors
      }

      fail_upload(ManagementConsultancy::Admin::Upload.find(upload_id), summary)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end

    def data_file
      if Rails.env.production?
        './storage/management_consultancy/current_data/output/data.json'
      else
        './storage/supply_teachers/management_consultancy/current_data/data.json'
      end
    end
  end
end
