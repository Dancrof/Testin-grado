import store from "../../../../../../resources/assets/store";

import { Validator} from "../../../../../../resources/assets/js/helpers/easy-validator";

import {lang} from "../../../../../../resources/assets/js/helpers/extraLogics";

export function validateWorktimeTypeSettings(data) {

    const { name } = data

    var validatingData = {

        name: [name, 'isRequired'],
    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors); //if component is valid, an empty state will be sent

    return { errors, isValid };
}