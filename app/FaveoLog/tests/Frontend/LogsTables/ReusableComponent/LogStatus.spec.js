import { mount } from "@vue/test-utils"
import LogStatus from "../../../../views/js/components/LogsTables/ReusableComponent/LogStatus.vue";

let wrapper;

describe("LogStatus",()=>{

	beforeEach(()=>{
    wrapper = mount(LogStatus,{
      props : { data : {id : 1, status:"test_status"}}
    });
	});

  it("shows class `text-bg-success` if status is `sent`", async ()=>{
    await wrapper.setProps({data : {id: 1, status: "sent"}});
    expect(wrapper.find("#log-status-1").classes()).toContain("text-bg-success");
  })

  it("shows class `text-bg-success` if status is `accepted`", async ()=>{
    await wrapper.setProps({data : {id: 1, status: "accepted"}})
    expect(wrapper.find("#log-status-1").classes()).toContain("text-bg-success")
  })

  it("shows class `text-bg-warning` if status is `queued`", async ()=>{
    await wrapper.setProps({data : {id: 1, status: "queued"}})
    expect(wrapper.find("#log-status-1").classes()).toContain("text-bg-warning")
  })

  it("shows class `text-bg-danger` if status is `rejected`", async ()=>{
    await wrapper.setProps({data : {id: 1, status: "rejected"}})
    expect(wrapper.find("#log-status-1").classes()).toContain("text-bg-danger")
  })

  it("shows class `text-bg-danger` if status is `failed`", async ()=>{
    await wrapper.setProps({data : {id: 1, status: "failed"}})
    expect(wrapper.find("#log-status-1").classes()).toContain("text-bg-danger")
  })

  it('`getStatusTitle` will return proper title for the log status', async () => {
    await wrapper.setProps({ data : { id: 1, status: 'failed', exception: { line: 13 } }});
    expect(wrapper.vm.getStatusTitle).toBe('failedclick_to_view_exception');

    await wrapper.setProps({ data : { id: 1, status: 'accepted', exception: null }});
    expect(wrapper.vm.getStatusTitle).toBe('accepted');
  })

});
