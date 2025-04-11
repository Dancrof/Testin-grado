import store from "../../../store";

import {Validator} from "../easy-validator";

import {lang} from "../extraLogics";

export function widgetChartValidation(data) {

    const {module,name,category,tickets_view} = data

    let validatingData = {

        module: [module, 'isRequired'],

        name: [name, 'isRequired'],
    };

    if(module){

        validatingData['category'] = [category,'isRequired'];

        validatingData['tickets_view'] = [tickets_view,'isRequired'];
    }

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return {errors, isValid};
}