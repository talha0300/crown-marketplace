function passwordStrength(v, regNum, regChar, regUpper, liEight, liChar, liCap){
    /*var regNum = new RegExp ("^.{8,}");//requires 8 characters
    var regChar = new RegExp("^(?=.*?[#?!@£$%^&*-])");//requires special character
    var regUpper = new RegExp("^(?=.*?[A-Z])");//requires an uppercase letter
    var liEight = $('#passeight');
    var liChar = $('#passsymbol');
    var liCap = $('#passcap');*/

    var theTests = [ [regNum, liEight], [regChar, liChar], [regUpper, liCap] ];
    var arrayLength = theTests.length;

    for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i][0]);
        if(theTests[i][0].test(v)){
            theTests[i][1].removeClass('wrong').addClass('correct');
        }else{
            theTests[i][1].removeClass('correct').addClass('wrong');
        }
    }
}

function fireErrorSummary(theTarget, v){
    var linktxt;

    switch(v) {
        case 'eight':
            linktxt = $('#'+theTarget+'-eighterror').text();
            break;
        case 'strength':
            linktxt = $('#'+theTarget+'-Serror').text();
            break;
        case 'upper':
            linktxt = $('#'+theTarget+'-uppererror').text();
            break;
        case 'match':
            linktxt = $('#'+theTarget+'-matcherror').text();
            break;
        case 'six':
            linktxt = $('#'+theTarget+'-sixerror').text();
            break;
        default:
            linktxt = $('#'+theTarget+'-error').text();
    }

    $('#ccs-error-sum-list').append('<li id="sum-'+theTarget+'"><a href="#'+theTarget+'">'+ linktxt +'</a></li>');
     $('#ccs-error-sum').attr('tabindex','-1').removeClass('govuk-visually-hidden').focus();

    var title = $('html').children('head').find('title');
    title.text('Error: '+ title.text().replace(/Error: /g,''));
}

function removeErrorSummary(theTarget2){
    $('#sum-'+theTarget2).remove();
}

function refreshErrorSummary(){
    $('#ccs-error-sum').addClass('govuk-visually-hidden');
    $('#ccs-error-sum-list').find('li').remove();
}

function fireInlineError(theName, v){
    var errorid;

    switch(v) {
        case 'eight':
            errorid = '-eighterror';
            break;
        case 'strength':
            errorid = '-Serror';
            break;
        case 'upper':
            errorid = '-uppererror';
            break;
        case 'match':
            errorid = '-matcherror';
            break;
        case 'six':
            errorid = '-sixerror';
            break;
        default:
            errorid = '-error';
    }

    $('#'+theName+errorid).removeClass('govuk-visually-hidden')
    .parents('.govuk-form-group').addClass('govuk-form-group--error');
}

function wipeInlineError(theName){
    $('#'+theName).parents('.govuk-form-group').removeClass('govuk-form-group--error').find('span.ccs-e-msg').addClass('govuk-visually-hidden');
}

function removeInlineError(theName, form){
    form.find('span[id^="'+theName+'"]').addClass('govuk-visually-hidden').parents('.govuk-form-group').removeClass('govuk-form-group--error');
}




function cop_confirmation_code(form){
    $('#submit').on('click', function(e){
        var inputName = 'confirmation';
        var inputVal = form.find('input[name="'+inputName+'"]').val();

        if(inputVal === ''){//empty value
            e.preventDefault();//stop the form.submit()
            fireErrorSummary(inputName);
            fireInlineError(inputName);
        }else{//has a value
            removeErrorSummary(inputName);//clean up ...
            removeInlineError(inputName, form);

            var characterReg = new RegExp ("^.{6,}");//requires 6 characters
            if(!characterReg.test(inputVal)) {
                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputName,'six');
                fireInlineError(inputName,'six');
            }

            form.submit();
        }
    });
}

