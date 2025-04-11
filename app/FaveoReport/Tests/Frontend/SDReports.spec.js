import SDReports from "../../../Plugins/ServiceDesk/views/js/components/Report/SDReports.vue";
import { mount } from '@vue/test-utils';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { createRouter, createMemoryHistory } from 'vue-router';

describe('SDReports', () => {
    let wrapper;
    let axiosMock;

    const router = createRouter({
        history: createMemoryHistory(),
        routes: [] // Define routes if needed
    });

    const updateWrapper = () => {

        wrapper = mount(SDReports,{
            props: {
                id: 123,
                type: 'change-report', // Mocking a specific report type
                module: 2 // Mocking a specific module
            },
            global: {
                plugins: [router],
                stubs: ['sd-report-filter', 'data-widget', 'charts'],
            },

            scheduleList :jest.fn()
        });
    }

    beforeEach(() => {
        axiosMock = new MockAdapter(axios);
        updateWrapper();
    });

    afterEach(() => {
        axiosMock.restore();
    });

    it("is vue instance", async() => {
        expect(wrapper.exists()).toBeTruthy()
    });

    it('initializes with default values', () => {
        expect(wrapper.vm.isLoading).toBe(false);
        expect(wrapper.vm.isShowFilter).toBe(false);
        // Add more assertions for other default values if needed
    });

    it('toggles filter view when filter button is clicked', async () => {

        updateWrapper();
        expect(wrapper.vm.isShowFilter).toBe(false);
        await wrapper.find('#report-filter').trigger('click');
        expect(wrapper.vm.isShowFilter).toBe(true);
    });

    it('initially does not show the icon', async () => {
        expect(wrapper.find('#export-report-btn').exists()).toBe(false);
        expect(wrapper.find('#schedule-report').exists()).toBe(false);
    });

    it('should update filter fields correctly', async () => {
        const fields = [{ name: 'field1', value: 'value1' }, { name: 'field2', value: 'value2' }];
        wrapper.vm.updateFilterFields(fields);
        expect(wrapper.vm.customFields).toEqual(fields);
        // Add more assertions if necessary
    });

    it('Makes an Filter API call', async () => {

        updateWrapper();
        mockGetRequest();
        expect(wrapper.vm.isLoading).toBe(true)
        await wrapper.vm.getFiltersDetails();
        expect(axiosMock.history.get[0].url).toEqual('service-desk/api/report/details/123?include_filters=1');
    })

    it('updates `loading` value as false if api returns error response',(done)=>{

        updateWrapper()
        mockGetRequest(400);
        wrapper.vm.getFiltersDetails()
        expect(wrapper.vm.isLoading).toBe(true)
        setTimeout(()=>{
            expect(wrapper.vm.isLoading).toBe(false)
            done();
        },1);
    });

    it("`isShowFilter` will false if function `selectedFilters` triggered with closeEvent", () => {
        wrapper.vm.selectedFilters("closeEvent");
        expect(wrapper.vm.isShowFilter).toBe(false);
    });

    it("call resetFilter function if `selectedFilters` is triggered with resetEvent", (done) => {
        wrapper.vm.selectedFilters("resetEvent");
        setTimeout(()=>{
            expect(wrapper.vm.isShowFilter).toBe(false);
            done();
        },1)
    })

    it("`toggleFilterView` should toggle the isShowFilter value", () => {
        wrapper.vm.isShowFilter = false;
        wrapper.vm.toggleFilterView();
        expect(wrapper.vm.isShowFilter).toBe(true);
    })

    it('Makes an chart API call', async () => {

        updateWrapper();
        mockChartRequest();
        expect(wrapper.vm.isLoading).toBe(true)
        wrapper.vm.getChartDetails();
        setTimeout(()=>{
            expect(axiosMock.history.get[1].url).toBe('/service-desk/api/sd-report/2/123')

            done();
        },1)
    })

    it('sets showReport to false if fetchedData is empty', () => {
        const fetchedData = {
            value: {
                charts: [
                    { chart_parameters: [] },
                    { chart_parameters: [] }
                ],
                widgets: [
                    { value: 0 },
                    { value: 0 }
                ]
            }
        };
        wrapper.vm.updateShowReportValue(fetchedData);
        expect(wrapper.vm.showReport).toBe(false);
    });


    function mockGetRequest(status = 200,url = 'service-desk/api/report/details/123?include_filters=1'){

        const fakeData = {

            data: {
                sd_filter: { id: 1 },
                name: 'change-report',
                type: '2',
                // Add other required properties as needed
            }
        };

        axiosMock.onGet(url).reply(status,fakeData);
    }

    function mockChartRequest(status = 200, url = '/service-desk/api/sd-report/2/123') {
        const chartData = {
            data: {
                chartData: {
                    chart_type: 'donut',
                    value: 2,
                    name: 'problem'
                },
                widget: {
                    name: 'problem',
                    value: '3'
                }
            }
        };

        axiosMock.onGet(url).reply(status, chartData);
    }

});
