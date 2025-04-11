import store from '../../../store'

import {Validator} from "../easy-validator";

import {lang} from '../extraLogics';
import {shallSendingHostBeVisible} from "./emailSettingsRules";

export function validateIframeSettings(data){

    const { app_name, app_url, integration_type, routes, button_name, icon_class, teams, agents, departments } = data;

    let validatingData = {

        app_name: [app_name, 'isRequired'],

        app_url: [app_url, 'isRequired'],

        integration_type: [integration_type, 'isRequired'],

        routes: [routes, 'isRequired'],

        button_name: [button_name, 'isRequired'],

        icon_class: [icon_class, 'isRequired'],
    };

    const validator = new Validator(lang);

    const {errors, isValid} = validator.validate(validatingData);

    store.dispatch('setValidationError', errors);

    return {errors, isValid};
};