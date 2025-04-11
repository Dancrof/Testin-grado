import { mount } from '@vue/test-utils';
import TimeSeriesChart from './../../../views/js/components/Common/TimeSeriesChart.vue';
let wrapper;
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;

describe('TimeSeriesChart', () => {

  let mountComponent = (defaultCategory = 'view_by', categoryPrefix = 'view_by') => {
    wrapper = mount(TimeSeriesChart, {
      global : { stubs: ['data-widget', 'faveo-chart', 'relative-loader'] },
      props: {
        chartDataApi: 'api/agent/top-customer-analysis',
        dataWidgetApi: undefined,
        categories: [],
        defaultCategory: defaultCategory,
        categoryPrefix: categoryPrefix,
        reportIndex: 1,
        filterParams: { testKey: 'testvalue' }
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

  it('prop default values', () => {
    expect(wrapper.props.dataWidgetApi).toBe(undefined);
    expect(wrapper.props.categories).toEqual(undefined);
  })

  it('assign defualt values while component init', () => {
    expect(wrapper.vm.selectedCategory).toBe('view_by');
  })


  it('assign value to `selectedCategory` when `onCategoryChange` called', () => {
    wrapper.vm.getDataFromServer = jest.fn();
    wrapper.vm.onCategoryChange('category');
    expect(wrapper.vm.selectedCategory).toBe('category');
    expect(wrapper.vm.getDataFromServer).toHaveBeenCalled();
  });

  it('getUrlParams will return url parameters with `view_by` and `filterParams` if `filterParams` is truthy', () => {
    expect(wrapper.vm.getUrlParams('iamtype').testKey).toEqual('testvalue');
  })

  it('calls api for chart when `getDataFromServer` called', (done) => {
    mockChartApi();
    wrapper.vm.getDataFromServer();
    setTimeout(() => {
      expect(axiosMock.history.get[0].url).toBe('api/agent/top-customer-analysis');
      done();
    });
  })
})

const chartApiData = [
  {
    "id": "received_tickets",
    "name": "received_tickets",
    "data": [
      {
        "id": 15,
        "label": "Test Org",
        "redirectTo": "http://localhost/test1",
        "value": 9
      },
      {
        "id": 14,
        "label": "Microprecision Solutions Pvt.Ltd",
        "redirectTo": "http://localhost/test2",
        "value": 14
      },
      {
        "id": 7,
        "label": "Ladybird Web Solution Pvt Ltd",
        "redirectTo": "http://localhost/test3",
        "value": 324
      },
      {
        "id": 9,
        "label": "Due North Yoga Pvt Ltd",
        "redirectTo": "http://localhost/test4",
        "value": 646
      }
    ],
    "dataLabel": "ticket_count"
  }
];

// function mockChartApi() {
//   moxios.stubRequest('', {
//     status: 200,
//     response: { success: true, data: chartApiData },
//   })
// }

function mockChartApi(status=200,url='api/agent/top-customer-analysis'){
  axiosMock.onGet(url).reply(status, { data : { data : chartApiData}});
}