import { mount } from '@vue/test-utils';

import LogsIndex from "../../views/js/components/LogsIndex.vue";

let wrapper;

describe('LogsIndex',()=>{

	const updateWrapper = ()=>{

		wrapper = mount(LogsIndex,{
			global : {

				stubs : ['exception-logs', 'cron-logs', 'mail-logs', 'logs-modal']
			}
		})
	};

	beforeEach(()=>{

		updateWrapper();
	});

	it('updates `category_ids` of the logs when onChange method is called with suitable parameters for category',()=>{

    	wrapper.vm.onChange({ "id":1,"name":"category"}, 'category_ids');

    	expect(wrapper.vm.category_ids).toEqual({"id": 1, "name": "category"});
  	});
})
