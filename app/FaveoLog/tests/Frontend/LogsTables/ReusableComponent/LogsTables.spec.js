import { mount } from '@vue/test-utils';

import LogsTable from "../../../../views/js/components/LogsTables/ReusableComponent/LogsTable.vue";

let wrapper;

const initializeComponent = () => {

	wrapper = mount(LogsTable,{})
}

describe('LogsTable', () => {

	it('data-table should exists when page created', () => {

        initializeComponent()

        expect(wrapper.find('data-table-stub').exists()).toBe(true)

    });
})
