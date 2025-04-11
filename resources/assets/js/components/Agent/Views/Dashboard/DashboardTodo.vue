<template>

  <div class="card card-light dashboard-widget-box">

		  <div class="card-header">

			  <h3 class="card-title"> <i class="fas fa-list-ul"></i> {{lang('todo')}}</h3>

        <div v-if="loading" class="card-tools">

          <button type="button" class="btn btn-tool rotating" data-card-widget="refresh" v-tooltip="lang('refresh')">

            <i class="fas fa-sync-alt"></i>
          </button>
        </div>
		  </div>

		  <!-- Show todo list if list is not empty -->
		  <div class="card-body todo-list-body">
        <alert componentName="todos-page"/>

			  <div class="row">
				  <div :class="editMode ? 'col-md-9' : 'col-md-12'">
					  <input class="form-control" :class="{ 'cursor-none': loading }" ref="todoInput" :disabled="loading" :placeholder="lang('todo_placeholder')" autofocus
							 v-model.trim="newTodoText" @keyup.enter="editMode ? editTodoName() : addNewTodo()">
				  </div>
				  <div class="col-md-3">
					  <button v-if="editMode" type="button" class="btn btn-light pull-right todo_edit_btn" v-tooltip="lang('cancel_editing')"
							  @click="cancelEditMode"><i class="fas fa-times"></i>&nbsp;{{lang('cancel')}}</button>
				  </div>
			  </div>

			  <!-- Show quote message if todo list is empty  -->
			  <div class="no-todo-section" v-if="todoList.length === 0">
				  <blockquote>&quot; {{lang('todo_quote')}} &quot;</blockquote>
			  </div>

			  <div class="scrollable-area mt-2" v-else  @scroll="handleScroll">
				  <draggable-element class="list-group" tag="ul" :list="todoList" @end="onReorder" itemKey="id">

					  <template #item="{element, index}" :key="element.id">
						  <li class="list-group-item todo_item">

							  <div class="row">
								  <div class="col-sm-9">
									  <!-- Todo marker -->
                    <span class="todo-mark" v-if="element.is_private" v-tooltip="trans('private_task')">
                   <i class="fas fa-lock fa-lg" aria-hidden="true" style="color:grey"></i>&nbsp;
                   </span>
                    <span class="todo-mark" @click="onTodoMarkClick(index)" v-tooltip="getTodoMarkerTitle(element.status)">
                   <i :class="getTodoIconClass(element.status)" aria-hidden="true" :style="{ color: getTodoIconColor(element.status) }"></i>
                   </span>
									  <!-- Todo name -->
									  <span class="text todo-text" :style="['completed', 'Closed'].includes(element.status) ? {'text-decoration': 'line-through'} : {}">{{element.name}}</span>

									  <!-- Todo status -->
                    <span class="badge text-bg-success text-lowercase ms-1" v-show="['Open'].includes(element.status)">
                    {{ element.status === 'Closed' ? 'Close' : lang(element.status) }}
                    </span>
                    <span class="badge text-bg-warning text-lowercase ms-1" v-show="['in-progress', 'In-progress'].includes(element.status)">
                     {{ lang(element.status) }}
                     </span>
                    <span class="badge text-bg-danger text-lowercase ms-1" v-show="['pending', 'Closed'].includes(element.status)">
                    {{ element.status === 'Closed' ? 'Closed' : lang(element.status) }}
                    </span>

                  </div>

								  <!-- Todo actions -->
								  <div class="todo-tools col-sm-3 text-end">
									  <i class="fas fa-trash" @click="deleteTodo(element.id, index)" style="cursor:pointer; color:red;"
										 v-tooltip="lang('remove')" aria-hidden="true"></i>&nbsp;
									  <i class="fas fa-pencil-alt" @click="onEditTodo(index)" style="cursor:pointer" v-tooltip="lang('edit')"
										 aria-hidden="true">

									  </i>
								  </div>
							  </div>
						  </li>
					  </template>
				  </draggable-element>
				  <infinite-loading @infinite="getTodoList" ref="infiniteLoading">
					  <template #spinner><span></span></template>
					  <template #complete><span></span></template>
				  </infinite-loading>
			  </div>
		  </div>
  </div>
  <delete-modal v-if="showModal" :onClose="onClose"  :showModal="showModal"  :deleteUrl="deleteUrl"  alertComponentName="todos-page"  :componentTitle="componentTitle"></delete-modal>
