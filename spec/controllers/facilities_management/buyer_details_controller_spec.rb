require 'rails_helper'
# rubocop:disable RSpec/NamedSubject
module FacilitiesManagement
  RSpec.describe BuyerDetailsController, type: :controller do
    render_views

    describe 'GET edit' do
      login_fm_buyer_with_details

      before { get :edit, params: { id: subject.current_user.id } }

      it 'renders edit template' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end

    describe 'GET edit_address' do
      login_fm_buyer_with_details

      before { get :edit_address, params: { buyer_detail_id: subject.current_user.id } }

      it 'renders edit template' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit_address)
      end
    end

    describe 'PUT update' do
      login_fm_buyer_with_details

      context 'when updating from the edit page' do
        before { put :update, params: { id: subject.current_user.id, facilities_management_buyer_detail: { full_name: full_name } } }

        context 'when there are errors' do
          let(:full_name) { '' }

          it 'renders the edit template' do
            expect(response).to render_template(:edit)
          end
        end

        context 'when there are no errors' do
          let(:full_name) { 'Fred Flintstone' }

          it 'redirects to facilities_management_path' do
            expect(response).to redirect_to facilities_management_path
          end

          it 'updates the buyer name' do
            subject.current_user.reload

            expect(subject.current_user.buyer_detail.full_name).to eq full_name
          end
        end
      end

      context 'when updating from the edit_address page' do
        before { put :update, params: { id: subject.current_user.id, context: :update_address, facilities_management_buyer_detail: { organisation_address_line_1: organisation_address_line_1 } } }

        context 'when there are errors' do
          let(:organisation_address_line_1) { '' }

          it 'renders the edit_address template' do
            expect(response).to render_template(:edit_address)
          end
        end

        context 'when there are no errors' do
          let(:organisation_address_line_1) { '9 Downing Street' }

          it 'redirects to facilities_management_path' do
            expect(response).to redirect_to edit_facilities_management_buyer_detail_path(subject.current_user)
          end

          it 'updates the buyer name' do
            subject.current_user.reload

            expect(subject.current_user.buyer_detail.organisation_address_line_1).to eq organisation_address_line_1
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NamedSubject
