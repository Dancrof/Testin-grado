import { mount } from '@vue/test-utils';
import ReportDeleteModal from "../../../views/js/components/Common/ReportDeleteModal.vue";
import axios from 'axios';
import MockAdapter from "axios-mock-adapter";
let axiosMock;

describe('ReportDeleteModal', () => {
    let wrapper;

    beforeEach(() => {
        wrapper = mount(ReportDeleteModal, {
            props: {
                showModal: true,
                onClose: jest.fn(),
                reportId: 1,
                reportType: 'ServiceDesk Analysis'
            }
        });
    });

    beforeEach(() => {

        axiosMock = new MockAdapter(axios);
    })

    afterEach(() => {

        if(axiosMock) { axiosMock.restore();}
    })

    it("is vue instance",()=>{
        expect(wrapper).toBeTruthy();
    })

    it("makes an AJAX call when onSubmit method is called'",(done)=>{

        wrapper.setData({ apiUrl : 'service-desk/api/report/delete/1'});

        mockDeleteRequest();

        wrapper.vm.deleteCustomReport();

        expect(wrapper.vm.loading).toEqual(true);

        setTimeout(()=>{

            expect(axiosMock.history.delete[0].url).toBe('service-desk/api/report/delete/1')

            done();
        },1)
    });

    it("makes `loading, isDisabled` values false when `getLinkedMessage` method returns erro response",(done)=>{

        wrapper.setData({ apiUrl : 'service-desk/api/report/delete/1'});

        mockDeleteRequest(400);

        wrapper.vm.deleteCustomReport();

        setTimeout(()=>{

            expect(wrapper.vm.loading).toEqual(false);

            done();
        },1)
    });

    function mockDeleteRequest(status=200, reportype = "ServiceDesk Analysis", url=reportype === 'service-desk/api/report/delete/'){

        axiosMock.onDelete(url).reply(status,{})
    }
});
