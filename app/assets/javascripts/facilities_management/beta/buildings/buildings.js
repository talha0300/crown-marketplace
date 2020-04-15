function FindAddressComponent($module) {
    this.module = $module;
    this.prefix = this.module.dataset.element_prefix;
    this.inputHistory = [];
    this.init();
}

FindAddressComponent.prototype.init = function () {
    if (!this.module) return;

    this.btnTrigger = this.module.querySelector('button[data-module-element="trigger"]');
    if (!this.btnTrigger) return;

    this.sourceContainer = this.module.querySelector('[data-module-part="' + this.prefix + '-source-container"]');
    this.sourceInput = this.module.querySelector('input[data-module-element="' + this.prefix + '-source-input"]');
    if (!this.sourceInput) return;

    if (this.sourceInput.value !== '') this.inputHistory.push(this.sourceInput.value);

    this.btnChangeInput = this.module.querySelectorAll('[data-module-element="change-input"]');

    this.lookupHandler = new LookupHandler(this.module);
    this.shortcutHelpers = this.module.querySelectorAll('[data-module-helper="' + this.prefix + '"]');
    this.bindEvents();
};

FindAddressComponent.prototype.bindEvents = function () {
    var restartFn = this.restart.bind(this);

    this.btnTrigger.addEventListener('click', this.lookupInput.bind(this));
    $(this.btnChangeInput).on('click', function (e) {
        e.preventDefault();
        restartFn();
    });
    $(this.shortcutHelpers).on('click', this.fireInputAutomatically.bind(this));
};

FindAddressComponent.prototype.refreshRegion = function (e) {
    this.lookupHandler.regionDisplayText.innerHTML = "&hellip;";
    var handler =
        window.setTimeout(this.lookupRegion.bind(this), 500);

};

FindAddressComponent.prototype.fireInputAutomatically = function (event) {
    this.sourceInput.value = event.target.innerText;
    this.lookupInput(event);
};

FindAddressComponent.prototype.lookupInput = function (e) {
    e.preventDefault();
    var input = pageUtils.destructurePostCode(this.sourceInput.value);
    if (input.valid) {
        var sourceInput = input.formattedInput();
        var displayResultsFn = this.displayResults.bind(this);
        var noResultsFn = this.noResults.bind(this);
        var lookupRegionFn = this.lookupRegion.bind(this);

        this.lookupHandler.reset();
        this.lookupHandler.showRegionSection(false);
        this.lookupHandler.hideRegionResults();
        $(this.sourceContainer).addClass("govuk-visually-hidden");
        $.get(encodeURI("/api/v2/postcodes/" + sourceInput)).done(function (data, status, jq) {
            if (data && data.result && data.result.length > 0) {
                displayResultsFn(sourceInput, data.result);
                if (data.result[0].address_region === null) {
                    this.lookupHandler.hideRegionResults(false);
                    lookupRegionFn();
                }
            } else {
                lookupRegionFn();
                noResultsFn(sourceInput, data.result);
            }
        }.bind(this)).fail(noResultsFn);
    }
};

FindAddressComponent.prototype.lookupRegion = function (e) {
    var postcode = pageUtils.formatPostCode(this.sourceInput.value);

    var postcode = postcode.substr(0, postcode.indexOf(' '));
    var displayRegionResults = this.displayRegionResults.bind(this);
    var noResults = this.noRegionResults.bind(this);
    $.get(encodeURI("/api/v2/find-region-postcode/" + postcode)).done(function (data, status, jq) {
        if (data && data.result && data.result.length > 0) {
            displayRegionResults(data.result);
        } else {
            noResults(data.result);
        }
    }.bind(this)).fail(noResults);
};

FindAddressComponent.prototype.displayResults = function (postcode, data) {
    if (data.length > 0) {
        this.lookupHandler.clearResultsList();
        this.lookupHandler.showResults(postcode, data);
    } else {
        this.noResults(postcode, data);
    }
};

