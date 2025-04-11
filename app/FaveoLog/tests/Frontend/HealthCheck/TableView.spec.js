import { mount } from '@vue/test-utils';

import TableView from "../../../views/js/components/HealthCheck/TableView.vue";

describe("TableView",()=>{

    let wrapper;

    const updateWrapper = () =>{

        wrapper = mount(TableView,{

            global : {
                stubs : ['mail-logs','exception-logs', 'cron-logs', 'logs-modal']
            }
        })
    }

    beforeEach(()=>{

        updateWrapper();
    });

    it('is a Vue instance', () => {
        expect(wrapper.vm).toBeInstanceOf(Object) // or any other type check you want to perform
    })

    it('update `showModal` value when onClose method called',()=>{

        wrapper.vm.onClose();

        expect(wrapper.vm.showModal).toEqual(false);
    });
})