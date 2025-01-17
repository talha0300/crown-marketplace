module FacilitiesManagement
  class FilesImporter::DataUploader
    def self.upload!(modle, &block)
      error = all_or_none(modle, &block)
      raise error if error
    end

    def self.all_or_none(transaction_class)
      error = nil
      transaction_class.transaction do
        yield
      rescue ActiveRecord::RecordInvalid => e
        error = e
        raise ActiveRecord::Rollback
      end
      error
    end
  end
end
