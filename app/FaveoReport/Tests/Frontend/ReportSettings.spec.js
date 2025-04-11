import {mount } from '@vue/test-utils'
import ReportSettings from './../../views/js/components/ReportSettings.vue';

let wrapper;

import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;

describe('ReportSettings',() => {

	const updateWrapper = () =>{
		wrapper = mount(ReportSettings,{
			global : { stubs: ['static-select'] }
		})   
	}

	beforeEach(() => {
		updateWrapper();
		axiosMock = new MockAdapter(axios);
	})

	afterEach(() => {
		if(axiosMock) { axiosMock.restore();}
	})

	it('makes an API call on initial load to get data', (done) => {
		updateWrapper();
		wrapper.vm.getInitialValues();
		wrapper.vm.$nextTick(()=>{
			expect(axiosMock.history.get[0].method).toBe('get')
			expect(axiosMock.history.get[0].url).toBe('/api/report-settings')
			done();
		});
	});

	it('makes an API call for submitting the data when submit is clicked', (done) => {
		updateWrapper();
		mockSubmitReq();
		wrapper.vm.isValid = () =>{return true}
		wrapper.vm.onSubmit();
		setTimeout(()=>{
			expect(axiosMock.history.post[0].method).toBe('post')
			expect(axiosMock.history.post[0].url).toBe('/api/report-settings')
			done();
		},1);
	});
})
function mockSubmitReq(status=200,url='/api/report-settings'){
	axiosMock.onPost(url).reply(status, {});
}