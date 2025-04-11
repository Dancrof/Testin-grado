/**
 * Store for new form builder impl
 */

const state = {

  formMenus: [], // form menu for drag element

  formFields: [], // array of individual element in form builder

  formSections: [], // array of sectionst in form builder

  formCategoryType: 'ticket', // Category type, may be ticket, user, organisation etc

  isDisableDraging: false, // flag to enable/disable drag event, used to disable draging when modal popup is in open state

  clonableForm: ''
};

const getters = {

  getFormMenus(state) {
    return state.formMenus;
  },

  getFormFields(state) {
    return state.formFields;
  },

  getFormSections(state) {
    return state.formSections;
  },

  getClonedForm(state) {
    return state.clonableForm;
  },

  getFormCategoryType(state) {
    return state.formCategoryType;
  },

  isDisableDraging(state) {
    return state.isDisableDraging;
  }


};

const mutations = {

  updateFormMenu(state, data) {
    state.formMenus = [...data];
  },

  updateFormFields(state, data) {
    state.formFields = [...data];
  },

  updateFormSections(state, data) {
    state.formSections = [...data];
  },

  updateCloneableFormData(state, data) {
    state.clonableForm = data;
  },

  updateFormCategoryType(state, newType) {
    state.formCategoryType = newType;
  },

  updateIsDisableDraging(state, newVal) {
    state.isDisableDraging = newVal;
  }

};

const actions = {

  updateFormFields: ({ commit }, data) => {
    commit('updateFormFields', data);
  },

  updateFormSections: ({ commit }, data) => {
    commit('updateFormSections', data);
  },

  updateCloneableFormData: ({ commit }, data) => {
    commit('updateCloneableFormData', data);
  }
};


export default { state, getters, mutations, actions };