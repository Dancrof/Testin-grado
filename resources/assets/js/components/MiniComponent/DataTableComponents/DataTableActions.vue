<template>

  <div class="actions-row">

    <router-link v-if="data.edit_url && panel != 'agent'" class="btn btn-light table_btn" :to="data.edit_url" v-tooltip="trans('edit')"
                 :target="data.tableName ? '_blank' : '' ">

      <i class="fas fa-edit"></i>
    </router-link>

    <template v-if="data.edit_url && panel == 'agent'">

      <router-link v-if="isEditable && !isAdminEditOrDeleteEnabled" class="btn btn-light table_btn" :to="data.edit_url" v-tooltip="trans('edit')">


        <i class="fas fa-edit"></i>
      </router-link>

      <template v-else>

				<span v-if="isAdminEditOrDeleteEnabled" v-tooltip="trans('task_not_edit')">

                    <button class="btn btn-light table_btn" :disabled="isAdminEditOrDeleteEnabled">

					    <i class="fas fa-edit"></i>
					</button>
				</span>

        <span v-else-if="disabled && !isAdminEditOrDeleteEnabled" v-tooltip="disabled ? trans('default_field_is_not_editable') : trans('can_not_edit_change_while_cab_is_in_pending')">

                    <button class="btn btn-light table_btn" :disabled="true">

                        <i class="fas fa-edit"></i>
                    </button>
                </span>
      </template>
    </template>

    <template v-if="data.canned_edit_url && panel == 'agent'">

      <span v-if="data.canned_edit_url" :class=" isAuthorAdminEditOrDeleteEnabled ? 'canned_cursor' : '' " v-tooltip="isAuthorAdminEditOrDeleteEnabled ? trans('permission_denied_edit_tooltip'): trans('edit') ">
          <router-link v-if="data.canned_edit_url" class="btn btn-light table_btn" :class="isAuthorAdminEditOrDeleteEnabled ? 'disabled' : ''" :to="data.canned_edit_url">
                <i class="fas fa-edit"></i>
          </router-link>
      </span>
    </template>

    <router-link v-if="data.settings_url" class="btn btn-light table_btn" :to="data.settings_url"
                 rel="noopener noreferrer" v-tooltip="trans('settings')">

      <i class="fas fa-cogs"></i>
    </router-link>

    <a v-if="data.edit_modal" class="btn btn-light table_btn" @click="showEditModalMethod" href="javascript:;"
       v-tooltip="disabled ? trans('default_field_is_not_editable') : trans('edit')" :disabled="disabled">

      <i class="fas fa-edit"></i>
    </a>

    <a v-if="data.download_url" class="btn btn-light table_btn" :href="data.download_url" v-tooltip="trans('download')">

      <i class="fas fa-download"></i>
    </a>

    <button v-if="data.download_check_url" class="btn btn-light table_btn" @click="checkExpiry()" v-tooltip="trans('download')">

      <i class="fas fa-download"></i>
    </button>

    <a v-if="data.filter_toggle_url" class="btn btn-light table_btn" href="javascript:;" v-tooltip="trans('edit')" @click="onToggle">

      <i class="fas fa-edit"></i>
    </a>

    <router-link v-if="data.view_url" class="btn btn-light table_btn cc" :to="data.view_url" v-tooltip="trans('view')">

      <i class="fas fa-eye"></i>
    </router-link>

    <span v-if="data.status_toggle_url">

			<button v-if="!data.active_status" class="btn btn-light table_btn" @click="showActivateModalMethod" v-tooltip="trans('activate')">

				<i class="fas fa-toggle-off"></i>
			</button>

			<span v-else v-tooltip="disabled ? trans('default_field_is_not_deactivatable') : trans('deactivate')">

				<button class="btn btn-light table_btn" :disabled="disabled" @click="showActivateModalMethod">
					<i class="fas fa-toggle-on"></i>
				</button>
			</span>
		</span>

    <a v-if="data.client_view_url" class="btn btn-light table_btn" :href="data.client_view_url"
       :target="data.tableName ? '_blank' : '' " v-tooltip="trans('view')">

      <i class="fas fa-eye"></i>
    </a>

    <template v-if="true">

            <span v-if="isAdminEditOrDeleteEnabled" v-tooltip="isAdminEditOrDeleteEnabled ? trans('task_not_delete') : trans('delete')">

	            <button v-if="data.delete_url" class="btn btn-light table_btn" @click="showModalMethod"
                      :disabled="isAdminEditOrDeleteEnabled">

					<i class="fas fa-trash"></i>
                </button>
            </span>

      <span v-else-if="isAuthorAdminEditOrDeleteEnabled" v-tooltip="isAuthorAdminEditOrDeleteEnabled ? trans('permission_denied_delete_tooltip') : trans('delete')">

	            <button v-if="data.delete_url" class="btn btn-light table_btn" @click="showModalMethod"
                      :disabled="isAuthorAdminEditOrDeleteEnabled">

					<i class="fas fa-trash"></i>
                </button>
            </span>

      <span v-else-if="!disabled" v-tooltip="disabled ? trans('default_field_is_not_deletable') : trans(getTip(data))">

		        <button v-if="data.delete_url" class="btn btn-light table_btn" @click="showModalMethod"
                    :disabled="disabled">

		            <i :class="data.deleteicon ? data.deleteicon : 'fas fa-trash'"></i>
		        </button>
            </span>
    </template>

    <transition name="modal">

      <delete-modal v-if="showModal" :onClose="onClose" :showModal="showModal" :deleteUrl="data.delete_url" :replace="data.replace" :title="data.title"
                    :dependency="data.dependency" :alertComponentName="alert" :isLinked="boolean(data.is_linked)" :dependencyId="data.id"
                    :modal_title="data.deleteTitle"
                    :componentTitle="componentTitle" :modalMessage="data.deleteMessage">

      </delete-modal>
    </transition>

    <transition name="modal">

      <data-table-modal v-if="showEditModal" title="edit" :onClose="onClose" :showModal="showEditModal"
                        :data="data" :apiUrl="data.edit_modal">
      </data-table-modal>
    </transition>

    <transition name="modal">

      <data-table-activate-modal v-if="showActiveModal" title="toggle_status" :onClose="onClose" :showModal="showActiveModal"
                                 :data="data" :apiUrl="data.status_toggle_url">
      </data-table-activate-modal>
    </transition>
  </div>

