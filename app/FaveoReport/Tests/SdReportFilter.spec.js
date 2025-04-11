import SdReportFilter from "../../Plugins/ServiceDesk/views/js/components/Report/SdReportFilter.vue";
import { mount } from '@vue/test-utils'
import MockAdapter from "axios-mock-adapter";

describe('SdReportFilter',()=>{

    let wrapper;
    let axiosMock;

    const updateWrapper = () => {

        wrapper = mount(SdReportFilter,{

            global: {
                stubs: ['dynamic-select'],
            },
            props: {
                metaData: [
                    { section: [{ value: '' }] },
                    { section: [{ value: '' }] },
                    { section: [{ value: '' }] },
                    { section: [{ value: '' }, { value: '' }] },
                ],
                appliedFilters: {},

                filterNum : '1'
            },
        })
    }

    beforeEach(()=>{

        axiosMock = new MockAdapter(axios);
        updateWrapper();
    });

    afterEach(()=> {

        axiosMock.restore();
    })

    it("is vue instance", async() => {
        expect(wrapper.exists()).toBeTruthy()
    });

    it("emits an `closeEvent` when `onCancel` method called", () => {

        wrapper.vm.onCancel()

        expect(wrapper.emitted()).toEqual({"selectedFilters": [["closeEvent"]]})
    });

    it("emits an `resetEvent` when `onReset` method called", () => {

        wrapper.vm.onReset()

        expect(wrapper.emitted()).toEqual({"selectedFilters": [["resetEvent"]]})
    });

    it('sets the filter mode and shows the modal when called', () => {
        wrapper.vm.onSave('add');
        expect(wrapper.vm.filterMode).toEqual('add');
        expect(wrapper.vm.showModal).toEqual(true);
    });
    it('emits a "closeEvent" when called', () => {
        wrapper.vm.onCancel();
        expect(wrapper.emitted()).toEqual({ selectedFilters: [['closeEvent']] });
    });
    it('updates the `asset_ids` filter value when called with an asset object', () => {
        wrapper.vm.onChange([{ id: 1, name: 'change' }], 'change_ids');
        expect(wrapper.vm.selectedFilters['change_ids']).toEqual([{ id: 1, name: 'change' }]);
    });

    it('updates the `assigned_on` filter value when called with a date string', () => {
        wrapper.vm.onChange('2023-05-01', 'assigned_on');
        expect(wrapper.vm.selectedFilters['assigned_on']).toEqual('2023-05-01');
    });

    it('Makes an API call', async () => {

        updateWrapper();
        mockGetRequest();
        await wrapper.vm.getFilterValue();

        setTimeout(()=>{

            expect(wrapper.vm.loading). toBe(false)

            expect(axiosMock.history.get[0].url).toEqual('/service-desk/api/agent/sd-filter/1');

        },50)
    })

    it('updates `loading` value as false if api returns error response',(done)=>{

        updateWrapper()

        mockGetRequest(400);

        wrapper.vm.getFilterValue()

        expect(wrapper.vm.loading).toBe(true)

        setTimeout(()=>{

            expect(wrapper.vm.loading).toBe(false)

            done();
        },1);
    });

    function mockGetRequest(status = 200,url = '/service-desk/api/agent/sd-filter/1'){

        const fakeData = {

            data: {
                "fields": [
                    {
                        "key": "change_ids",
                        "value": [
                            951,
                            1039
                        ],
                        "value_meta": [
                            {
                                "id": 951,
                                "name": "CHN-950",
                                "change_raised_on": "2023-03-28 08:27:17",
                                "change_closed_on": null,
                                "status_link": "",
                                "status": null
                            },
                            {
                                "id": 1039,
                                "name": "CHN-1039",
                                "change_raised_on": "2023-05-18 06:16:05",
                                "change_closed_on": null,
                                "status_link": "",
                                "status": null
                            }
                        ]
                    }
                ],
            }
        };

        axiosMock.onGet(url).reply(status,fakeData);
    }


})