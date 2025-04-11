import { mount } from '@vue/test-utils';

import CronLogs from "../../../views/js/components/LogsTables/CronLogs.vue";

import {createStore} from "vuex";

const store = createStore({

	getters : {

		formattedTime: () => {return ''}
	},
})

let wrapper;

describe('CronLogs',()=>{

	const updateWrapper = ()=>{

		wrapper = mount(CronLogs,{

			global : {
				stubs : ['date-time-field', 'logs-table'],
				plugins: [store],
			},

			props : {
				category : {command:'run'}
			}
		})
	};

	beforeEach(()=>{

		updateWrapper();
	});

	it('is a Vue instance', () => {
		expect(wrapper.vm).toBeInstanceOf(Object) // or any other type check you want to perform
	})
})
