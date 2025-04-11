import { mount } from '@vue/test-utils'

import DailyReportSettings from "../../../views/js/components/Admin/DailyReportSettings.vue";

import * as validation from "./../../../views/js/helpers/validator/dailyReportRules";

jest.mock('helpers/responseHandler')

import axios from "axios";

import MockAdapter from "axios-mock-adapter";

let axiosMock;

describe('DailyReportSettings',() => {

    let wrapper;

    const updateWrapper = () =>{
        
        wrapper = mount(DailyReportSettings,{

            global : {

                stubs: ['draggable','draggable-widgets','dragged-widgets', 'text-field'],
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

    it('updates `report_name` value when onChange method is called',()=>{
        
        wrapper.vm.onChange('test', 'report_name');
            
        expect(wrapper.vm.report_name).toBe('test');
    });

    it('calls `isValid` method and updates `report_name` value when `onSave` method is called',()=>{
        
        wrapper.vm.isValid = jest.fn();

        wrapper.vm.onSave('report');
            
        expect(wrapper.vm.report_full_name).toBe('report');

        expect(wrapper.vm.isValid).toHaveBeenCalled();
    });

    it('removes correct item from `dragged_elements` value when `removeItem` method is called',async ()=>{
        
        await wrapper.setData({ dragged_elements : [{ id:'item-1', key : 'item-1', value : 'item 1'}, { id:'item-2', key : 'item-2', value : 'item 2'}] })

        expect(wrapper.vm.dragged_elements).toEqual([{"id": "item-1", "key": "item-1", "value": "item 1"}, {"id": "item-2", "key": "item-2", "value": "item 2"}]);

        wrapper.vm.removeItem({ id:'item-1', key : 'item-1', value : 'item 1'});
            
        expect(wrapper.vm.dragged_elements).toEqual([{"id": "item-2", "key": "item-2", "value": "item 2"}]);
    });

    it('returns `data` value when `onClone` method is called with non-existing value in dragged_elements', async ()=>{
        
        await wrapper.setData({ dragged_elements : [] })

        let retData = wrapper.vm.onClone({ id:'item-3', key : 'item-3', value : 'item 3'});

        expect(retData).toEqual({"id": "item-3", "key": "item-3", "value": "item 3"})
            
    });

    it('calls `loadTicketComponents and loadExistData` methods when `loadData` method called', (done) => {

        wrapper.vm.loadTicketComponents = jest.fn();

        wrapper.vm.loadExistData = jest.fn();
        
        wrapper.vm.loadData();

        expect(wrapper.vm.loading).toBe(true);

        expect(wrapper.vm.loadExistData).toHaveBeenCalled();

        expect(wrapper.vm.loadTicketComponents).toHaveBeenCalled();

        setTimeout(()=>{

            expect(wrapper.vm.loading).toBe(false);

            done();

        },1)
    })

    it('makes an API call when `loadTicketComponents` method called', (done) => {

        updateWrapper();

        mockGetRequest();

        wrapper.vm.loadTicketComponents();

        setTimeout(()=>{

            expect(axiosMock.history.get[0].url).toBe('/get/admin/daily-report/ticket-components-widgets')

            done();
        },1)
    });

    it('makes an API call when `loadExistData` method called', (done) => {

        updateWrapper();

        mockGetDataRequest();

        wrapper.vm.loadExistData();

        setTimeout(()=>{
            expect(axiosMock.history.get[1].url).toBe('/get/admin/daily-report')

            done();
        },1)
    });

    it('isValid - should return false ', done => {
                
        validation.validateDailyReportSettings = () =>{return {errors : [], isValid : false}}
            
        expect(wrapper.vm.isValid()).toBe(false)
            
        done()
    })

    it('isValid - should return true ', done => {
             
        validation.validateDailyReportSettings = () =>{return {errors : [], isValid : true}}
            
        expect(wrapper.vm.isValid()).toBe(true)
            
        done()
    })

    it('makes an AJAX call when onSubmit method is called', (done)=>{

        updateWrapper();

        wrapper.vm.loadData = jest.fn();

        wrapper.setData({ loading : false, dragged_elements : [{ id:'item-1', key : 'item-1', value : 'item 1'}]})

        wrapper.vm.isValid = () =>{return true}

        mockSubmitRequest();

        wrapper.vm.onSend()

        expect(wrapper.vm.loading).toBe(true)

        setTimeout(()=>{

            expect(axiosMock.history.post[0].url).toBe('/api/admin/daily-report/createOrUpdateReport')

            expect(wrapper.vm.loading).toBe(false);

            expect(wrapper.vm.loadData).toHaveBeenCalled();

            done();
        },1);
    });

    it('updates `loading` value as false if api returns error response', (done)=>{

        updateWrapper()

        wrapper.setData({ loading : false, dragged_elements : [{ id:'item-1', key : 'item-1', value : 'item 1'}]})

        wrapper.vm.isValid = () =>{return true}

        mockSubmitRequest(400);

        wrapper.vm.onSend()

        expect(wrapper.vm.loading).toBe(true)

        setTimeout(()=>{

            expect(wrapper.vm.loading).toBe(false)

            done();
        },1);
    });

function mockSubmitRequest(status = 200,url = '/api/admin/daily-report/createOrUpdateReport')
{

	let fakeData = {};

	axiosMock.onPost(url).reply(status,fakeData);
}

function mockGetDataRequest(status = 200,url = '/get/admin/daily-report')
{

	let fakeData = {
		data : {
			components :[{id:1,key:1,value : 'name'}]
		}
	}

	axiosMock.onGet(url).reply(status, fakeData);

}

function mockGetRequest(status = 200,url = '/get/admin/daily-report/ticket-components-widgets')
{

	let fakeData = {
		data : {
			components :[{id:1,key:1,value : 'name'}]
		}
	}

	axiosMock.onGet(url).reply(status, fakeData);
}
})