import { mount } from '@vue/test-utils';
import ColumnList from './../../../views/js/components/Common/ColumnList';
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
let axiosMock;
let wrapper;
jest.mock('helpers/responseHandler')

const mockRequestData = {
  'success': true,
  'data': {}
}

describe('ColumnList', ()=> {

  let mountComponent = (isEditing = false, column = {}) => {
    wrapper = mount(ColumnList, {
      global : {
        stubs: ['custom-column']
      },
      props: {
        onColumnUpdate : jest.fn(),
        columnUrl: 'api/agent/management-report-columns',
        saveColumnUrl: 'api/agent/report-columns',
        addCustomColumnUrl: 'api/add-custom-column',
        shortCodeUrl: 'api/report-shortcodes',
        deleteCustomColumnUrl: 'api/delete-custom-column',
        tableColumns: [],
        subReportId: 3,
        reportIndex: 1,
        filterParams:{}
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

    it('makes `isEditingCustomColumn` as true and assign passed column when `onEdit` is called', ()=>{
      mountComponent();
      wrapper.vm.onEdit({ id :1, name : 'test_column'});
      expect(wrapper.vm.showAddCustomColumn).toBe(true);
      expect(wrapper.vm.isEditingCustomColumn).toBe(true);
      expect(wrapper.vm.column).toEqual({"id": 1, "name": "test_column"});
    })

    it('makes `showCustomColumn` and `isEditingCustomColumn` as false and `column` to be empty when `hideCustomColumn` is called', ()=>{
      mountComponent();
      wrapper.vm.showAddCustomColumn = false;
      wrapper.vm.hideCustomColumn();
      expect(wrapper.vm.showAddCustomColumn).toBe(false);
      expect(wrapper.vm.isEditingCustomColumn).toBe(false);
      expect(wrapper.vm.column).toEqual({});
    })

    it('makes delete api call as soon as `onDelete` method is called with particular id', (done)=>{
      mockDeleteApi();
      mountComponent();
      wrapper.vm.onDelete('testId');

      setTimeout(()=>{
        // as soon as api comes as success, it calls columnlist api again to update
        expect(axiosMock.history.get[0].url).toBe('api/agent/report-columns/paginate/undefined');
        done();
      },0);
    })

    it('calls column-list api as soon as delete api is success', (done)=>{
      mockDeleteApi();
      mountComponent();
      wrapper.vm.onDelete('testId');

      setTimeout(()=>{
        expect(axiosMock.history.get[0].url).toBe('api/agent/report-columns/paginate/undefined');
        done();
      },0);
    })

    it('calls save column api as soon as `#save-columns` button is clicked', (done)=>{
      mountComponent();

      wrapper.vm.saveColumns();

      setTimeout(()=>{
        // as soon as api comes as success, it calls columnlist api again to update
        expect(axiosMock.history.post[0].url).toBe('api/agent/report-columns/3');
        done();
      },0);
    })

    it('calls column api as soon as getColumns method', (done) => {
      wrapper.vm.getColumns();

      setTimeout(() => {
        // as soon as api comes as success, it calls usercolumnlist api again to update
        expect(axiosMock.history.get[0].url).toBe('api/agent/report-columns/paginate/undefined');
        done();
      }, 0);
    });


    it('updates next_page state based on API response', (done) => {
      axiosMock.onGet('api/agent/report-columns/paginate/undefined').reply(200, { data: { next_page_url: 'some_url' } });

      wrapper.vm.getColumns();

      setTimeout(() => {
        // Expect next_page state to be true if next_page_url is not null in API response
        expect(wrapper.vm.next_page).toBe(true);

        done();
      }, 0);
    });

    it('sets showLoader to true before making API call', () => {
      wrapper.vm.getColumns();
      expect(wrapper.vm.showLoader).toBe(true);
    });

    it('sets showLoader to false after API call completes', (done) => {
      axiosMock.onGet('api/agent/report-columns/paginate/undefined').reply(200, mockRequestData);

      wrapper.vm.getColumns();

      setTimeout(() => {
        expect(wrapper.vm.showLoader).toBe(false);
        done();
      }, 0);
    });

    function mockDeleteApi(status=200,url='api/delete-custom-column/testId'){
      axiosMock.onDelete(url).reply(status, {});
    }
  });
