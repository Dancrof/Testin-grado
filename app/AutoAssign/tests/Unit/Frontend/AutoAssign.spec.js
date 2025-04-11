import { mount } from '@vue/test-utils';

import AutoAssign from '../../../views/js/components/AutoAssign';

import * as validation from "../../../views/js/helpers/validator/autoAssignRules.js";

let wrapper;

import MockAdapter from "axios-mock-adapter";
import axios from "axios";
let axiosMock;

describe('AutoAssign',()=>{

	const updateWrapper = ()=>{

		wrapper = mount(AutoAssign,{

			global : {

				stubs : ['radio-button', 'number-field']

			},
		})
	};

	beforeEach(()=>{

		updateWrapper();

		axiosMock = new MockAdapter(axios);
	});

	afterEach(() => {

		if(axiosMock) { axiosMock.restore();}
	});

	it('makes an API call', (done) => {
			
		updateWrapper();

		stubRequest();

		wrapper.vm.getValues();
			
		expect(wrapper.vm.loading).toBe(true)

		setTimeout(()=>{
			
			expect(axiosMock.history.get[0].url).toBe('/api/get-auto-assign')
				
			expect(wrapper.vm.loading).toBe(false)

			expect(wrapper.vm.hasDataPopulated).toBe(true)

			done();
		},50)
	});

	it("makes `loading` as false if api returns error response",(done)=>{

		updateWrapper();

		stubRequest(400);

		wrapper.vm.getValues();

		setTimeout(()=>{

			expect(wrapper.vm.loading).toBe(false)

			done();
		},50)
	});

	it('updates state data correctly(according to the key) when `updateStatesWithData` is called',() => {
		
		var data = { threshold :'10' }
		
		wrapper.vm.updateStatesWithData(data);
		
		expect(wrapper.vm.threshold).toBe(10);
	});

	it('updates `username` value when onChange method is called',()=>{
	
		wrapper.vm.onChange(10, 'threshold');
		
		expect(wrapper.vm.threshold).toBe(10);
	});

	it('isValid - should return false ', done => {
       	
      validation.validateAutoAssignSettings = () =>{return {errors : [], isValid : false}}
      
      expect(wrapper.vm.isValid()).toBe(false)
      
      done()
   });

    it('isValid - should return true ', done => {
       
      validation.validateAutoAssignSettings = () =>{return {errors : [], isValid : true}}
      
      expect(wrapper.vm.isValid()).toBe(true)
      
      done()
   });

   it('makes an AJAX call when onSubmit method is called',(done)=>{

		updateWrapper()

		wrapper.vm.getValues = jest.fn();

		wrapper.setData({ loading : false, hasDataPopulated : true})

		wrapper.vm.isValid = () =>{return true}

	   mockSubmitRequest();

		wrapper.vm.onSubmit()

		expect(wrapper.vm.pageLoad).toBe(true)

		setTimeout(()=>{
				
			expect(wrapper.vm.pageLoad).toBe(false);

			expect(wrapper.vm.getValues).toHaveBeenCalled();
				
			done();
		},1);
	});

	it("makes `loading` as false if api returns error response",(done)=>{

		updateWrapper();

		mockSubmitRequest(400);

		wrapper.vm.onSubmit();

		setTimeout(()=>{

			expect(wrapper.vm.pageLoad).toBe(false)

			done();
		},50)
	});

	function mockSubmitRequest(status = 200,url = '/api/auto-assign'){

		axiosMock.onPost(url).reply(status,{});
	 }

	function stubRequest(status = 200,url = '/api/get-auto-assign'){

		axiosMock.onGet(url).reply(status,{});

	 }
})
