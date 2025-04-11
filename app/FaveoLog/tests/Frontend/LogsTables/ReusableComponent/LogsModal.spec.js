import { mount } from '@vue/test-utils'

import LogsModal from "../../../../views/js/components/LogsTables/ReusableComponent/LogsModal.vue";

import axios from 'axios';

import MockAdapter from "axios-mock-adapter";

let axiosMock;

let wrapper;

describe('LogsModal',()=>{

    beforeEach(()=>{

        populateWrapper();

        axiosMock = new MockAdapter(axios);

    });

    afterEach(()=>{
        if (axiosMock) {
            axiosMock.restore();
        }
    });

    const populateWrapper = ()=>{

        wrapper = mount(LogsModal,{

            props : {
                data : { id:1,trace : 'trace'}
            },
        });
    }

    it('Does not show modal popup if showModal is false',() => {

        expect(wrapper.find('modal-stub').exists()).toBe(false)
    });

    it('Show modal popup if showModal is true',async () => {

        await wrapper.setProps({ showModal : true })

        expect(wrapper.find('modal-stub').exists()).toBe(true)
    });

    it('Initialy loading value should be false', () => {

        expect(wrapper.vm.loading).toBe(false);
    });

    it('Calls `getLogsContent` method when title is `logs_content` button',async ()=>{

        populateWrapper();

        await wrapper.setProps({ title : 'logs_content', data : { id :1} })

        wrapper.vm.getLogsContent = jest.fn()

        wrapper.vm.checkTitle();

        expect(wrapper.vm.getLogsContent).toHaveBeenCalled()
    });

    it('Makes an API call when `getLogsContent` method called', (done) => {

        populateWrapper();

        wrapper.vm.getLogsContent(1)

        setTimeout(()=>{

            expect(axiosMock.history.get[0].url).toEqual('/api/get-log-mail-body/1');

            done();
        },1)
    });
});
