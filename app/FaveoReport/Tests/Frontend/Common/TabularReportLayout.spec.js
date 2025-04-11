import { mount } from '@vue/test-utils';
import TabularReportLayout from './../../../views/js/components/Common/TabularReportLayout.vue';
let wrapper;
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;
jest.mock('helpers/responseHandler')

describe('TabularReportLayout', ()=> {

  let mountComponent = () => {
    wrapper = mount(TabularReportLayout, {
      global:{
        stubs: ['ticket-filter', 'dynamic-datatable', 'column-list'],
      },
      props:{
        dataUrl: 'api/agent/management-report',
        columnUrl: 'api/agent/report-columns/management_report',
        exportUrl: 'api/agent/management-report-export',
        panelTitle: 'management-performance',
        saveColumnUrl: 'api/agent/report-columns',
        addCustomColumnUrl: 'api/add-custom-column',
        shortCodeUrl: 'api/report-shortcodes',
        deleteCustomColumnUrl: 'api/report-shortcodes',
        subReportId: 1,
        tableColumns: [{ key: 'key11', label: 'label11', is_visible: true }, {key: 'key22', label: 'label22', is_visible: false }],
        reportIndex: 3,
        filterParams : {}
      }
    });
  }

  beforeEach(() => {
    axiosMock = new MockAdapter(axios);
  });

  afterEach(()=>{
    if(axiosMock) {

      axiosMock.restore();
    }
  });

  // it('assigns `filterData` to `filterParams` when `setFilter` is called with `filterData`', ()=>{
  //   mountComponent();
  //   let testFilter = {testKey: "testValue"};
  //   wrapper.vm.setFilter(testFilter);
  //   expect(wrapper.vm.filterParams).toEqual(testFilter);
  // })

  it('mounts `dynamic-datatable` only if loading columns length is non zero', async()=>{
    mountComponent();
    expect(wrapper.find('dynamic-datatable-stub').exists()).toBe(true);
    await wrapper.setData({ columns : []});
    expect(wrapper.find('dynamic-datatable-stub').exists()).toBe(false);
  })

  it('assign `columns` vlaue to columns and call updateVisibleColumns fn ', () => {
    mountComponent();
    wrapper.vm.updateVisibleColumns = jest.fn();
    wrapper.vm.onColumnUpdate({columns : [1,2,3]});
    expect(wrapper.vm.columns).toEqual({"columns": [1, 2, 3]});
    expect(wrapper.vm.updateVisibleColumns).toHaveBeenCalled();
  })

  it('update vissible columns when updateVisibleColumns called', () => {
    mountComponent();
    wrapper.vm.columns = [{ key: 'key11', label: 'label11', is_visible: true }, {key: 'key22', label: 'label22', is_visible: false } ];
    wrapper.vm.updateVisibleColumns();
    expect(wrapper.vm.visibleColumns).toEqual({ key11: 'label11' });

    wrapper.vm.columns = [];
    wrapper.vm.updateVisibleColumns();
    expect(wrapper.vm.visibleColumns).toEqual({});
  })

  // it('calls export api as soon as `#export-button` is clicked', (done)=>{
  //   mockExportApi();
  //   mountComponent();
  //   wrapper.find('#export-report').trigger('click');

  //   setTimeout(()=>{
  //     expect(moxios.requests.mostRecent().config.url).toBe('api/agent/management-report-export');
  //     done();
  //   });
  // })
})

function mockExportApi(status=200,url='api/agent/management-report-export'){
  axiosMock.onPost(url).reply(status, {success: true, message: 'success'});
}
