import {mount} from "@vue/test-utils";
import MailSubject from "../../../../views/js/components/LogsTables/ReusableComponent/MailSubject.vue";
import {createStore} from "vuex";
import MockAdapter from "axios-mock-adapter";
import axios from "axios";
let wrapper;
let axiosMock;

describe("MailSubject", () => {

  let actions;

  let store;

  beforeEach(() => {
    actions = {
      unsetValidationError: jest.fn()
    }
    store = createStore({
      actions
    })

    axiosMock = new MockAdapter(axios);
  });

  afterEach(() => {
    if(axiosMock) {

      axiosMock.restore();
    }
  })

  const populateWrapperWithoutStub = () => {

    // moxios.stubRequest("/api/get-log-mail-body/1", {
    //   status: 200,
    //   response: {
    //     "success": true,
    //     "data": {
    //       "mail_body": "test_body"
    //     }
    //   }
    // });

    wrapper = mount(MailSubject, {
      props: {
        data: {}
      },
      global : {
        plugins: [store],
        stubs:['logs-modal']
      },
    });
  }

  const populateWrapperWithStub = () => {
    wrapper = mount(MailSubject, {
      props: {
        data: {}
      },
      global : {
        plugins: [store],
        stubs:['logs-modal']
      },
    });
  }

  it("sends an API request when log-mail-subject link is clicked", async () => {
    populateWrapperWithoutStub();
    await wrapper.setProps({
      data: {
        id: 1,
        subject: "test_subject"
      }
    });
    wrapper.find("#log-mail-subject").trigger("click");
    expect(wrapper.vm.showModal).toEqual(true);
  });

  it("Does not show `logs modal popup` if `showModal` is false", async() => {
    populateWrapperWithStub();
    await wrapper.setData({ showModal : false })
    expect(wrapper.find("logs-modal-stub").exists()).toBe(false);
  });

  it("Show `logs modal popup` if `showModal` is true", async () => {
    populateWrapperWithStub();
    await wrapper.setData({ showModal : true })
    expect(wrapper.find("logs-modal-stub").exists()).toBe(true);
  });

  it("Initial value of `showModal` should be false", () => {
    populateWrapperWithStub();
    expect(wrapper.vm.$data.showModal).toBe(false);
  });

  it("`ShowModal` should be false when `onClose` method is called", async () => {
    populateWrapperWithStub();
    await wrapper.setData({ showModal : true })
    expect(wrapper.vm.$data.showModal).toBe(true);
    wrapper.vm.onClose();
    expect(wrapper.vm.$data.showModal).toBe(false);
  });

});
