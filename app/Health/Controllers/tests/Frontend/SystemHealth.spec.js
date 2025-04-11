import { mount } from '@vue/test-utils';

import SystemHealth from "../../../views/js/components/SystemHealth.vue";

import MockAdapter from "axios-mock-adapter";
import axios from "axios";
let axiosMock;

describe("SystemHealth",()=>{

    let wrapper;

    const updateWrapper = () =>{

        wrapper = mount(SystemHealth,{
            global : {
                stubs : ['health-table-modal']
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

    it('makes an API call', (done) => {

        mockGetRequest();

        wrapper.vm.getData();

        setTimeout(()=>{

            expect(wrapper.vm.loading).toBe(false)

            expect(axiosMock.history.get[0].url).toBe('/health/getServerChecks')

            expect(wrapper.vm.healthData).not.toEqual( [])

            done();
        },1)
    })

    it('makes loading as false if an API call returns error', (done) => {

        mockGetRequest(400);

        wrapper.vm.getData();

        setTimeout(()=>{

            expect(wrapper.vm.loading).toBe(false)

            expect(axiosMock.history.get[0].url).toBe('/health/getServerChecks')

            done();
        },1)
    })
    function mockGetRequest(status = 200,url = '/health/getServerChecks'){

        axiosMock.onGet(url).reply(status,fakeResponse)
    }

    let fakeResponse = {
        success:true,
        data:{
            Warning : [
                {
                    check:'warn',
                    value:'10 Days'
                }
            ],
            Danger : [
                {
                    check:'danger',
                    value:'100 Days'
                }
            ],
            Ok : [
                {
                    check:'Ok',
                    value:'1000 Days'
                }
            ]
        }
    }
})