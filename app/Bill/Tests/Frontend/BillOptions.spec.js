import { mount } from '@vue/test-utils'

import BillOptions from "../../views/js/components/Billing/BillOptions.vue";

import axios from "axios";

import MockAdapter from "axios-mock-adapter";

let axiosMock;

import * as validation from "helpers/validator/billOptionsRules";

jest.mock('helpers/responseHandler')

import globalMixin from "../../../../resources/assets/js/mixins/globalMixin";
describe('BillOptions',() => {

	let wrapper;

	const updateWrapper = () =>{
		
			wrapper = mount(BillOptions,{

				global: {
					mixins: [globalMixin],
					stubs: ['reuse-loader','status-switch','faveo-box','number-field','custom-loader','alert', 'loader'],
					mocks: { axios }
				}
		})  
	}
	
	beforeEach(() => {
		
		updateWrapper();

		axiosMock = new MockAdapter(axios);
	})

	afterEach(() => {

		if(axiosMock) {

			axiosMock.restore();
		}
	})

	it('makes an API call', (done) => {
			
		updateWrapper();

		mockGetRequest();

		wrapper.vm.getInitialValues();

			setTimeout(()=>{

				expect(wrapper.vm.loading).toBe(false)

				expect(wrapper.vm.hasDataPopulated).toBe(true)

				expect(axiosMock.history.get[0].url).toEqual('/bill/api/get-billing-options');

				done();
			},50)
		})


	it('updates `loading` value as false if api returns error response',(done)=>{

		updateWrapper()

		mockGetRequest(400);

		wrapper.vm.getInitialValues()

		expect(wrapper.vm.loading).toBe(true)

		setTimeout(()=>{

				expect(wrapper.vm.loading).toBe(false)

				done();
		},1);
	});

	it('updates `invoice_due` value when onChange method is called',()=>{
		
		wrapper.vm.onChange(15, 'invoice_due');
			
		expect(wrapper.vm.invoice_due).toBe(15);
	})

	it('isValid - should return false ', done => {
				
		validation.billOptionsValidation = () =>{return {errors : [], isValid : false}}
			
		expect(wrapper.vm.isValid()).toBe(false)
			
		done()
	})

	it('isValid - should return true ', done => {
			 
		validation.billOptionsValidation = () =>{return {errors : [], isValid : true}}
			
		expect(wrapper.vm.isValid()).toBe(true)
			
		done()
	})

  it('makes an AJAX call when onSubmit method is called',(done)=>{

		updateWrapper();

		wrapper.vm.getInitialValues = jest.fn();

		wrapper.setData({ loading : false, hasDataPopulated : true, invoice_due : 1 })

		wrapper.vm.isValid = () =>{return true}

	  mockSubmitRequest();

		wrapper.vm.onSubmit()

		expect(wrapper.vm.pageLoad).toBe(true)

		setTimeout(()=>{

			expect(axiosMock.history.post[0].url).toEqual('/bill/api/update-billing-options');

				expect(wrapper.vm.pageLoad).toBe(false);

				expect(wrapper.vm.getInitialValues).toHaveBeenCalled();

				done();
		},1);
	});

	it('updates `loading` value as false if api returns error response',(done)=>{

		updateWrapper()

		wrapper.setData({ loading : false, hasDataPopulated : true, invoice_due : 1 })

		wrapper.vm.isValid = () =>{return true}

		mockSubmitRequest(400);

		wrapper.vm.onSubmit()

		expect(wrapper.vm.pageLoad).toBe(true)

		setTimeout(()=>{

				expect(wrapper.vm.pageLoad).toBe(false)

				done();
		},1);
	});

  function mockSubmitRequest(status = 200,url = '/bill/api/update-billing-options'){

	  const fakeData1 = {};

	  axiosMock.onPost(url).reply(status,fakeData1);
	}

	function mockGetRequest(status = 200,url = '/bill/api/get-billing-options'){

		const fakeData = {
			data : {
				id:1,
				backlist_threshold:5,
				lockout_period:1,
				lockout_message:'test'
			}
		};

		axiosMock.onGet(url).reply(status,fakeData);
	}
})