</template>

<script>

import axios from 'axios';
import draggable from 'vuedraggable'
import {errorHandler, successHandler } from "../../../../helpers/responseHandler";
import deleteModal from "../../../MiniComponent/DataTableComponents/DeleteModal.vue";

export default {

    name : 'dashboard-todo',

		data: () => {
			return {
        todoList: [],
        newTodoText: '',
        editMode: false,
        editTodoIndex: undefined,
        page: 1,
				loading :false,
        showModal :false,
        deleteUrl:'',
        componentTitle:'todos-page',
        neweditedTodo:{}
      }
		},

		beforeMount() {
			this.getTodoList();
    },

  created() {
    window.emitter.on('taskUpdated', () => {
       this.getTodoList(null, 'success', true);
      });
  },

  methods: {
    getTodoIconClass(status) {
      switch (status) {
        case 'Open':
          return 'text-success  fas fa-clock';
        case 'In-progress':
          return 'text-warning fas fa-hourglass-half';
        case 'Closed':
          return 'text-danger fas fa-minus-circle';
        default:
          return 'text-muted fas fa-question';
      }
    },


    getTodoIconColor(status) {
      const iconColors = {
        Open: 'green',
        'In-progress': 'orange',
        Closed: 'red',
        pending: 'red',
        'in-progress': 'orange',
        completed: 'green',
      };

      return iconColors[status] || 'red'; // Default color if status doesn't match
    },

			getTodoList($state, successResponse, calledAfterUpdate = false) {
        if (calledAfterUpdate) {
          this.page = 1;
          this.todoList = [];
        }

        this.loading = true;

				axios.get('api/agent/todo-list?page=' + this.page)
        .then(response => {
          if(successResponse) {
            successHandler(successResponse, 'todos-page');
            this.loading = false;
          }
          if (response.data.data.data.length) {
            this.page++;
            this.todoList = [...this.todoList, ...response.data.data.data];
			if($state){$state.loaded()};
            this.loading = false;

          } else {
			  if($state){$state.complete()};
            this.loading = false;
          }
        })
        .catch(error => {
          errorHandler(error, 'todos-page');
          this.loading = false;
				})
				.finally(() => {
                    setTimeout(()=>{

                        this.$refs.todoInput.focus();
                    },1)
				})
      },

      editTodoName() {
        if(typeof this.editTodoIndex !== 'undefined') {
          let clonedTodoList = JSON.parse(JSON.stringify(this.todoList));
          clonedTodoList[this.editTodoIndex].name = this.newTodoText;
          this.updateTodo(clonedTodoList).then(response => {
            successHandler(response, 'todos-page');
            this.todoList[this.editTodoIndex].name = this.newTodoText;
            this.newTodoText = '';
            this.editMode = false;
            this.loading = false;
          })
          .catch(err => {
            this.loading = false;
            errorHandler(err, 'todos-page');
          })
        }
      },

    onTodoMarkClick(index) {
      // Store the current status before making the API call
      const originalStatus = this.todoList[index].status;

      // Update the status to the next state
      this.todoList[index].status = this.getNextState(originalStatus);

      // Make the API call to update the status
      this.updateTodo([this.todoList[index]])
          .then(response => {
            if (response.data.success) {
              successHandler(response, 'todos-page');
            } else {
              // If the API response is not successful, revert the status back to the original state
              this.todoList[index].status = originalStatus;
              errorHandler(response, 'todos-page');
            }
            this.loading = false;
          })
          .catch(err => {
            // In case of an error, revert the status back to the original state
            this.todoList[index].status = originalStatus;
            errorHandler(err, 'todos-page');
            this.loading = false;
          });
    },

      getTodoMarkerTitle(currentState) {
        return this.trans('click_to_change_status') + `${this.trans(this.getNextState(currentState))}`;
      },

      getNextState(currentState) {
        const nextStateObj = {
          pending: 'in-progress',
          'in-progress': 'completed',
          completed: 'pending',
          Open: 'In-progress',
          'In-progress': 'Closed',
          Closed: 'Open'
        };

        return nextStateObj[currentState]
      },

      onReorder() {
        this.updateTodo(this.todoList).then(response => {
          successHandler(response, 'todos-page');
          this.loading = false;
        })
        .catch(err => {
          errorHandler(err, 'todos-page');
          this.loading = false;
        })
      },

      addNewTodo() {

      this.loading = true;
      if(this.newTodoText === ''){
        this.$store.dispatch('setAlert', {
          type: 'danger',

          message: this.lang('this_field_is_required'),

          component_name: 'todos-page'
        })

        this.loading = false;
      }
        axios.post('api/agent/create-todo', { name: this.newTodoText })
        .then(response => {
          this.newTodoText = '';
          this.getTodoList(null, response ,true);
          window.emitter.emit('refreshData')
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
          this.$store.dispatch('setAlert', {
            type: 'danger',
            message: error.response.data.message.name,
            component_name: 'todos-page'
          })
        })
      },

      deleteTodo(id) {
        this.showModal = true
        this.deleteUrl = 'api/agent/todo/' + id

      },

      onClose(){

        this.showDeleteModal = false;

        this.showAssociateModal = false;

        this.showModal = false
    },

    updateTodo(newTodoList) {
      if (this.editTodoIndex !== undefined) {
        const editedTodo = newTodoList[this.editTodoIndex];
        this.neweditedTodo = [editedTodo];
        if (editedTodo.name.length > 50) {
          this.$store.dispatch('setAlert', {
            type: 'danger',
            message: this.trans('name_should_be_less_than_50_characters'),
            component_name: 'todos-page'
          });
          this.loading = false;
          return;
        }
      }

      const todosToSend = this.neweditedTodo.length >= 0 ? this.neweditedTodo : newTodoList;

      // Proceed with updating the todos
      this.loading = true;
      return axios
          .post('api/agent/update-todos', { todos: todosToSend })
          .then(response => {
            successHandler(response, 'todos-page');
            this.loading = false;

            // Refresh data and reset states
            this.getTodoList(null, response, true);
            window.emitter.emit('refreshData');
            this.editMode = false;
            this.newTodoText = '';
          })
          .catch(error => {
            errorHandler(error, 'todos-page');
            this.loading = false;
          });
    },
    onEditTodo(index) {
      this.editMode = true;
      this.editTodoIndex = index;
      this.newTodoText = this.todoList[index].name;
      this.$nextTick(() => {
        this.$refs.todoInput.focus();
      });
    },

      cancelEditMode() {
        this.editMode = false;
        this.newTodoText = '';
        this.editTodoIndex = undefined;
      }
		},

		components: {
      'delete-modal': deleteModal,
      'draggable-element': draggable
		}
	};
</script>

<style type="text/css" scoped>
.scrollable-area {
  height: 90% !important;
  overflow-y: auto;
}
.todo-tools {
  display: none;
}
.list-group-item {
  cursor: move;
}
.list-group-item:hover .todo-tools {
  display: block;
}
.todo-text {
  padding-left: 7px
}
.todo-mark {
  cursor: pointer;
}
.todo_edit_btn { font-size: 12px !important;padding: 8px; }

.todo_item { border-bottom: 2px solid #dfdfdf; }

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.todo-list-body{
  overflow-y: hidden;
}

.cursor-none{
  cursor: not-allowed;
}

/* Apply the rotation animation when the button has a class of "rotating" */
.btn-tool.rotating i {
  animation: rotate 2s linear infinite; /* Adjust the duration and animation properties as needed */
}
</style>