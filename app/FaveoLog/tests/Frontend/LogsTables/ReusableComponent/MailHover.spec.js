import { mount, RouterLinkStub } from '@vue/test-utils'

import MailHover from "../../../../views/js/components/LogsTables/ReusableComponent/MailHover.vue";

import {createStore} from "vuex";

const store = createStore({

	getters : {

		getUserData: () => {return { system_url : 'test'}}
	},
})

import axios from "axios";

import MockAdapter from "axios-mock-adapter";

let axiosMock;

describe('MailHover',()=>{

	let wrapper;

	const updateWrapper = () =>{

		wrapper = mount(MailHover,{
			global : {
				plugins: [store],
				stubs :{
					'router-link' : RouterLinkStub
				}
			},
			props : {
				data : {reciever_mail:'test@gmail.com'},
				objectKey: "reciever_mail"
			}
		});
	}

	beforeEach(()=>{
		axiosMock = new MockAdapter(axios);
		updateWrapper()
	});

	afterEach(() => {
		if(axiosMock) {

			axiosMock.restore();
		}
	})

	it('calls `popOver` method on mouseeneter event',() => {

		updateWrapper()

	    wrapper.vm.popOver =jest.fn()

	    wrapper.find('#main').trigger('mouseenter')

	    expect(wrapper.vm.popOver).toHaveBeenCalled()
	});

	it('calls `popOver` method on mouseleave event',() => {

		updateWrapper()

	    wrapper.vm.popOver =jest.fn()

	    wrapper.find('#main').trigger('mouseleave')

	    expect(wrapper.vm.popOver).toHaveBeenCalled()
	});

	it('calls `popOver` method with number on `mouseenter` event',async()=>{

			updateWrapper()

			await wrapper.setProps({data:{id:12}})

			wrapper.vm.popOver =jest.fn()

			wrapper.find('#main').trigger('mouseenter')

			expect(wrapper.vm.popOver).toHaveBeenCalledWith(12)
	});

	it('calls `popOver` method with `null` value on `mouseleave` event',()=>{

			updateWrapper()

			wrapper.setProps({data:{id:12}})

			wrapper.vm.popOver =jest.fn()

			wrapper.find('#main').trigger('mouseleave')

			expect(wrapper.vm.popOver).toHaveBeenCalledWith(null)
	});

	it('makes an API call when `getData` method called', async () => {

	    updateWrapper();

	    await wrapper.setProps({data:{id:12,reciever_mail:'test@gmail.com'}})

		mockGetRequest();

	    wrapper.vm.getData('test@gmail.com',12);

		expect(axiosMock.history.get[0].url).toEqual('/api/get-user-by-email?email=test@gmail.com');

	});
});

function mockGetRequest(status = 200,url = '/api/get-user-by-email?email=test@gmail.com'){

	const fakeData = {
		data : {
			user : {
				id:1,
			}
		}
	};

	axiosMock.onGet(url).reply(status, fakeData);
}