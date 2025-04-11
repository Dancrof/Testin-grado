<template>

	<div  id="billing-packages" class="card card-light ">

		<div class="card-header pointer" @click="toggleCard">

			<h3 class="card-title">{{ lang('packages') }}</h3>

			<div class="card-tools">

        <button v-if="loading && cardOpen" type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

          <i class="fas fa-sync-alt"></i>
        </button>

				<a v-if="cardOpen && category === 'invoice'" class="btn-tool" @click="addInvoice()" v-tooltip="lang('create_invoice')" href="javascript:;">

					<i class="fas fa-plus"> </i>
				</a>

				<button type="button" class="btn btn-tool">

               <i :class="{'fas fa-angle-up' : cardOpen, 'fas fa-angle-down' : !cardOpen }" class="fs-25"></i>
           </button>
			</div>
		</div>

		<div v-if="cardOpen" class="card-body">

			<ul class="nav nav-tabs" role="tablist">

				<li v-for="section in tabs" class="nav-item">

					<a class="nav-link" :class="{ active: category === section.category }" data-bs-toggle="pill" role="tab" href="javascript:;"
						@click="packages(section.category)">

						{{lang(section.title)}} <span class="badge text-bg-primary">{{section.count}}</span>
					</a>
				</li>
			</ul>

			<div class="tab-content">

				<div class="active tab-pane">

					<component v-bind:is="currentTableComponent" :id="org_id" :ids="user_id" :category="category"
                     :apiEndpoint="apiUrl" :disableLoader="loaderState" @loaderValue="handelLoader">

				 </component>

				</div>
			</div>
		</div>

		<transition name="modal">

			<order-modal v-if="showModal" :showModal="showModal" :onClose="onClose" :orgId='org_id' :userId="user_id"
				:title="lang('create_invoice')">

			</order-modal>
		</transition>
	</div>
</template>

<script>

	import axios from 'axios';

	import {getIdFromUrl} from "../../../../../../../resources/assets/js/helpers/extraLogics";
	import BillingPackagesTable from "./BillingPackagesTable.vue";
	import Orders from "./Tables/Orders.vue";
	import Invoices from "./Tables/Invoices.vue";
	import OrdersModal from "./Tables/MiniComponents/OrdersModal.vue";

	export default {

		name : 'billing-packages',

		description : 'Billing packages datatable',

		props : {

      data : { type : [String, Object] },

			id : { type : [String, Number], default :''},

			ids : { type : [String, Number], default :''},
		},

		data(){

			return {
        pathName: '',

				category:'orders',

				tabs:[],

				user_id : '',

        org_id: '',

				loading:true,

				apiUrl : '',

				showModal : false,

				cardOpen : false,

        loaderState: ''
			}
		},

    beforeMount() {
      this.loaderState = JSON.parse(this.data).disableLoader;
    },

    watch : {

			category(newValue,oldValue){
				return newValue
			},
		},

		computed : {
			currentTableComponent(){
				return this.category === 'orders' ? 'orders-table' : 'invoices-table';
				},
		},

		methods :{

			toggleCard() {

             this.cardOpen = !this.cardOpen;

             if(this.cardOpen) {

             	const path = window.location.pathname;

               this.pathNameArray = path.split('/')

               this.pathName = this.pathNameArray.includes('organizations')?'organizations':'user';

					    this.user_id = getIdFromUrl(path);

               this.org_id = getIdFromUrl(path);

               this.getCount();

					this.getTableData(this.category);
             }
         },

			getTableData(category) {

        if ( this.pathName === 'user') {
          this.apiUrl = category === 'orders' ? '/bill/package/get-user-packages?user_id='+this.user_id : '/bill/package/get-user-invoice?users[0]='+this.user_id
        }
        else if (this.pathName === 'organizations' )
        {
          this.apiUrl = category === 'orders' ? '/bill/package/get-organization-packages/' + this.org_id : '/bill/package/get-organization-invoice/' + this.org_id
        }
      },

			packages(category){
				this.category = category
				this.getCount();
				this.getTableData(category);
			},

			getCount(){
        let id = this.pathName === 'organizations'? this.org_id : this.user_id;
				axios.get('/bill/package/get-all-count/'+id+'?category='+this.pathName).then(res=>{
					this.tabs = [
						{category:'orders',title:'orders',b_class:'badge bg-orange',count:res.data.data.userpackage},
						{category:'invoice',title:'invoice',b_class:'badge bg-red',count:res.data.data.invoice},
					]
				}).catch(err=>{ this.tabs = [] })
			},

			onClose(){
				this.showModal = false;
				this.packages('invoice');
				this.$store.dispatch('unsetAlert');
			},

			addInvoice()
			{
				this.showModal = true;
			},

      handelLoader(loader){
        this.loading = loader;
      }
		},

		components : {

			'billing-packages-table' : BillingPackagesTable,
			
			'orders-table' : Orders,

			'invoices-table' : Invoices,

			'order-modal': OrdersModal,
		},
	};
</script>

<style scoped>

	.fs-25 { font-size: 25px !important; }

  @keyframes rotate {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  /* Apply the rotation animation when the button has a class of "rotating" */
  .btn-tool.rotating i {
    animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
  }
</style>
