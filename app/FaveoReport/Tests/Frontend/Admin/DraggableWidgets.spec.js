import { mount } from '@vue/test-utils'

import DraggableWidgets from "../../../views/js/components/Admin/DraggableWidgets.vue";

describe('DraggableWidgets',() => {

	let wrapper;

	const updateWrapper = () =>{
		
			wrapper = mount(DraggableWidgets,{

			props : { ticket : { id : '1', key : '1', value: '1', icon_color : 'red', icon_class : 'class'}}
		})  
	}
	
	beforeEach(() => {
		
		updateWrapper();
	})

	it('checks the prop :: ticket',()=>{
		
		expect(wrapper.props().ticket).toEqual({"icon_class": "class", "icon_color": "red", "id": "1", "key": "1", "value": "1"});
	});
})