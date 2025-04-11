import { mount,RouterLinkStub } from '@vue/test-utils';
import ReportHomePage from './../../views/js/components/ReportHomePage.vue';
import {createStore} from "vuex";

import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;

let wrapper;

global.confirm = jest.fn(() => {
  return true;
})

let store;

let getters = {
  formattedTime: () => () => {return ''},
}

store = createStore({
  getters
})

describe('ReportHomePage', () => {

  let mountComponent = () => {
    wrapper = mount(ReportHomePage, {
      global : {
        plugins : [store],
        stubs : {
          'router-link' : RouterLinkStub
        }
      }
    });
  }

  beforeEach(() => {
    axiosMock = new MockAdapter(axios);
    mountComponent();
  });

  afterEach(() => {
    if(axiosMock) { axiosMock.restore();}
  });

  it('getReportList will get report list array -- SUCCESS', function (done) {

    wrapper.vm.updateFilterObj = jest.fn();

    mockReportReq();

    wrapper.vm.getReportList();

    setTimeout(() => {
      expect(axiosMock.history.get[0].url).toBe('api/agent/report-list?')
      expect(wrapper.vm.reportList).toStrictEqual([{id: 0, name: 'report_1'}, {id: 1, name: 'report_2'}]);
      expect(wrapper.vm.isLoading).toBe(false);
      done();
    },1)
  })

  it('getReportList will get report list array -- ERROR', function (done) {

    mockReportReq(400);

    wrapper.vm.getReportList();

    setTimeout(() => {
      expect(axiosMock.history.get[0].url).toBe('api/agent/report-list?');
      expect(wrapper.vm.isLoading).toBe(false);
      done();
    },1)
  })

  it('methods - viewReport - should return the correct path', () => {
    const mockedPath = '/reports/1';
    const result = wrapper.vm.viewReport(mockedPath);
    expect(result).toBe('1');
  });

  it('methods - deleteCustomReport - should set reportId and reportType and show delete modal', () => {
    const mockedValue = 1;
    const mockedType = 'public';

    wrapper.vm.deleteCustomReport(mockedValue, mockedType);

    expect(wrapper.vm.reportId).toBe(mockedValue);
    expect(wrapper.vm.reportType).toBe(mockedType);
    expect(wrapper.vm.showDeleteModal).toBe(true);
  });

  it('methods - editReport - should fetch report data and show edit modal on successful response', (done) => {
    mockEditReportReq();
    wrapper.vm.editReport(1, "ServiceDesk Analysis");

    setTimeout(() => {
      expect(axiosMock.history.get[1].url).toBe('api/agent/report-config/1');
      expect(wrapper.vm.showEditModal).toBe(true);
      expect(wrapper.vm.isLoading).toBe(false);
      done();
    }, 1);
  });

  it('methods - editReport - should handle error and show error message on failed response', (done) => {
    mockEditReportReq(500);
    wrapper.vm.editReport(1, "ServiceDesk Analysis");

    setTimeout(() => {
      expect(axiosMock.history.get[1].url).toBe('api/agent/report-config/1');
      expect(wrapper.vm.reportData).toEqual("");
      expect(wrapper.vm.showEditModal).toBe(false);
      expect(wrapper.vm.isLoading).toBe(false);
      // Add additional assertions for error handling if needed
      done();
    }, 1);
  });

})

function mockReportReq(status=200,url='api/agent/report-list?'){
  axiosMock.onGet(url).reply(status, {data : [{id: 0, name: 'report_1'}, {id: 1, name: 'report_2'}]});
}

function mockEditReportReq(status = 200, value = 1, type = "ServiceDesk Analysis" , url=`api/agent/report-config/${value}`) {
  const mockResponse = { data: { data: { id: value, name: `Mock Report ${value}` } } };
  axiosMock.onGet(url, { params: { include_filters: 1 } }).reply(status, mockResponse);
}
