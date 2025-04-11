import { mount } from '@vue/test-utils';

import AllScheduleList from "../../../views/js/components/Common/AllScheduleList.vue";

import MockAdapter from "axios-mock-adapter";

import axios from "axios";

let axiosMock;

let wrapper;

describe('AllScheduleList', () => {

    beforeEach(()=>{

        axiosMock = new MockAdapter(axios);

        wrapper = mount(AllScheduleList,{

            global : {

                stubs:['dynamic-datatable','user-column-list','schedule-filter']
            },

            data() {
                return {
                    filterParams: {}
                };
            }
        })
    })

    afterEach(() => {

        if(axiosMock) { axiosMock.restore();}
    });

    it("is vue instance",()=>{
        expect(wrapper).toBeTruthy();
    })

    it('default value for `loading` should be true', () => {
        wrapper.setData({ loading : true });
        expect(wrapper.vm.loading).toBe(true);
    });

    it('dynamic-datatable should not exists when page created', () => {
        expect(wrapper.find('dynamic-datatable').exists()).toBeFalsy();
    });

    it('check apiUrl for schedule list', () => {
        expect(wrapper.vm.apiUrl).toEqual('/schedules');
    });

    it('show filter box if `isShowFilter` is true', () => {
        wrapper.vm.isShowFilter = true;
        expect(wrapper.find('#filter-box')).toBeTruthy();
    });

    it("`isShowFilter` will false if function `selectedFilters` triggered with closeEvent", () => {
        wrapper.vm.isShowFilter = true;
        wrapper.vm.selectedFilters("closeEvent");
        expect(wrapper.vm.isShowFilter).toBe(false);
    });

    it("call resetFilter function if `selectedFilters` is triggered with resetEvent", (done) => {
        const resetFilterSpy = jest.spyOn(wrapper.vm, "resetFilter");
        wrapper.vm.selectedFilters("resetEvent");
        expect(resetFilterSpy).toHaveBeenCalled();
        setTimeout(()=>{
            expect(wrapper.vm.isShowFilter).toBe(false);
            done();
        },1)
    })

    it("function `resetFilter` will set the value to blank", (done) => {
        wrapper.vm.filterOptions = [{section : [{value: "something"}]},{section : [{value: "something"}]},];
        const resetFilterSpy = jest.spyOn(wrapper.vm, "resetFilter");
        wrapper.vm.selectedFilters("resetEvent");
        expect(resetFilterSpy).toHaveBeenCalled();
        setTimeout(()=>{
            expect(wrapper.vm.filterOptions[0].section[0].value).toBe("");
            expect(wrapper.vm.apiUrl).toBe("/schedules");
            done()
        },1)
    })

    it("function `resetFilter` will set the url to default", (done) => {
        wrapper.vm.filterOptions = []
        wrapper.vm.resetFilter();
        setTimeout(()=>{
            expect(wrapper.vm.apiUrl).toBe("/schedules");
            done()
        },1)
    })

    it("`toggleFilterView` should toggle the isShowFilter value", () => {
        wrapper.vm.isShowFilter = false;
        wrapper.vm.toggleFilterView();
        expect(wrapper.vm.isShowFilter).toBe(true);
    })

    it("set 0th index of `filterOptions` to value.reportType if not null", () => {
        let value = {
            "report_type": [{
                "id": 'report',
                "name": "report"
            }]
        }
        wrapper.vm.selectedFilters(value);
        expect(wrapper.vm.filterOptions[0].section[0].value).toEqual(value.report_type);
        expect(wrapper.vm.isShowFilter).toBe(false);
    })

    it('API call for getting Columns' , (done)=>{

        const getScheduleDataSpy = jest.spyOn(wrapper.vm, 'getScheduleData');
        wrapper.vm.getScheduleData()
        setTimeout(()=>{
            expect(getScheduleDataSpy).toHaveBeenCalled();
            expect(axiosMock.history.get[0].url).toBe('api/agent/report-config/schedule-report');
            done()
        },1)
    })

    it('API call for getting Columns - Error Handling', async () => {
        const getScheduleDataSpy = jest.spyOn(wrapper.vm, 'getScheduleData');
        await wrapper.vm.getScheduleData();
        expect(getScheduleDataSpy).toHaveBeenCalled();
        axiosMock.onGet('api/agent/report-config/schedule-report').reply(500);
        expect(wrapper.vm.columns).toHaveLength(0);
    });

    it('Populates the `columns` property with column data',  (done) => {
        axiosMock.onGet('api/agent/report-config/schedule-report').reply(200, {
            data: {
                sub_reports: [
                    {
                        id: 1,
                        columns: [
                            { key: 'type', label: 'Type', is_visible: true },
                            { key: 'interval', label: 'Interval', is_visible: false },
                        ],
                    },
                ],
            },
        });
         wrapper.vm.getScheduleData();
         wrapper.vm.$nextTick();
        setTimeout(()=>{
            expect(wrapper.vm.columns).toHaveLength(2);
            expect(wrapper.vm.columns[0].key).toBe('type');
            expect(wrapper.vm.columns[0].label).toBe('Type');
            expect(wrapper.vm.columns[0].is_visible).toBe(true);
            expect(wrapper.vm.columns[1].key).toBe('interval');
            expect(wrapper.vm.columns[1].label).toBe('Interval');
            expect(wrapper.vm.columns[1].is_visible).toBe(false);
            done()
        },1)
    });

    it('mounts `dynamic-datatable` only if loading columns length is non zero', ()=>{
        expect(wrapper.find('dynamic-datatable-stub').exists()).toBe(false);
    })

    it('assign `columns` value to columns and call updateVisibleColumns fn ', () => {
        wrapper.vm.updateVisibleColumns = jest.fn();
        wrapper.vm.onColumnUpdate([1,2,3]);
        expect(wrapper.vm.columns).toEqual([1,2,3]);
        expect(wrapper.vm.updateVisibleColumns).toHaveBeenCalled();
    })

    it('update visible columns when updateVisibleColumns called', () => {
        wrapper.vm.columns = [{key: 'key11', label: 'label11', is_visible: true}, {
            key: 'key22',
            label: 'label22',
            is_visible: false
        }];
        wrapper.vm.updateVisibleColumns();
        expect(wrapper.vm.visibleColumns).toEqual({key11: 'label11'});
        wrapper.vm.columns = [];
        wrapper.vm.updateVisibleColumns();
        expect(wrapper.vm.visibleColumns).toEqual({});
    })

})