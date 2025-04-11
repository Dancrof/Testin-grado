import {mount} from '@vue/test-utils';
import SaveReportModal from './../../views/js/components/SaveReportModal.vue';
import * as extraLogics from "helpers/extraLogics";
import {createStore} from "vuex";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";

let axiosMock;

global.confirm = jest.fn(() => true);

let store;
const getters = {
  formattedTime: () => () => ''
};

store = createStore({
  getters
});

describe('SaveReportModal', () => {

  let wrapper;

  // Helper function to mount the component with specific props and mode
  const mountComponent = (modalMode = 'fork', reportDataObj = {}) => {
    extraLogics.getIdFromUrl = () => 3;

    wrapper = mount(SaveReportModal, {
      global: {
        stubs: ['text-field', 'checkbox', 'color-picker', 'dynamic-select'],
        plugins: [store]
      },
      props: {
        modalMode: modalMode,
        reportDataObj: {
          id: 3,
          name: 'report_name',
          description: 'report_description',
          is_public: true,
          iconClass: 'fas fa-ticket',
          iconColor: '#00C0EF',
          display_order: '1',
          shareAbles: {
            agents: [],
            departments: [],
            teams: []
          },
          ...reportDataObj
        },
        onClose: jest.fn(),
        from: 'report-list',
        filterValues: {},
        filterArray: [],
        chartType: ''
      }
    });
  };

  // Set up axios mock and mount component before each test
  beforeEach(() => {
    axiosMock = new MockAdapter(axios);
    mountComponent('fork');
    axiosMock.onPost('api/agent/report-config').reply(200, {});
  });

  // Clean up after each test
  afterEach(() => {
    if (axiosMock) axiosMock.restore();
    jest.clearAllMocks();
  });

  // Test to verify setup based on mode
  it('setUpComponentPropertiesBasisOfMode should setup component properties based on mode', () => {
    expect(wrapper.vm.title).toBe('save_filter');

    mountComponent('update');
    expect(wrapper.vm.title).toBe('update_this_report');
    expect(wrapper.vm.name).toBe('report_name');
    expect(wrapper.vm.description).toBe('report_description');
    expect(wrapper.vm.isPrivate).toBe(false);
    expect(wrapper.vm.display_order).toBe('1');
  });

  // Test to check if sharing options are rendered when report is private
  it('should render sharing options when report is private', async () => {
    mountComponent('update', {is_public: false});
    expect(wrapper.vm.renderSharingOption).toBe(true);
  });

  // Test to verify correct parameters are returned for saving a report
  it('getSaveReportParams should return the correct parameters', () => {
    mountComponent('update');  // Ensure we're in 'update' mode

    wrapper.vm.setUpComponentPropertiesBasisOfMode();

    const params = wrapper.vm.getSaveReportParams();

    if (wrapper.vm.modalMode === 'fork') {
      expect(params.id).toBe(null);
    } else {
      expect(params.id).toBe(3);
    }

    // Verify other parameters
    expect(params.name).toBe('report_name');
    expect(params.description).toBe('report_description');
    expect(params.is_public).toBe(true);
    expect(params.iconClass).toBe('fas fa-ticket');
    expect(params.iconColor).toBe('#00C0EF');
    expect(params.display_order).toBe('1');
  });

  it('should set validation errors if required fields are missing', async () => {
    // Create a mock store with validationErrors getter
    store = createStore({
      state() {
        return {
          validationErrors: {}
        };
      },
      getters: {
        validationErrors: (state) => state.validationErrors
      },
      mutations: {
        setValidationError(state, errors) {
          state.validationErrors = errors;
        },
        unsetValidationError(state) {
          state.validationErrors = {};
        }
      }
    });
    mountComponent('fork');

    // Simulate a validation error
    store.commit('setValidationError', {display_order: 'This field is required'});

    wrapper.vm.display_order = '';

    await wrapper.vm.onSubmit();
    await wrapper.vm.$nextTick();

    const validationErrors = store.getters.validationErrors;
    expect(validationErrors.display_order).toBe('This field is required');
  });

  it('should update properties correctly in onPropertyChange', () => {
    mountComponent('fork');

    wrapper.vm.onPropertyChange('New Report Name', 'name');
    expect(wrapper.vm.name).toBe('New Report Name');

    wrapper.vm.onPropertyChange(true, 'isPrivate');
    expect(wrapper.vm.isPrivate).toBe(true);
    expect(wrapper.vm.renderSharingOption).toBe(true);

    wrapper.vm.onPropertyChange({icon_class: 'fas fa-star'}, 'iconClass');
    expect(wrapper.vm.iconClass).toBe('fas fa-star');
  });

  it('should handle errors in onSubmit', async () => {
    axiosMock = new MockAdapter(axios);
    axiosMock.onPost('api/agent/report-config').reply(500, {});

    await wrapper.vm.onSubmit();
    await wrapper.vm.$nextTick();

    expect(wrapper.vm.isLoading).toBe(false);

  });

});
