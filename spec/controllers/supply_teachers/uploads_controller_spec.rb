require 'rails_helper'

RSpec.describe SupplyTeachers::UploadsController, type: :controller do
  describe 'POST create' do
    let(:suppliers) { [] }

    before do
      allow(SupplyTeachers::Upload).to receive(:upload!)
    end

    it 'creates suppliers and their associated data from JSON' do
      post :create, body: suppliers.to_json

      expect(SupplyTeachers::Upload)
        .to have_received(:upload!)
        .with(suppliers)
    end

    it 'responds with HTTP created status' do
      post :create, body: suppliers.to_json

      expect(response).to have_http_status(:created)
    end

    context 'when model validation error occurs' do
      before do
        allow(SupplyTeachers::Upload)
          .to receive(:upload!)
          .and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises ActiveRecord::RecordInvalid' do
        expect do
          post :create, body: suppliers.to_json
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when JSON is invalid' do
      it 'raises JSON::ParserError' do
        expect do
          post :create, body: '{'
        end.to raise_error(JSON::ParserError)
      end
    end
  end
end