</template>

<script type="text/javascript">
import {boolean} from '../../../helpers/extraLogics'
import DeleteModal from "./DeleteModal.vue";
import DataTableModal from "./DataTableModal.vue";
import DataTableActivateModal from "./DataTableActivateModal.vue";
import {errorHandler} from "../../../helpers/responseHandler";
export default {
  name:"data-table-actions",
  description: "Contains edit, delete and view buttons as group which can be used as a component as whole. It is built basically for displaying edit, delete and view button in a datable.",
  props: {
    data : { type : Object, required : true },
    isAdminEditOrDeleteEnabled: { type: Boolean, required: false },
    isAuthorAdminEditOrDeleteEnabled: { type: Boolean, required: false },
    componentTitle: { type: String, default:''}
  },
  data(){
    return{
      showModal : false,
      showEditModal : false,
      showActiveModal : false,
      location: this.data.delete_url,
      alert : '',
      panel : ''
    }
  },

  computed : {

    disabled() {

      return boolean(this.data.is_default);
    },

    isEditable() {

      if(this.data.hasOwnProperty("is_edit")) {

        return boolean(this.data.is_edit);

      } else {

        return true;
      }
    }
  },

  created() {

    this.updateAlert()
  },

  methods:{

    checkExpiry() {

      axios.get(this.data.download_check_url).then(res=>{

        this.redirect(this.data.download_check_url);

      }).catch(err=>{

        errorHandler(err,'dataTableModal');
      })
    },

    getTip(value) {

      return value.deleteTip ? value.deleteTip : 'delete';
    },

    onToggle() {

      window.emitter.emit('filterToggleClicked',this.data)
    },

    updateAlert() {

      this.alert = this.data.alertComponentName ? this.data.alertComponentName : 'dataTableModal';

      this.panel = this.data.from ? this.data.from : 'admin';
    },

    showModalMethod(){
      if(this.data.is_default){
        this.showModal = false
      } else {
        this.showModal = true
      }
    },
    showEditModalMethod(){
      if(this.data.is_default){
        this.showEditModal = false
      } else {
        this.showEditModal = true
      }
    },

    showActivateModalMethod()
    {
      if(this.data.is_default && this.data.active_status){
        this.showActiveModal = false
      } else {
        this.showActiveModal = true
      }
    },

    onClose(){
      this.showModal = false;
      this.showEditModal = false;
      this.showActiveModal = false;
      this.$store.dispatch('unsetValidationError');
    },
  },
  components:{
    'delete-modal': DeleteModal,
    'data-table-modal': DataTableModal,
    'data-table-activate-modal': DataTableActivateModal
  }
};
</script>

<style scoped>
.actions-row a { padding-right: 10px;
  padding-left: 10px; }

.canned_cursor {
  cursor: not-allowed !important;
}
</style>
