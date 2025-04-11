import { mount } from '@vue/test-utils';
import CustomReportColumn from './../../../views/js/components/Common/CustomReportColumn.vue';
let wrapper;
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;
jest.mock('helpers/responseHandler')

describe('CustomReportColumn', ()=> {
  let mountComponent = (isEditing = false, column = {}) => {
    wrapper = mount(CustomReportColumn, {
      global : {
        stubs: ['relative-loader', 'checkbox','text-field', 'dynamic-select'],
      },
      props: {
        closeView : jest.fn(),
        isEditing: isEditing,
        column: column,
        addCustomColumnUrl: 'api/add-custom-column',
        shortCodeUrl: 'api/report-shortcodes'
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

  it('makes an api for shortcodes as soon as component is mounted', (done)=>{
    mountComponent();
    setTimeout(()=>{
      expect(axiosMock.history.get[0].url).toBe('api/report-shortcodes');
      done();
    }, 0);
  });


  it('populates column data if `isEditing` is true at the time of mount', ()=>{
    mountComponent();
    expect(wrapper.vm.id).toEqual(0);
    expect(wrapper.vm.name).toEqual("");
    expect(wrapper.vm.equation).toEqual("");
    expect(wrapper.vm.isTimestamp).toEqual(false);

    mountComponent(true, {id: 1, label:'label', equation:'equation', is_timestamp: true, timestamp_format: "F j, Y"});
    expect(wrapper.vm.id).toEqual(1);
    expect(wrapper.vm.name).toEqual("label");
    expect(wrapper.vm.equation).toEqual("equation");
    expect(wrapper.vm.isTimestamp).toEqual(true);
  })

  it('makes an api call to `api/add-custom-column` when submit button is clicked', (done)=>{
    mountComponent(true, {id: 1, label:'label', equation:'equation', is_timestamp: true, timestamp_format: "F j, Y"});
    mockAddCustomColumn();
    wrapper.vm.onSubmit();
    setTimeout(()=>{
      expect(axiosMock.history.post[0].url).toBe('api/add-custom-column');
      done();
    }, 0);
  })

  it('emits `refresh-report` event on success of `api/add-custom-column` call', (done)=>{
    mountComponent(true, {id: 1, label:'label', equation:'equation', is_timestamp: true, timestamp_format: "F j, Y"});
    mockAddCustomColumn();
    wrapper.vm.onSubmit();
    let eventEmitted = false;
    window.emitter.on('refresh-report', ()=> eventEmitted = true);
    expect(eventEmitted).toBe(false);
    setTimeout(()=>{
      expect(eventEmitted).toBe(true);
      done();
    }, 0);
  })
})
function mockAddCustomColumn(status=200,url='api/add-custom-column'){
  axiosMock.onPost(url).reply(status, {});
}
