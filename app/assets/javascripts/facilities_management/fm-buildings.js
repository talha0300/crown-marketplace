$(() => {

    let postCode = "";

    const init = (() => {

        let newBuildingName = pageUtils.getCachedData('fm-new-building-name');

        if (newBuildingName) {
            $('#fm-new-building-name').val(newBuildingName);
        }

        let currentBuilding = pageUtils.getCachedData('fm-current-building');
        let gia = currentBuilding ? currentBuilding['gia'] : 0;

        $('#fm-internal-square-area').val(gia);

    });

    const validateBuildingName = ((value) => {

        if (value) {
            pageUtils.setCachedData('fm-new-building-name', value);
            $('#fm-building-name-error').addClass('govuk-visually-hidden');
            $('#fm-building-name-container').removeClass('govuk-form-group--error');
        } else {
            $('#fm-building-name-error').removeClass('govuk-visually-hidden');
            $('#fm-building-name-container').addClass('govuk-form-group--error');
            pageUtils.clearCashedData('fm-new-building-name');
        }

    });

    $('#fm-new-building-name').on('keyup', (e) => {
        let value = e.target.value;
        validateBuildingName(value);
    });

    $('#fm-postcode-input').on('focus', (e) => {
        let newBuildingValue = $('#fm-new-building-name');

        validateBuildingName(newBuildingValue.val());
    });

    $('#fm-postcode-input').on('keyup', (e) => {

        if (pageUtils.isPostCodeValid(e.target.value)) {
            showPostCodeError(false);
            postCode = e.target.value;
        } else {
            postCode = "";
        }
    });

    const showPostCodeError = ((show, errorMsg) => {

        errorMsg = errorMsg || "The postcode entered is invalid";
        if (show === true) {
            $('#fm-postcode-error').text(errorMsg);
            $('#fm-postcode-error').removeClass('govuk-visually-hidden');
            $('#fm-postcode-error-form-group').addClass('govuk-form-group--error');
        } else {
            $('#fm-postcode-error').addClass('govuk-visually-hidden');
            $('#fm-postcode-error-form-group').removeClass('govuk-form-group--error');
        }
    });

    const isPostCodeInLondon = ((postcode) => {

        pageUtils.clearCashedData('fm-postcode-is-in-london');

        $.get(encodeURI("/postcodes/in_london?postcode=" + postcode))
            .done(function (data) {
                if (data.status === 200) {
                    pageUtils.setCachedData('fm-postcode-is-in-london', data.result);
                }

                if (data && data.status === 404) {
                    showPostCodeError(true, data.error);
                }
            })
            .fail(function (data) {
                showPostCodeError(true, data.error);
            });
    });

    const getRegion = ((post_code) => {

        $.get(encodeURI("/facilities-management/buildings/region?post_code=" + post_code.trim()))
            .done(function (data) {
                if (data) {
                    pageUtils.setCachedData('fm-current-region', data.result.region);
                }
            })
            .fail(function (data) {
                showPostCodeError(true, data.error);
            });
    });

    $('#fm-postcode-lookup-results').on('change', (e) => {
        let selectedAddress = $("select#fm-postcode-lookup-results > option:selected").val();
        if (selectedAddress) {
            let addressElements = selectedAddress.split(',');
            getRegion(addressElements[4]);
            let address = {};

            address['fm-address-line-1'] = addressElements[0];
            address['fm-address-line-2'] = addressElements[1];
            address['fm-address-town'] = addressElements[2];
            address['fm-address-county'] = addressElements[3];
            address['fm-address-postcode'] = addressElements[4];

            pageUtils.setCachedData('fm-new-address', address);
        }

    });

    $('#fm-post-code-lookup-button').click((e) => {
        e.preventDefault();
        if (pageUtils.isPostCodeValid(postCode)) {
            pageUtils.setCachedData('fm-postcode', postCode.toUpperCase());
            pageUtils.clearCashedData('fm-new-address');
            showPostCodeError(false);
            isPostCodeInLondon(postCode);

            $('#fm-postcode-label').text(postCode);
            $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
            $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');
            $('#fm-postcode-lookup-results').find('option').remove();
            $('#fm-postcode-lookup-results').append('<option value="status-option" selected>0 addresses found</option>');

            $.get(encodeURI("/postcodes/" + postCode.toUpperCase()))
                .done(function (data) {
                    if (data && data.result && data.result.length > 0) {
                        $('#fm-postcode-lookup-results').find('option').remove();
                        $('#fm-postcode-lookup-results').append('<option value="status-option" selected>' + data.result.length + ' addresses found</option>');
                        let addresses = data.result;
                        addresses.forEach((address, index) => {
                            let add1 = address['add1'] ? address['add1'] + ', ' : '';
                            let add2 = address['village'] ? address['village'] + ', ' : '';
                            let postTown = address['post_town'] ? address['post_town'] + ', ' : '';
                            let county = address['county'] ? address['county'] + ', ' : '';
                            let postCode = address['postcode'] ? address['postcode'] : '';
                            let newOptionData = add1 + add2 + postTown + county + postCode;
                            let newOption = '<option value="' + newOptionData + '">' + newOptionData + '</option>';
                            $('#fm-postcode-lookup-results').append(newOption);
                            $('#fm-post-code-results-container').removeClass('govuk-visually-hidden');
                            $('#fm-postcode-lookup-container').addClass('govuk-visually-hidden');
                        })
                    }
                })
                .fail(function (data) {
                    showPostCodeError(true, data.error);
                });
        } else {
            showPostCodeError(true);
        }
    });

    $('#fm-change-postcode').click((e) => {
        $('#fm-post-code-results-container').addClass('govuk-visually-hidden');
        $('#fm-postcode-lookup-container').removeClass('govuk-visually-hidden');
    });

    $('#fm-buildings-add-building').click((e) => {
        pageUtils.clearCashedData('fm-current-building');
    });

    $('#fm-internal-square-area').change((e) => {

        let value = e.target.value;

        if (value && value !== "") {
            pageUtils.setCachedData('fm-gia', value);
        }

    });

    $('input[name="fm-builing-type-radio"]').click((e) => {
        let value = e.target.value;
        let buildingTypeOther = $('#other-building-type').value;
        let currentBuilding = pageUtils.getCachedData('fm-current-building');
        currentBuilding['fm-building-type'] = value;

        pageUtils.toggleInlineErrorMessage(false);

        if (value === "not-in-list") {
            currentBuilding['fm-building-type'] = buildingTypeOther;
        }

        pageUtils.setCachedData('fm-current-building', currentBuilding);
    });

    const isBuildingTypeValid = (() => {
        let len = $('input[name="fm-builing-type-radio"]:radio:checked').length;
        let result = true;

        if (!len) {
            result = false;
        }

        let radioValue = $('input[name="fm-builing-type-radio"]:radio:checked').val();
        let otherType = $('#other-building-type').val();

        if (radioValue && radioValue === 'not-in-list' && !otherType) {
            result = false;
        }

        return result;
    });

    $('#fm-building-type-continue').click((e) => {
        if (isBuildingTypeValid() === true) {
            pageUtils.toggleInlineErrorMessage(false);
            let currentBuilding = pageUtils.getCachedData('fm-current-building');
            fm.services.updateBuilding(currentBuilding, true, '/facilities-management/buildings/select-services');
        } else {
            pageUtils.toggleInlineErrorMessage(true);
        }
    });

    init();
});