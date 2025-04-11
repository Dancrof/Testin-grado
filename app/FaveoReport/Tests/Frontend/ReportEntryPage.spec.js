import { mount } from '@vue/test-utils';
import ReportEntryPage from './../../views/js/components/ReportEntryPage.vue';
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;
import  utils from '../../../FaveoReport/views/js/helpers/utils';
import * as extraLogics from "helpers/extraLogics";
let wrapper;

jest.mock('../../../FaveoReport/views/js/helpers/utils', () => ({
  getValidFilterObject: ({})=> jest.fn( () => { return {}}),
}));

describe('ReportEntryPage', () => {

  let mountComponent = () => {
    extraLogics.getIdFromUrl = () => { return 3 }
    wrapper = mount(ReportEntryPage, {
      global : { stubs: ['ticket-filter', 'tabular-report-layout', 'time-series-chart', 'category-based-report', 'save-report-modal']},
    });
  }

  beforeEach(() => {
    axiosMock = new MockAdapter(axios);
    mountComponent();
  });

  afterEach(() => {
    if(axiosMock) { axiosMock.restore();}
  });

  it('calls export api as soon as `#export-button` is clicked', (done) => {
    mockExportApi();
    mountComponent();
    wrapper.vm.dataCount = 1;
    wrapper.vm.reportConfigObj = { sub_reports: [{columns : [],id:1,add_custom_column_url:'test',data_url:'tets', data_type: 'datatable' }], export_url: 'api/agent/export-chart/top-customer-analysis' };
    wrapper.vm.exportReport();

    setTimeout(() => {
      expect(axiosMock.history.post[0].url).toBe('api/agent/export-chart/top-customer-analysis');
      done();
    },1);
  })

  it('close modal when closeSaveReportModal called', () => {
    wrapper.vm.closeSaveReportModal();
    expect(wrapper.vm.openSaveReportModal).toBe(false);
  })

  it('Update local copy of filter object with the filter-object recieved form api response', () => {
    wrapper.vm.reportConfigObj = { sub_reports: [], filters: [ {key: 'created-at', value: 'last::1~day'}] };
    wrapper.vm.updateFilterObj();

    expect(wrapper.vm.filterParams).toStrictEqual({'created-at': 'last::1~day'})
  })

  it('showExportButton should return true if report.data_type is datatable else it will return false', () => {
    wrapper.vm.reportConfigObj = { sub_reports: [{ data_type: 'datatable' }], export_url: 'api/agent/export-chart/top-customer-analysis' };
    expect(wrapper.vm.showExportButton).toBe(true);

    wrapper.vm.reportConfigObj = { sub_reports: [{ data_type: 'not_datatable' }], export_url: 'api/agent/export-chart/top-customer-analysis' };
    expect(wrapper.vm.showExportButton).toBe(false);
  })

  it('Update local copy of `key` property with the updated one', () => {
    wrapper.vm.clonedReportConfigOnj = { sub_reports: [{}, { columns: []}]};
    wrapper.vm.updateChangedValue([{ id: 0, name: 'new_column'}], 1, 'columns');
    expect(wrapper.vm.clonedReportConfigOnj.sub_reports[1].columns).toStrictEqual([{ id: 0, name: 'new_column'}]);
  })

  it('getReportConfiguration will get report config object -- SUCCESS', function (done) {

    wrapper.vm.updateFilterObj = jest.fn();

    utils.getValidFilterObject = jest.fn(({}) => { return {}});

    mockReportReq();

    wrapper.vm.getReportConfiguration('3');

    setTimeout(() => {
      expect(axiosMock.history.get[0].url).toBe('api/agent/report-config/3')
      expect(wrapper.vm.reportConfigObj).toStrictEqual([{ sub_reports: [{ data_type: 'datatable' }], export_url: '' }]);
      expect(wrapper.vm.clonedReportConfigOnj).toStrictEqual([{ sub_reports: [{ data_type: 'datatable' }], export_url: '' }]);
      expect(wrapper.vm.isLoading).toBe(false);
      expect(wrapper.vm.updateFilterObj).toHaveBeenCalled();
      done();
    },1)
  })

  it('getReportConfiguration will get report config object -- ERROR', function (done) {

    wrapper.vm.updateFilterObj = jest.fn();
    
    utils.getValidFilterObject = jest.fn(({}) => { return {}});

    wrapper.vm.getReportConfiguration(3);

    mockReportReq(400);

    wrapper.vm.getReportConfiguration('3');

    setTimeout(() => {
      expect(axiosMock.history.get[0].url).toBe('api/agent/report-config/3');
      expect(wrapper.vm.isLoading).toBe(false);
      expect(wrapper.vm.updateFilterObj).not.toHaveBeenCalled();
      done();
    },1)
  })

})

function mockExportApi(status=200,url='api/agent/export-chart/top-customer-analysis'){
  axiosMock.onGet(url).reply(status, {});
}
function mockReportReq(status=200,url='api/agent/report-config/3'){
  axiosMock.onGet(url).reply(status, {data : [{"export_url": "", "sub_reports": [{"data_type": "datatable"}]}]});
}