function cop_register(form){
    var firstPassword;
    var characterReg = new RegExp ("^.{8,}");//requires 8 characters
    var passwordReg = new RegExp("^(?=.*?[#?!@£$%^&*-])");//requires a special character
    var upperReg = new RegExp("^(?=.*?[A-Z])");//requires an uppercase letter
    var liEight = $('#passeight');
    var liChar = $('#passsymbol');
    var liCap = $('#passcap');

    $('#password01').on('keyup', function(){//the dynamic password strength list
        passwordStrength($(this).val(), characterReg, passwordReg, upperReg, liEight, liChar, liCap);
    });

    var pass01 = 'password01'; //password 1 field name & id
    var pass02 = 'password02';//password 2 field name & id
    var fname = 'firstname';//firstname field name & id, ... etc
    var lname = 'lastname';
    var orgname = 'organisationname';
    var emailF = 'email';//job title is optional

    $('#submit').on('click', function(e){
        var inputs = [
            [$('#'+fname).val(), fname],
            [$('#'+lname).val(), lname],
            [$('#'+orgname).val(), orgname],
            [$('#'+emailF).val(), emailF],
            [$('#'+pass01).val(), pass01],
            [$('#'+pass02).val(), pass02]
        ];
        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i]);

            if(inputs[i][0] === ''){// = empty inputs

                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputs[i][1]);
                wipeInlineError(inputs[i][1]);
                fireInlineError(inputs[i][1]);

            }else{//has a value
                removeErrorSummary(inputs[i][1]);//clean up ...
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == pass01){//run on the first/main password input

                    firstPassword = inputs[i][0];

                    if(!characterReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }/*else */
                    if(!passwordReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }
                    if(!upperReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'upper');
                        fireInlineError(inputs[i][1],'upper');
                    }

                }else if(inputs[i][1] == pass02){

                    if(firstPassword != inputs[i][0]){
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'match');
                        fireInlineError(inputs[i][1],'match');
                    }

                }else if(inputs[i][1] == emailF){

                    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
                    if(!emailReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1]);
                        fireInlineError(inputs[i][1]);
                    }

                }

                form.submit();
            }

        }
    });
}

function cop_change_password_form(form){
    var firstPassword;

    $('#submit').on('click', function(e){
        var pass01 = 'password01'; //password 1 field name & id
        var pass02 = 'password02';//password 2 field name & id

        var val01 = $('#'+pass01).val();
        var val02 = $('#'+pass02).val();
        var inputs = [ [val01, pass01], [val02, pass02] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i]);

            if(inputs[i][0] === ''){// = empty inputs
                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputs[i][1]);
                wipeInlineError(inputs[i][1]);
                fireInlineError(inputs[i][1]);
            }else{//has a value
                removeErrorSummary(inputs[i][1]);//clean up ...
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == pass01){//run on the first/main password input

                    var characterReg  = new RegExp ("^.{8,}");//requires 8 characters
                    var passwordReg = new RegExp("^(?=.*[0-9])|(?=.[!@#\$%\^&])");//requires a number or special character
                    firstPassword = inputs[i][0];

                    if(!characterReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'eight');
                        fireInlineError(inputs[i][1],'eight');
                    }/*else */
                    if(!passwordReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1],'strength');
                        fireInlineError(inputs[i][1],'strength');
                    }

                }else if(firstPassword != inputs[i][0]){

                    e.preventDefault();//stop the form.submit()
                    fireErrorSummary(inputs[i][1],'match');
                    fireInlineError(inputs[i][1],'match');

                }

                form.submit();
            }

        }
    });
}

function cop_sign_in_form(form){
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

    $('#submit').on('click', function(e){
        var emailF = 'email'; //email field name & id
        var passwordF = 'password';//password field name & id

        var val01 = $('#'+pasemailFs01).val();
        var val02 = $('#'+passwordF).val();
        var inputs = [ [val01, emailF], [val02, passwordF] ];

        var arrayLength = inputs.length;
        refreshErrorSummary();

        for (var i = 0; i < arrayLength; i++) {//console.log(inputs[i]);

            if(inputs[i][0] === ''){//empty value
                e.preventDefault();//stop the form.submit()
                fireErrorSummary(inputs[i][1]);
                fireInlineError(inputs[i][1]);
            }else{//has a value
                removeErrorSummary(inputs[i][1]);//clean up ...
                removeInlineError(inputs[i][1], form);

                if(inputs[i][1] == emailF){//test the email address
                    if(!emailReg.test(inputs[i][0])) {
                        e.preventDefault();//stop the form.submit()
                        fireErrorSummary(inputs[i][1]);
                        fireInlineError(inputs[i][1]);
                    }
                }

                form.submit();
            }

        }
    });
}



jQuery(document).ready(function(){
    var f = $('#main-content').find('form.ccs-form');

    if(f.length){
      var formIDs = ['cop_sign_in_form','cop_change_password_form','cop_register','cop_confirmation_code'];

      $.each(formIDs, function(i, val){
        if(f.is('#'+val)){//the form has this id
          window[val](f);//call the function reusing the id as its name
        }
      });
    }
});
