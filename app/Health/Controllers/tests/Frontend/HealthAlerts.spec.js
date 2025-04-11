import { mount } from '@vue/test-utils';

import HealthAlerts from "../../../views/js/components/HealthAlerts.vue";

import MockAdapter from "axios-mock-adapter";
import axios from "axios";
let axiosMock;

import {createStore} from "vuex";

describe("HealthAlerts",()=>{

    let wrapper;

    let store;

    let getters;
    const updateWrapper = () =>{

        getters = {

            formattedTime: () => () => {return ''}
        }

        store = createStore({

            getters
        })

        wrapper = mount(HealthAlerts,{

            global : {
                stubs : ['status-switch','toggle'],
                plugins:[store]
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

        wrapper.vm.getAlertData();

        setTimeout(()=>{

            expect(wrapper.vm.moduleLoad).toBe(false)

            expect(axiosMock.history.get[0].url).toBe('/health/check/alerts')

            expect(wrapper.vm.alertData).toEqual( [{"id": 49, "type": "number", "value": "10 Days"}])

            done();
        },1)
    })

    it('makes alertData to empty array if an API call returns error', (done) => {

        mockGetRequest(400);

        wrapper.vm.getAlertData();

        setTimeout(()=>{

            expect(wrapper.vm.moduleLoad).toBe(false)

            expect(axiosMock.history.get[0].url).toBe('/health/check/alerts')

            expect(wrapper.vm.alertData).toEqual( [])

            done();
        },1)
    })

    it('makes an AJAX call when onSubmit method is called',(done)=>{

        mockPostRequest();

        wrapper.vm.updateAlerts([{id:1,type:'Hours',value:'10', display :1}])

        expect(wrapper.vm.updateLoad).toBe(true)

        setTimeout(()=>{

            expect(axiosMock.history.post[0].url).toBe('/api/health/alerts')

            expect(wrapper.vm.updateLoad).toBe(false)

            done();
        },1);
    });

    it('updates `updateLoad` value as false if api returns error response',(done)=>{

        mockPostRequest(400);

        wrapper.vm.updateAlerts([{id:1,type:'Hours',value:'10', display :1}])

        expect(wrapper.vm.updateLoad).toBe(true)

        setTimeout(()=>{

            expect(axiosMock.history.post[0].url).toBe('/api/health/alerts')

            expect(wrapper.vm.updateLoad).toBe(false)

            done();
        },1);
    });

    function mockPostRequest(status = 200,url = '/api/health/alerts'){

        axiosMock.onPost(url).reply(status,{})
    }

    function mockGetRequest(status = 200,url = '/health/check/alerts'){

        axiosMock.onGet(url).reply(status,fakeResponse)
    }

    let fakeResponse = {
        success:true,
        data:[
            {
                id:49,
                type:'number',
                value:'10 Days'
            }
        ]
    }
})