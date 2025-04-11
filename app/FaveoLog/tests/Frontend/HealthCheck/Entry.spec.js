import { mount } from '@vue/test-utils';

import Entry from "../../../views/js/components/HealthCheck/Entry.vue";

import MockAdapter from "axios-mock-adapter";
import axios from "axios";
let axiosMock;

window.HTMLElement.prototype.scrollIntoView = function() {};

describe("Entry",()=>{

    let wrapper;

    const updateWrapper = () =>{

        wrapper = mount(Entry,{

            global : {
                stubs : ['date-picker','table-view']
            }
        })
    }

    beforeEach(()=>{

        updateWrapper();

        axiosMock = new MockAdapter(axios);
    });

    afterEach(() => {

        if(axiosMock) { axiosMock.restore();}
    })

    it('is a Vue instance', () => {
        expect(wrapper.vm).toBeInstanceOf(Object) // or any other type check you want to perform
    })

    it('update values when showContent method called',(done)=>{

        wrapper.vm.getLogCategories = jest.fn();

        wrapper.vm.showContent('cron');

        expect(wrapper.vm.showTable).toEqual(false);

        expect(wrapper.vm.selectedCategory).toEqual('');

        expect(wrapper.vm.selectedLogType).toEqual('cron');

        expect(wrapper.vm.logTypeApi).toEqual('/api/automation/cron');

        setTimeout(()=>{

            expect(wrapper.vm.getLogCategories).toHaveBeenCalled();

            done()
        },1000)
    })

    it('update `selectedCategory` value when showLogs method called',(done)=>{

        wrapper.vm.showLogs({name:'mail'},'sent');

        expect(wrapper.vm.showTable).toEqual(false);

        expect(wrapper.vm.status).toEqual('sent');

        setTimeout(()=>{

            expect(wrapper.vm.showTable).toEqual(true);

            expect(wrapper.vm.fetching).toEqual(false);

            done()
        },1000)
    });

    it('update data values when onChange method called',(done)=>{

        wrapper.vm.getLogCategories = jest.fn();

        wrapper.vm.onChange('2023-03-27','date');

        expect(wrapper.vm.showTable).toEqual(false);

        setTimeout(()=>{

            expect(wrapper.vm.getLogCategories).toHaveBeenCalled();

            done()
        },1000)
    })

    it('makes an API call', (done) => {

        mockGetRequest();

        wrapper.vm.logTypeApi = "/api/automation/cron";

        wrapper.vm.getLogCategories();

        setTimeout(()=>{

            expect(wrapper.vm.$data.loading).toBe(false)

            done();
        },1)
    })

    it('makes logCategories to empty array if an API call returns error', (done) => {

        mockGetRequest(400);

        wrapper.vm.logTypeApi = "/api/automation/cron";

        wrapper.vm.getLogCategories();

        setTimeout(()=>{

            expect(wrapper.vm.$data.loading).toBe(false)

            expect(wrapper.vm.logCategories).toEqual( [])

            done();
        },1)
    })
    function mockGetRequest(status = 200,url = '/api/automation/cron'){

        axiosMock.onGet(url).reply(status,fakeResponse)
    }

    let fakeResponse = {
        success:true,
        message:[
            {
                id:49,
                title:'test',
                message:'test'
            }
        ]
    }
})