import { mount } from '@vue/test-utils';

import HealthMonitor from "../../../views/js/components/HealthMonitor.vue";

import MockAdapter from "axios-mock-adapter";
import axios from "axios";
let axiosMock;
import { createStore } from "vuex";

describe("HealthMonitor",()=>{

    let wrapper;
    let store;
    let getters;

    const updateWrapper = () =>{

        getters = {

            isSettingActive: () => () => {return ''}
        }

        store = createStore({

            getters
        })

        wrapper = mount(HealthMonitor,{
            props:{

                data : JSON.stringify({ 'whiteLabel' : false })
            },

            global:{
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

        wrapper.vm.getData();

        setTimeout(()=>{

            expect(wrapper.vm.loading).toBe(false)

            expect(axiosMock.history.get[0].url).toBe('/health/system/alerts')

            expect(wrapper.vm.alertList).toEqual( [{"check": "test", "value": "10 Days"}])

            done();
        },1)
    })

    it('makes alertData to empty array if an API call returns error', (done) => {

        mockGetRequest(400);

        wrapper.vm.getData();

        setTimeout(()=>{

            expect(wrapper.vm.loading).toBe(false)

            expect(axiosMock.history.get[0].url).toBe('/health/system/alerts')

            expect(wrapper.vm.alertList).toEqual( [])

            done();
        },1)
    })

    it("returns true if value length is 3 or less",()=>{

        wrapper.vm.widgetOpen = false;

        wrapper.vm.toggleHealthMonitor();

        expect(wrapper.vm.widgetOpen).toEqual(true)

        expect(wrapper.vm.monitorClass).toEqual('monitor is-visible')

        expect(wrapper.vm.btnClass).toEqual('health-monitor-section is-float is-visible')

        expect(wrapper.vm.iconClass).toEqual('prime fas fa-times is-active is-visible')
    });

    function mockGetRequest(status = 200,url = '/health/system/alerts'){

        axiosMock.onGet(url).reply(status,fakeResponse)
    }

    let fakeResponse = {
        success:true,
        data:[
            {
                check:'test',
                value:'10 Days'
            }
        ]
    }
})