FindAddressComponent.prototype.displayRegionResults = function (data) {
    if (data.length > 0) {
        this.lookupHandler.clearRegionResultsList();
        this.lookupHandler.showRegionResults(data);
    } else {
        this.noRegionResults(data);
    }
};

FindAddressComponent.prototype.restart = function () {
    $(this.sourceContainer).removeClass("govuk-visually-hidden");
    this.lookupHandler.hideResults();
};

FindAddressComponent.prototype.noResults = function (postcode, data) {
    this.lookupHandler.clearResultsList();
    this.lookupHandler.showResults(postcode, []);
    this.lookupHandler.cantFindAddress(true);
};

FindAddressComponent.prototype.noRegionResults = function (data) {
    this.lookupHandler.clearRegionResultsList();
    this.lookupHandler.showRegionResults([]);
};

function LookupHandler(findAddressModule) {
    this.resultsContainer = null;
    this.resultsDropDown = null;
    this.regionDropDown = null;
    this.addressDisplay = null;
    this.addressDisplayText = null;
    this.btnCantFindAddress = null;
    this.btnChangeRegion = null;
    this.postcodeDisplay = null;
    this.lookupResultsContainer = null;
    this.lookupRegionResultsContainer = null;

    this.parent = findAddressModule;
    this.init(this.parent);
}

LookupHandler.prototype.init = function () {
    if (!this.parent) return;

    this.resultsContainer = this.parent.querySelector('[data-module-part="lookup-container"]');
    //this.regionResultsContainer = this.parent.querySelector('[]');
    this.lookupResultsContainer = this.parent.querySelector('[data-module-part="lookup-results"]');
    this.lookupRegionResultsContainer = this.parent.querySelector('[data-module-part="lookup-region-results"]');
    if (!this.resultsContainer) return;

    this.regionArea = this.resultsContainer.querySelector('[data-module-part="region-display"]');
    this.resultsDropDown = this.resultsContainer.querySelector('[data-module-element="results-container"]');
    this.addressDisplay = this.parent.querySelector('[data-module-part="address-display"]');
    this.regionDisplay = this.parent.querySelector('[data-module-part="region-display"]');
    this.addressDisplayText = this.addressDisplay.querySelector('[data-module-part="address_text"]');
    this.regionResults = this.resultsContainer.querySelector('[data-module-part="region-results"]');
    this.regionDisplayText = this.resultsContainer.querySelector('[data-module-part="region-text"]');
    if (!this.resultsDropDown || !this.addressDisplay) return;

    this.regionDropDown = this.resultsContainer?.querySelector('[data-module-element="region-results-container"]');
    this.btnCantFindAddress = this.resultsContainer.querySelector('[data-module-element="cant-find"]');
    this.postcodeDisplay = this.resultsContainer.querySelector('[data-module-element="postcode-entry-text"]')
    this.btnChangeRegion = this.resultsContainer.querySelector('[data-module-element="change-region-button"]');
    var lookupRegion = this.showRegionChoices.bind(this);
    this.resultsDropDown.addEventListener('change', this.selectResult.bind(this));

    $(this.btnChangeRegion).on('click', function (e) {
        e.preventDefault();
        lookupRegion(e);
    });
    this.regionDropDown.addEventListener('change', this.selectRegionResult.bind(this));
};

LookupHandler.prototype.reset = function () {
    this.clearResultsList();
    this.clearRegionResultsList();
    this.adjustIndicatorOption(this.resultsDropDown, 0);
    this.adjustIndicatorOption(this.regionDropDown, 0);
    this.resultsDropDown.removeEventListener('change', this.selectResult.bind(this));
};

LookupHandler.prototype.clearResultsList = function () {
    if (this.resultsDropDown.options.length > 0) {
        for (var i = this.resultsDropDown.options.length; i >= 0; i--) {
            this.resultsDropDown.remove(i);
        }
    }
};

LookupHandler.prototype.clearRegionResultsList = function () {
    if (this.regionDropDown.options.length > 0) {
        for (var i = this.regionDropDown.options.length; i >= 0; i--) {
            this.regionDropDown.remove(i);
        }
    }
};

