import store from '../../../store'
import {Validator} from "../easy-validator";
import {lang} from '../extraLogics';

export function validateBreaklines(data) {
    const { breakline , display_order, is_active } = data;
let validatingData = {
    breakline : [breakline,'isRequired'],
    is_active : [is_active , 'isRequired']
}

const validator = new Validator(lang);

const { errors,isValid } = validator.validate(validatingData)

store.dispatch('setValidationError',errors);

return { errors,isValid}
} 
