import { mount, shallow } from '@vue/test-utils';

import MailLogs from "../../../views/js/components/LogsTables/MailLogs.vue";

let wrapper;

import {createStore} from "vuex";

const store = createStore({

	getters : {

		formattedTime: () => {return ''}
	},
})
describe('MailLogs',()=>{

	const updateWrapper = ()=>{

		wrapper = mount(MailLogs,{

			global:{

				stubs : ['dynamic-select', 'logs-table', 'date-time-field'],

				plugins: [store]
			},

			props : {
				category : {id:1}
			}
		})
	};

	beforeEach(()=>{

		updateWrapper();
	});

	it('updates `sender_user_ids` value of the mail logs when onChange method is called with suitable parameters for sender_user_ids',()=>{

    	wrapper.vm.onChange([1,2,3], 'sender_user_ids');

    	expect(wrapper.vm.sender_user_ids).toEqual([1,2,3]);
  	});

  	it('updates `receiver_user_ids` value of the mail logs when onChange method is called with suitable parameters for receiver_user_ids',()=>{

    	wrapper.vm.onChange([4,5,6], 'receiver_user_ids');

    	expect(wrapper.vm.receiver_user_ids).toEqual([4,5,6]);
  	});
});
