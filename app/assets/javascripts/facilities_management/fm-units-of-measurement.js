$(() => {

    let currentBuilding = pageUtils.getCachedData('fm-current-building');


    const init = (() => {
        $('#fm-building-name').text(currentBuilding.name);
    });

    $('#fm-unit-of-measurement-submit').click((e) => {
        e.preventDefault();
        let building_id = $('#fm-building-uom-id').attr('value');
        let service_code = $('#fm-service-uom-code').attr('value');
        let uom_value = $('#fm-uom-input').val();

        if (uom_value && uom_value.length > 0) {
            pageUtils.toggleInlineErrorMessage(false);
            fm.services.save_uom(building_id, service_code, uom_value);
        } else {
            pageUtils.toggleInlineErrorMessage(true);
        }


    });

});