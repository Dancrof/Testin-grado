import { mount, RouterLinkStub } from '@vue/test-utils';

import LocationsIndex from '../../../views/js/components/LocationsIndex.vue';

let wrapper;

describe('LocationsIndex', () => {

	beforeEach(()=>{

		wrapper = mount(LocationsIndex,{
          global : { stubs : { 'router-link' : RouterLinkStub }}
        })
	})

  it("requestAdapter method should return `sort`, `order`, `search`, `page` & `limit`", () => {
    let reqAdptData = {
      "orderBy": "id",
      "ascending": true,
      "query": "something",
      "page": 10,
      "limit": 10
    }
    let reqAdptDataReturn = {
      "sort-field": "id",
      "sort-order": "asc",
      "search-query": "something",
      "page": 10,
      "limit": 10
    }
    expect(wrapper.vm.options.requestAdapter(reqAdptData)).toEqual(reqAdptDataReturn)
  });

  it("`responseAdapter` set edit_url, delete_url to the data property", () => {

    let responseAdpData = {
      "data": {
        "data": {
          "locations": [
            {"delete_url": "something","edit_url": "something", "id": 1},
          ],
          "total": 1
        }
      }
    }

    let responseAdpDataReturn =
      {"count": 1, "data": [{"delete_url": "undefined/api/location/delete/1", "edit_url": "/location/1/edit", "id": 1}]}
      expect(wrapper.vm.options.responseAdapter(responseAdpData)).toEqual(responseAdpDataReturn)
  });
})