LookupHandler.prototype.showRegionChoices = function () {
    var classname = 'govuk-visually-hidden';
    $(this.regionDisplayText).addClass(classname);
    $(this.lookupRegionResultsContainer).removeClass(classname);
    this.regionDropDown.selectedIndex = 0;
    $(this.btnChangeRegion).addClass(classname);

};

LookupHandler.prototype.cantFindAddress = function (bShow) {
    var classname = 'govuk-visually-hidden';
    if (bShow) {
        $(this.btnCantFindAddress).removeClass('govuk-visually-hidden');
    } else {
        $(this.btnCantFindAddress).addClass('govuk-visually-hidden');
    }
};

LookupHandler.prototype.showResults = function (postcode, addresses) {
    this.cantFindAddress(true);
    this.postcodeDisplay.innerHTML = postcode;
    $(this.addressDisplay).addClass('govuk-visually-hidden');
    this.populateDropDown(addresses);
    this.changeAddressContainerVisibility(true);
};

LookupHandler.prototype.hideResults = function (postcode, addresses) {
    this.postcodeDisplay.innerHTML = "";
    this.reset();
    this.changeAddressContainerVisibility(false);
};

LookupHandler.prototype.showRegionSection = function (bShow) {
    var classname = "govuk-visually-hidden";
    if (!bShow) {
        $(this.regionArea).addClass(classname);
    } else {
        $(this.regionArea).removeClass(classname);
    }
};

LookupHandler.prototype.showRegionResults = function (regions) {
    this.populateRegionDropDown(regions);
    this.changeRegionContainerVisibility(true);
    this.showRegionText(false);
};

LookupHandler.prototype.showRegionText = function (bShow) {
    var classname = "govuk-visually-hidden";
    if (!bShow) {
        $(this.regionDisplayText).addClass(classname);
    } else {
        $(this.regionDisplayText).removeClass(classname);
    }
};

LookupHandler.prototype.hideRegionResults = function (postcode, addresses) {
    this.changeRegionContainerVisibility(false);
};

LookupHandler.prototype.showDecision = function () {
    var classname = 'govuk-visually-hidden';
    $(this.addressDisplay).removeClass(classname);
    $(this.lookupResultsContainer).addClass(classname);
    this.showRegionSection(true);
};

LookupHandler.prototype.showRegionDecision = function () {
    var classname = 'govuk-visually-hidden';
    this.showRegionResults(true);
    this.showRegionText(true);
    $(this.regionResults).removeClass(classname);
    $(this.regionDisplay).removeClass(classname);
    $(this.lookupRegionResultsContainer).addClass(classname);
};

LookupHandler.prototype.selectResult = function (e) {
    var selectedOption = null;
    if (this.resultsDropDown.selectedIndex <= 0) return;

    selectedOption = this.resultsDropDown.selectedOptions[0];

    $("#address-line-1").val(selectedOption.dataset.address_line_1);
    $("#address-line-2").val(selectedOption.dataset.address_line_2);
    $("#address-town").val(selectedOption.dataset.address_town);
    $("#address-postcode").val(selectedOption.dataset.address_postcode);
    if (selectedOption.dataset.address_region !== "null") {
        $("#address-region").val(selectedOption.dataset.address_region);
        $("#address-region-code").val(selectedOption.dataset.address_region_code);
        $(this.regionDisplayText).text(selectedOption.dataset.address_region);
        $(this.btnChangeRegion).addClass('govuk-visually-hidden');
    }

    $(this.addressDisplayText).text(selectedOption.innerText + ", " + selectedOption.dataset.address_postcode);
    this.showDecision();
};

LookupHandler.prototype.selectRegionResult = function (e) {
    var selectedOption = null;
    if (this.regionDropDown.selectedIndex <= 0) return;
    selectedOption = this.regionDropDown.selectedOptions[0];
    $("#address-region").val(selectedOption.dataset.address_region);
    $("#address-region-code").val(selectedOption.dataset.address_region_code);
    $(this.regionDisplayText).text(selectedOption.dataset.address_region);
    this.showRegionText(true);
    if (this.regionDropDown.options.length > 2) {
        $(this.btnChangeRegion).removeClass('govuk-visually-hidden');
    } else {
        $(this.btnChangeRegion).addClass('govuk-visually-hidden');
    }
    this.showRegionDecision();
};

