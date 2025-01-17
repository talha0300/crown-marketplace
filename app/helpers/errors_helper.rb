module ErrorsHelper
  # Encapsulates the error rendering functions

  ERROR_TYPE = {
    too_short: 'minlength',
    blank: 'required',
    inclusion: 'required',
    too_long: 'maxlength',
    after: 'max',
    greater_than_or_equal_to: 'min',
    before: 'min',
    less_than: 'max',
    less_than_or_equal_to: 'max',
    greater_than: 'min',
    not_a_date: 'pattern',
    not_an_integer: 'number',
    not_a_number: 'number'
  }.freeze

  def list_errors_for_attributes(form, *attributes)
    attributes.each_with_index do |attribute, _index|
      collection = validation_messages(form.object.class.name.underscore.downcase.to_sym, attribute)
      capture do
        tag.div(class: 'error-collection govuk-visually-hidden', id: "error_#{form.object_name}_#{attribute}") do
          collection.each do |key, val|
            concat(govuk_validation_error({ model_object: form.object, attribute: attribute, error_type: key, text: val, form_object_name: form.object_name }, nil, nil))
          end
        end
      end
    end
  end

  # Renders a govuk compliant error-content div with a client-compatible validation type
  # and text for use as static content in the page
  # rubocop:disable Metrics/AbcSize
  def govuk_validation_error(model_data, error_lookup = nil, error_position = nil)
    tag_validation_type = ERROR_TYPE.include?(model_data[:error_type]) ? ERROR_TYPE[model_data[:error_type]] : model_data[:error_type]
    model_has_error = false
    model_has_error = error_lookup.call(model_data[:model_object], model_data[:error_type], error_position) unless error_lookup.nil?

    model_has_error = model_has_error?(model_data[:model_object], model_data[:error_type], model_data[:attribute]) if error_lookup.nil?

    css_classes = ['govuk-error-message']
    css_classes += ['govuk-visually-hidden'] unless model_has_error

    tag.label(tag.span(model_data[:text]), class: css_classes,
                                           for: "#{model_data[:form_object_name]}_#{model_data[:attribute]}",
                                           id: "#{model_data[:attribute]}-error",
                                           data: { propertyname: model_data[:attribute].to_s, validation: tag_validation_type })
  end
  # rubocop:enable Metrics/AbcSize

  def multiple_validation_errors(model_object, attribute, form_object_name, error_collection)
    label_for_id = form_object_name.include?(attribute.to_s) ? form_object_name : "#{form_object_name}_#{attribute}"

    tag.label(class: "govuk-error-message #{'govuk-visually-hidden' unless model_object.errors.any?}",
              for: label_for_id,
              id: "#{attribute}-error") do
      error_collection.each do |key, val|
        tag_validation_type = ERROR_TYPE.include?(key) ? ERROR_TYPE[key] : key
        concat(tag.span(val, class: "govuk-error-message #{'govuk-visually-hidden' unless attribute_has_errors(model_object, attribute, key)}", data: { propertyname: attribute.to_s, validation: tag_validation_type }))
      end
    end
  end

  def attribute_has_errors(model_object, attribute, error_type)
    model_object.errors.details[attribute][0]&.dig(:error) == error_type
  end

  # looks up the locals data for validation messages
  def validation_messages(model_object_sym, attribute_sym = nil)
    translation_key = "activerecord.errors.models.#{model_object_sym.downcase}.attributes"
    translation_key += if attribute_sym.is_a? Array
                         ".#{attribute_sym.join('.')}"
                       else
                         ".#{attribute_sym}"
                       end

    result = t(translation_key)
    if result.include? 'translation_missing'
      translation_key.sub! 'activerecord', 'activemodel'
      result = t(translation_key)
    end

    return {} if result.include? 'translation_missing'

    result
  end
end
