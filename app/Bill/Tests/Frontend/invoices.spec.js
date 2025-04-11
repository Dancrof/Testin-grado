import { mount } from '@vue/test-utils';
import Invoices from "../../views/js/components/Billing/Invoices.vue";
import { createStore } from "vuex";

import MockAdapter from "axios-mock-adapter";
import axios from "axios";
let axiosMock;

let wrapper;
let getters;
let store;


const configureWrapper = (apiEndpoint = 'test-api-endpoint') => {
    wrapper = mount(Invoices, {
        props: {},
        global: {
            plugins: [store],
            stubs: ['dynamic-select'],
        },
    });
};

describe('Invoices', () => {

    beforeEach(() => {
        getters = {
            getValidationErrors: () => ({}),
        };

        store = createStore({
            getters,
        });

        axiosMock = new MockAdapter(axios);
    });

    afterEach(() => {
        if (axiosMock) {
            axiosMock.restore();
        }
    });

    it('should toggle filter view when toggleFilterView method is called', async () => {
        configureWrapper();

        expect(wrapper.vm.isShowFilter).toBe(false);
        await wrapper.vm.toggleFilterView();
        expect(wrapper.vm.isShowFilter).toBe(true);
        await wrapper.vm.toggleFilterView();
        expect(wrapper.vm.isShowFilter).toBe(false);
    });

    it('should set deleteUrl and showModal to true when deletePackage is called', async () => {

        expect(wrapper.vm.deleteUrl).toBe('');
        expect(wrapper.vm.showModal).toBe(false);
        await wrapper.vm.deletePackage();
        expect(wrapper.vm.deleteUrl).toBe('bill/delete-user-invoice?invoice_ids=');
        expect(wrapper.vm.showModal).toBe(true);
    });

    it('should update hideData property when hideFilter is called', () => {
        expect(wrapper.vm.hideData).toBe('');
        wrapper.vm.hideFilter('sample data');
        expect(wrapper.vm.hideData).toBe('sample data');
    });

    it('should update apiUrl property based on the provided value when apiChange is called', () => {
        expect(wrapper.vm.apiUrl).toBe('');
        wrapper.vm.apiChange({
            status: 'unpaid',
            payable_amount: 100,
        });
        expect(wrapper.vm.apiUrl).toBe(
            '/bill/package/get-user-invoice?meta=true&all-users=1&status=0&payable_amount=100'
        );
    });

    it('allows multi-select delete', async () => {
        // Mock the data for your component's table or list
        const data = [
            { id: 1, name: 'Item 1' },
            { id: 2, name: 'Item 2' },
            { id: 3, name: 'Item 3' },
        ];
        wrapper.setData({ items: data })
        await wrapper.setData({ selectedItems: [1, 3] });

        await wrapper.vm.$nextTick();
        const deleteButton = wrapper.find('#advance-filter-btn');
        await deleteButton.trigger('click');

        // Assert that a confirmation modal or dialog is displayed
        expect(wrapper.vm.showModal).toBe(true);

    });

});

