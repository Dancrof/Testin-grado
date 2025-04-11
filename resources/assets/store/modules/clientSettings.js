import {errorHandler} from './../../js/helpers/responseHandler';
import {parseUrlParams} from "../../js/helpers/extraLogics";

const state = {

    layout_details: {},

    user_data:'',
    reset_email:'',
    
    check_ticket:'',
    rating_types:'',
    country_codes:'',
    locale:'',
    category_list:[],
    comment_filter:{},
    verifyEmail:'',
    push_menu : true,
    defaultRating: null,
};

const getters = {

    //gets layout details
    getLayoutData(state){
        
        return state.layout_details;
    },

    //get reset email
    getRatingTypes(state){
           return state.rating_types;
    },
        //get reset email
    getCountryCodes(state){
           return state.country_codes;
    },
    getLocale(state){
           return state.locale;
    },
    //get reset email
    getResetEmail(state){
           return state.reset_email;
    },


        //get article id
    getVerifyEmail(state){
           return state.verifyEmail;
    },

                //get page name
    getCheckTicketId(state){
           return state.check_ticket;
    },

    /**
     * gets button color for client panel
     */
    getButtonStyle(state){
        return {
          borderColor  : state.layout_details.portal.client_button_border_color,
          color  : state.layout_details.portal.client_button_font_color,
          backgroundColor : state.layout_details.portal.client_button_color
        }
    },

     /**
     * gets button color for client panel
     */
    getLinkStyle(state){
        return {
            color  : state.layout_details.portal.client_header_color
        }
    },

/**
 * category list of an article
 * @return {Array}
 */
    getCategoryList(){
        return state.category_list;
    },
    //gets actions list with allowed actions
    getCommentFilterData(state){
        return state.comment_filter;
    },

    getPushMenu(state){
        return state.push_menu;
    },
    //gets the default system rating for ticket
    getDefaultRatings(state) {
      return state.defaultRating;
    }
};

const mutations = {

    // Update layout details
    updateLayoutData(state, payload) {
        state.layout_details = payload;
    },


     updateCommentFilterData(state, payload) {
        state.comment_filter = payload;
    },
      updateRatingTypes(state,payload) {
        state.rating_types = payload;
      },
    updateCountryCodes(state,payload) {
        state.country_codes = payload;
      },
    updateLoale(state,payload) {
        state.locale = payload;
      },
    //update reset mail
    updateResetEmail(state, payload){
        state.reset_email = payload;
    },

    updateCheckTicketId(state, payload) {
        state.check_ticket = payload;
    },

    /**
     * category list for an article
     */
    setCategoryList(state, payload){
        state.category_list = payload;
    },

    setVerifyEmail(state,payload){
        state.verifyEmail = payload
    },

    updatePushMenu(state, payload) {

        state.push_menu = payload;
    },
    setDefaultRatings(state, payload) {
      state.defaultRating = payload;
    }
};

const actions = {

    // layout action method
    clientLayoutActions({commit},data){

        // axios.get('api/client/layout').then(res => {
        
            commit('updateLayoutData', data);
        // }).catch(err => {});  
    },

     commentFilterData({commit},data){
        commit('updateCommentFilterData', data);
    },

    // set rating types
        setRatingTypes({commit}, ticketId){
            if (ticketId) {
                let ticket_id = ticketId;
                const urlParams = parseUrlParams();
                let queryString = Object.entries({ticket_id, ...urlParams}).map(([key, value]) => {
                    return `${encodeURIComponent(key)}=${encodeURIComponent(value)}`;
                }).join('&');
              axios.get(`api/rating?${queryString}`).then(res => {
                commit('setDefaultRatings', res.data)
              }).catch(err => {
                commit('setDefaultRatings', '')
                errorHandler(err);
              });
            }
    },
        // set country codes
        setCountryCodes({commit}){
            axios.get('api/dependency/country-codes?meta=true')
                .then(res => {
                    commit('updateCountryCodes', res.data.data.country_codes);
                })
                .catch(err => {
                    commit('updateCountryCodes', '');
                    errorHandler(err);
                });
    },
        setLanguage({commit},data){

           commit('updateLoale',data);
        },
                   //remove locale data
        setLocaleEmpty({commit},data){
           commit('updateLoale','');
        },
           //remove user data
        setUserDataEmpty({commit},data){
           commit('updateUserData','');
        },
        //set reset email
        resetEmail({commit},data){
           commit('updateResetEmail',data);
        },
        //set reset email empty
        setResetEmailEmpty({commit},data){
           commit('updateResetEmail','');
        },

// set page
         setCheckTicketId({commit},data){
           commit('updateCheckTicketId',data);
        },
         //remove page
        setCheckTicketIdEmpty({commit},data){
           commit('updateCheckTicketId','');
        },
/**
 * category list of a article from article by id component
 */
        categoryForBreadcrumb({commit},data){
            commit('setCategoryList',data);
        },

        setEmail({commit},data){
            commit('setVerifyEmail',data)
        },

        setPushMenu({ commit }, value) {
    
            commit('updatePushMenu', value);
        },

};

export default {state, getters, mutations, actions}