LookupHandler.prototype.populateDropDown = function (addresses) {
    if (addresses.length > 0) {
        var newOption = document.createElement('option');
        newOption.innerText = 'Please select an address';
        this.resultsDropDown.add(newOption);
        for (var i = 0; i < addresses.length; i++) {
            var address = addresses[i];
            newOption = document.createElement('option');
            newOption.value = address;
            newOption.innerText = address.summary_line;
            newOption.dataset.address_line_1 = address.address_line_1;
            newOption.dataset.address_line_2 = address.address_line_2;
            newOption.dataset.address_town = address.address_town;
            newOption.dataset.address_postcode = address.address_postcode;
            newOption.dataset.address_town = address.address_town;
            newOption.dataset.address_region = address.address_region;
            newOption.dataset.address_region_code = address.address_region_code;
            this.resultsDropDown.add(newOption);
        }
        /*if (addresses.length === 1) {
            this.resultsDropDown.selectedIndex = 1;
        }*/
    }
    this.adjustIndicatorOption(this.resultsDropDown, addresses.length);
};

LookupHandler.prototype.populateRegionDropDown = function (regions) {
    if (regions.length > 0) {
        var newOption = document.createElement('option');
        newOption.innerText = 'Please select a region';
        this.regionDropDown.add(newOption);
        for (var i = 0; i < regions.length; i++) {
            var region = regions[i];
            newOption = document.createElement('option');
            newOption.value = region.code;
            newOption.innerText = region.region;
            newOption.dataset.address_region = region.region;
            newOption.dataset.address_region_code = region.code;
            this.regionDropDown.add(newOption);
        }
        /*if (regions.length === 1) {
            this.regionDropDown.selectedIndex = 1;
        }*/
    }
    this.adjustIndicatorOption(this.regionDropDown, regions.length);
};

LookupHandler.prototype.adjustIndicatorOption = function ($dropdown, count) {
    var text = "";
    if (count > 0) {
        if (count === 1) {
            text = $dropdown.dataset['withdataTextSingle'];
        } else {
            text = $dropdown.dataset['withdataTextPlural'].replace('{%}', count);
        }
    } else {
        text = $dropdown.dataset['nodataText'];
    }

    this.adjustOptionGroupLabel($dropdown, text);
};

LookupHandler.prototype.adjustOptionLabel = function ($dropdown, text) {
    if (text !== "") {
        $dropdown.item(0).innerHTML = text;
    }
};

LookupHandler.prototype.adjustOptionGroupLabel = function ($dropdown, text) {
    if (text !== "") {
        var optgroup = $dropdown.querySelector('optgroup');
        optgroup.setAttribute('label', text);
    }
};

LookupHandler.prototype.changeAddressContainerVisibility = function (bShow) {
    var classname = "govuk-visually-hidden";
    if (!bShow) {
        $(this.lookupResultsContainer).addClass(classname);
        $(this.resultsContainer).addClass(classname);
    } else {
        $(this.lookupResultsContainer).removeClass(classname);
        $(this.resultsContainer).removeClass(classname);
    }
};

LookupHandler.prototype.changeRegionContainerVisibility = function (bShow) {
    var classname = "govuk-visually-hidden";
    if (!bShow) {
        $(this.lookupRegionResultsContainer).addClass(classname);
    } else {
        $(this.lookupRegionResultsContainer).removeClass(classname);
    }
};

function nodeListForEach(nodes, callback) {
    if (window.NodeList.prototype.forEach) {
        return nodes.forEach(callback)
    }
    for (var i = 0; i < nodes.length; i++) {
        callback.call(window, nodes[i], i, nodes);
    }
}

$changeAddress = document.querySelectorAll('[data-module="find-address"');
nodeListForEach($changeAddress, function ($changeAddressModule) {
    new FindAddressComponent($changeAddressModule);
});

