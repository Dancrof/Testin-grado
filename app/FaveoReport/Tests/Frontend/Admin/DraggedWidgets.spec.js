import { mount } from '@vue/test-utils'

import DraggedWidgets from './../../../views/js/components/Admin/DraggedWidgets.vue'

describe('DraggedWidgets',() => {

	let wrapper;

	const updateWrapper = () =>{
		
			wrapper = mount(DraggedWidgets,{

			props : { removeItem : jest.fn(), ticket : { id : '1', key : '1', value: '1', icon_color : 'red', icon_class : 'class'}}
		})  
	}
	
	beforeEach(() => {
		
		updateWrapper();
	})

	it('calls `removeItem` method when `onDelete` method is called',()=>{
		
		wrapper.vm.onDelete({id:1,key:1,value:'test'});
			
		expect(wrapper.vm.removeItem).toHaveBeenCalled();
	});
})