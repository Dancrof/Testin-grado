import store from "../../../store";

import {Validator} from "../easy-validator";

import {lang} from "../extraLogics";

export function validateSingleSignOn(data) {

    const {provider ,entity_id ,sso_url , slo_url, certificate} = data

    let validatingData = {

        provider: [provider, 'isRequired'],

        entity_id: [entity_id, 'isRequired'],

        sso_url: [sso_url, 'isRequired'],

        slo_url: [slo_url, 'isRequired'],

        certificate: [certificate, 'isRequired'],
    };

    const validator = new Validator(lang);

    const { errors, isValid } = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return { errors, isValid };
}