require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsHelper, type: :helper do
  describe '#get_service_question' do
    context 'when question is service_standard' do
      it 'will return service_standards' do
        result = helper.get_service_question(:service_standard)
        expect(result).to eq 'service_standards'
      end
    end

    context 'when question is lift_data' do
      it 'will return lifts' do
        result = helper.get_service_question(:lift_data)
        expect(result).to eq 'lifts'
      end
    end

    context 'when question is service_hours' do
      it 'will return service_hours' do
        result = helper.get_service_question(:service_hours)
        expect(result).to eq 'service_hours'
      end
    end

    context 'when question is no_of_appliances_for_testing' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_appliances_for_testing)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is no_of_building_occupants' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_appliances_for_testing)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is no_of_consoles_to_be_serviced' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_consoles_to_be_serviced)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is tones_to_be_collected_and_removed' do
      it 'will return volumes' do
        result = helper.get_service_question(:tones_to_be_collected_and_removed)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is no_of_units_to_be_serviced' do
      it 'will return volumes' do
        result = helper.get_service_question(:no_of_units_to_be_serviced)
        expect(result).to eq 'volumes'
      end
    end

    context 'when question is nil' do
      it 'will return service_standards' do
        result = helper.get_service_question(nil)
        expect(result).to eq 'area'
      end
    end
  end

  describe '#procurement_building_status' do
    let(:procurement_building) { create(:facilities_management_procurement_building, procurement: procurement) }
    let(:procurement) { create(:facilities_management_procurement, user: user) }
    let(:user) { create(:user) }

    before do
      @procurement_building = procurement_building
      allow(procurement_building).to receive(:complete?).and_return(answer)
    end

    context 'when the procurement_building is complete' do
      let(:answer) { true }

      it 'returns the COMPLETE status' do
        expect(helper.procurement_building_status).to eq [:blue, 'COMPLETE']
      end
    end

    context 'when the procurement_building is not complete' do
      let(:answer) { false }

      it 'returns the INCOMPLETE status' do
        expect(helper.procurement_building_status).to eq [:red, 'INCOMPLETE']
      end
    end
  end
end
