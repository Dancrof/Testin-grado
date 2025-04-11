const state = {
    problemAssociateCategory: '',
    changeAssociateCategory:'',
    releaseAssociateCategory:'',
    assetAssociateCategory:'',
    contractAssociateCategory:'',
    licenseAssociateCategory:'',
    taskAssociateCategory:'',
}

const getters = {

    getProblemAssociateCategory: state => state.problemAssociateCategory,
    getChangeAssociateCategory: state => state.changeAssociateCategory,
    getReleaseAssociateCategory: state => state.releaseAssociateCategory,
    getAssetAssociateCategory: state => state.assetAssociateCategory,
    getContractAssociateCategory: state => state.contractAssociateCategory,
    getLicenseAssociateCategory: state => state.licenseAssociateCategory,
    getTaskAssociateCategory: state => state.taskAssociateCategory,
}

const mutations = {

    updateProblemAssociateCategory(state, payload) {

        state.problemAssociateCategory = payload;
    },

    updateChangeAssociateCategory(state, payload) {

        state.changeAssociateCategory = payload;
    },

    updateReleaseAssociateCategory(state,payload){

        state.releaseAssociateCategory = payload;
    },

    updateAssetAssociateCategory(state, payload){

        state.assetAssociateCategory = payload;
    },

    updateContractAssociateCategory(state, payload){

        state.contractAssociateCategory = payload;
    },

    updateLicenseAssociateCategory(state, payload){

        state.licenseAssociateCategory = payload;
    },

    updateTaskAssociateCategory(state, payload){

        state.taskAssociateCategory = payload;
    }
};

const actions = {
    setProblemAssociateCategory({ commit }, payload) {
        commit('updateProblemAssociateCategory', payload);
    },

    setChangeAssociateCategory({ commit }, payload) {
        commit('updateChangeAssociateCategory', payload);
    },

    setReleaseAssociateCategory({commit}, payload){
        commit('updateReleaseAssociateCategory', payload)
    },

    setAssetAssociateCategory({commit}, payload){
        commit('updateAssetAssociateCategory', payload)
    },

    setContractAssociateCategory({commit}, payload){
        commit('updateContractAssociateCategory', payload)
    },

    setLicenseAssociateCategory({commit}, payload){
        commit('updateLicenseAssociateCategory', payload)
    },

    setTaskAssociateCategory({commit}, payload){
        commit('updateTaskAssociateCategory', payload)
    }
};

export default { state, getters, mutations, actions}