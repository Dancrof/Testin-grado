import { mount } from '@vue/test-utils';

import ExceptionLogs from "../../../views/js/components/LogsTables/ExceptionLogs.vue";

import {createStore} from "vuex";

const store = createStore({

	getters : {

		formattedTime: () => {return ''}
	},
})

let wrapper;

describe('ExceptionLogs',()=>{

	const updateWrapper = ()=>{

		wrapper = mount(ExceptionLogs,{
			global : {
				stubs : ['logs-table', 'dynamic-select', 'date-time-field'],
				plugins: [store],
			},
			props : {
				category : {id:1}
			}
		})
	};

	beforeEach(()=>{

		updateWrapper();
	});

  	it('shows exception datatable when page mounted',()=>{

  		expect(wrapper.exists()).toBe(true);
  	})
})
