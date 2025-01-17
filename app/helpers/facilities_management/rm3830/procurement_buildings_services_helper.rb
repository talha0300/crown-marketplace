module FacilitiesManagement::RM3830::ProcurementBuildingsServicesHelper
  def volume_question(pbs)
    return unless pbs.this_service[:context].key? :volume

    pbs.this_service[:context][:volume]&.first
  end

  def service_standard_type
    @building_service.this_service[:context].select { |_, attributes| attributes.first == :service_standard }.keys.first
  end

  def sort_by_lifts_created_at
    parts = @building_service.lifts.partition { |o| o.created_at.nil? }
    parts.last.sort_by(&:created_at) + parts.first
  end

  def form_model
    params[:service_question] == 'area' ? @building : @building_service
  end

  def page_heading
    params[:service_question] == 'area' ? t('facilities_management.rm3830.procurement_buildings_services.area.heading') : @building_service.name
  end

  def per_annum_volume?(volume)
    %i[no_of_appliances_for_testing no_of_consoles_to_be_serviced tones_to_be_collected_and_removed no_of_units_to_be_serviced].include? volume
  end
end
