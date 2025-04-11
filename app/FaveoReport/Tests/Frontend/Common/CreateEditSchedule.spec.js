import { mount } from '@vue/test-utils';

import MockAdapter from "axios-mock-adapter";

import axios from "axios";

let axiosMock;

import * as extraLogics from "helpers/extraLogics";;

import CreateEditSchedule from "../../../views/js/components/Common/CreateEditSchedule.vue";


describe('CreateEditSchedule',()=>{

    let wrapper;

    const updateWrapper = ()=>{

        extraLogics.getIdFromUrl = () =>{return 1}

        wrapper = mount(CreateEditSchedule,{

            data(){

                return{
                    subject: 'schedule-report',
                    description: 'schedule-description',
                    ext:'CSV',
                    url: 'api/schedule-report/3',
                    loading: false
                }
            },

            beforeMount : jest.fn(),

            global:{
                stubs: ['static-select','date-time-field','text-field','radio-button']
            }
        })
    }

    beforeEach(()=>{
        axiosMock = new MockAdapter(axios);
        updateWrapper();
    })

    afterEach(()=>{
        if(axiosMock){axiosMock.restore();}
    })

    it("is vue instance", async() => {

        expect(wrapper.exists()).toBeTruthy()
    });

    it('default value for `loading` should be false', async() => {

        expect(wrapper.vm.$data.loading).toBe(false)
    });

    it('checking the initial value of all data is called',async()=>{

        expect(wrapper.vm.description).toBe("schedule-description");
        expect(wrapper.vm.subject).toBe("schedule-report");
        expect(wrapper.vm.ext).toBe("CSV");

    })

    it('checking the `url` defined in the data',async()=>{

        expect(wrapper.vm.url).toBe("api/schedule-report/3");
    })


    it("makes an API call", async() => {

        updateWrapper();

        wrapper.setData({selectedScheduleId: 1})

        wrapper.vm.getIntialValue=jest.fn();

        setTimeout(()=>{

            expect(axiosMock.history.get[0].url).toBe('get/individual_schedule_report/1')

            done();

        },1)
    })

    it('makes an AJAX call when onSubmit method is called',async()=>{

        updateWrapper()

        mockSubmitRequest();

        const onSubmitSpy = jest.spyOn(wrapper.vm, 'onSubmit');

        setTimeout(()=>{

            expect(onSubmitSpy).toHaveBeenCalled();

            expect(axiosMock.history.post[0].url).toBe('api/schedule-report/3')

            done();
        },1);
    });

    it("makes `loading` as false if api returns error response",async()=>{

        updateWrapper();

        stubRequest(400);

        setTimeout(()=>{

            expect(wrapper.vm.$data.loading).toBe(false)

            done();
        },50)
    })

    function mockSubmitRequest(){

        axiosMock.onPost('api/schedule-report/3').reply(200,{})
    }

    function stubRequest(status = 200,url = 'get/individual_schedule_report/1'){
        axiosMock.onGet(url).reply(status, {})
    }


})