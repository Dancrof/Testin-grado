import { mount } from '@vue/test-utils'

import LogsTrace from "../../../../views/js/components/LogsTables/ReusableComponent/LogsTrace.vue";

let wrapper;

describe('LogsTrace',()=>{

	beforeEach(()=>{

		wrapper = mount(LogsTrace,{
			global : {
				stubs:['logs-modal']
			},
			props : {
				data : {trace:'text'}
			}
		});
	});

	it('makes read more button enabled when page created',()=>{

		expect(wrapper.find('span').exists()).toBe(true);
	});

	it('does not show logs modal popup if showModal is false',async () => {
		await wrapper.setData({ showModal : false })
		expect(wrapper.find('logs-modal-stub').exists()).toBe(false)
	});

	it('show logs modal popup if showModal is true',async () => {
		await wrapper.setData({ showModal : true })
		expect(wrapper.find('logs-modal-stub').exists()).toBe(true)
	});

});
