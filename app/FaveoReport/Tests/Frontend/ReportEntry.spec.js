import ReportEntry from "../../../Plugins/ServiceDesk/views/js/components/Report/ReportEntry.vue";
import { mount } from '@vue/test-utils';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
let axiosMock;

describe('ReportEntry',()=>{

    let wrapper;

    const updateWrapper = () => {

        wrapper = mount(ReportEntry)
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

    it('default value for `loading` should be false', () => {
        wrapper.setData({ isLoading : false });
        expect(wrapper.vm.isLoading).toBe(false);
    });

    it('makes an Api call', (done) => {

        updateWrapper();

        mockGetRequest()

        expect(wrapper.vm.isLoading). toBe(true)

        wrapper.vm.getReportList();

        expect(axiosMock.history.get[0].url).toBe('/service-desk/api/sd-reports/list');

        setTimeout(()=>{

            expect(wrapper.vm.isLoading).toBe(false)

            done();
        },1);
    });

    it('updates `loading` value as false if api returns error response',(done)=>{

        updateWrapper()

        mockGetRequest(400);

        wrapper.vm.getReportList()

        expect(wrapper.vm.isLoading).toBe(true)

        setTimeout(()=>{

            expect(wrapper.vm.isLoading).toBe(false)

            done();
        },1);
    });

    it('makes an Api call when deleteCustomReport method is called',(done)=>{

        updateWrapper();

        mockDeletetRequest();

        window.confirm  = jest.fn(()=> true);

        wrapper.vm.deleteCustomReport()

        expect(wrapper.vm.isLoading).toBe(true)

        setTimeout(()=>{

            expect(axiosMock.history.delete[0].url).toEqual('api/report/undefined');

            expect(wrapper.vm.isLoading).toBe(false);

            done();
        },1);
    });

    it('updates `loading` value as false if api returns error response',(done)=>{

        updateWrapper()

        wrapper.setData({ isLoading : false })

        window.confirm  = jest.fn(()=> true);

        mockDeletetRequest(400);

        wrapper.vm.deleteCustomReport()

        expect(wrapper.vm.isLoading).toBe(true)

        setTimeout(()=>{

            expect(wrapper.vm.isLoading).toBe(false)

            done();
        },1);
    });

    function mockDeletetRequest(status = 200,url = 'api/report/undefined'){

        const fakeData1 = {};

        axiosMock.onDelete(url).reply(status,fakeData1);
    }
    function mockGetRequest(status = 200,url = '/service-desk/api/sd-reports/list'){

        const fakeData = {

            data: {
                asset: {
                    id : '1',
                    is_default: '1',
                    link: 'service-desk/api/sd-report/4/22'
                },
                problem: {
                    id : '2',
                    is_default: '1',
                    link: 'service-desk/api/sd-report/3/26'
                }
            }
        };

        axiosMock.onGet(url).reply(status,fakeData);
    }

})
