module FacilitiesManagement::Procurements::EditBuildingsHelper
  include FacilitiesManagement::BuildingsHelper

  def edit_link(change_answer, step)
    link_to((change_answer ? t('facilities_management.buildings.show.answer_question_text') : t('facilities_management.buildings.show.change_text')), edit_facilities_management_procurement_edit_building_path(step: step), role: 'link', class: 'govuk-link')
  end

  def cant_find_address_link
    add_address_facilities_management_procurement_edit_building_path
  end
end
