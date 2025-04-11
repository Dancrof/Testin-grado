import { mount } from '@vue/test-utils'

import LocationCreateEdit from "../../../views/js/components/LocationCreateEdit.vue";

import * as extraLogics from "helpers/extraLogics";

import * as validation from "../../../views/js/helpers/validator/locationValidation";

import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;

describe('LocationCreateEdit',() => {

	let wrapper;

	const updateWrapper = () =>{

		extraLogics.getIdFromUrl = () =>{return 1}

			wrapper = mount(LocationCreateEdit,{

			global : {
				stubs: ['text-field','number-field','dynamic-select', 'phoneWithCountryCode'],
			}
		})  
	}
	
	beforeEach(() => {
		 
		updateWrapper();

		axiosMock = new MockAdapter(axios);
	})

	afterEach(() => {

		if(axiosMock) { axiosMock.restore();}
	})

	it('makes an API call', (done) => {
		
		updateWrapper();

		stubRequest();

		wrapper.vm.getInitialValues(1);
		
		setTimeout(()=>{
		
			expect(axiosMock.history.get[0].url).toBe('/api/location/1')

			done();
		
		},1)
	});

	it('makes `loading` false when `getInitialValues` method return error', (done) => {

		updateWrapper();

		stubRequest(400);

		wrapper.vm.getInitialValues(1);

		setTimeout(()=>{

			expect(wrapper.vm.loading).toEqual(false);

			done();

		},50)
	})

	it('updates `name` of the label when onChange method is called with suitable parameters',()=>{

		wrapper.vm.onChange('test', 'title');

		expect(wrapper.vm.title).toBe('test');
	})

	it('makes an AJAX call when onSubmit method is called',(done)=>{

		updateWrapper()

		wrapper.setData({ loading : false, hasDataPopulated : true})

		wrapper.vm.isValid = () =>{return true}

		mockSubmitRequest();

		wrapper.vm.onSubmit()

		expect(wrapper.vm.loading).toBe(true)

		setTimeout(()=>{

			expect(axiosMock.history.post[0].url).toBe('/api/location')

			expect(wrapper.vm.loading).toBe(false)

			done();
		},1);
	});

	it('makes an loading as false when onSubmit method return error',(done)=>{

		updateWrapper()

		wrapper.setData({ loading : false, hasDataPopulated : true,location_id : 1})

		wrapper.vm.isValid = () =>{return true}

		mockSubmitRequest(400);

		wrapper.vm.onSubmit()

		setTimeout(()=>{

			expect(wrapper.vm.loading).toBe(false)

			done();
		},1);
	});

	it("updates `title value when page is in edit`",()=>{

		updateWrapper()

		wrapper.vm.getInitialValues = jest.fn();

		wrapper.vm.getValues('/10/edit');

		expect(wrapper.vm.$data.page_title).toEqual('edit_location');

		expect(wrapper.vm.getInitialValues).toHaveBeenCalled();
	});

	it('call `isValid` method when onSubmit method is called',(done)=>{

		updateWrapper()

		wrapper.setData({ loading : false, hasDataPopulated : true})

		wrapper.vm.isValid =jest.fn()

		wrapper.vm.onSubmit()

		expect(wrapper.vm.isValid).toHaveBeenCalled()

		done();
	});

	it('isValid - should return false ', done => {

		validation.validateLocationSettings = () =>{return {errors : [], isValid : false}}

		expect(wrapper.vm.isValid()).toBe(false)

		done()
	})

	it('isValid - should return true ', done => {

		validation.validateLocationSettings = () =>{return {errors : [], isValid : true}}

		expect(wrapper.vm.isValid()).toBe(true)

		done()
	})
	it('updates phone_country_code and phone_iso when getPCountCode and getPCountIso methods are called', () => {
		const updateWrapper = () => wrapper.vm.$forceUpdate();

		updateWrapper();
		wrapper.vm.onPhoneFieldUpdate('US', 'phone_country_code');
		wrapper.vm.onPhoneFieldUpdate('ISO_US', 'phone_iso');

		expect(wrapper.vm.phone_country_code).toBe('US');
		expect(wrapper.vm.phone_iso).toBe('ISO_US');
	});

	function mockSubmitRequest(status = 200,url = '/api/location'){

		axiosMock.onPost(url).reply(status, {});
	}

	function stubRequest(status = 200,url = '/api/location/1'){

		axiosMock.onGet(url).reply(status, {data : {location : {id : 1, title : 'test'}}});

	}
})