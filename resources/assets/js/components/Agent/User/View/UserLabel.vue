<template>

  <div id="labels-div" class="btn-group">

    <button class="btn btn-sm btn-light " v-tooltip="lang('Labels')" data-bs-toggle="dropdown" id="labels-button" @click="getLabels(search)">

      <i class="fas fa-edit"></i>

      <span class="caret"></span>
    </button>

    <ul id="label-dropdown" class="dropdown-menu label_menu" @click="$event.stopPropagation()">

      <li v-if="loading">

        <loader :size="30" :duration="4000" :color="'#1d78ff'"></loader>
      </li>

      <template v-if="!loading">

        <li>

          <input type="search" class="form-control mb-1" name="label" :placeholder="lang('search')" v-model="search"
                 @input="getLabels(search)">

        </li>

        <template v-for="label in labels">

          <li v-if="label.status || selectedLabels.includes(label.name)" :class="['labels',{'active' : selectedLabels.includes(label.name)}]"
              @click="onClick(label.name)">

            <div class="color mr-2" id="label_color" :style="{'backgroundColor' : label.color}"></div>

            <label id="label_title" v-tooltip="{content: loadLabel(label.name), html: true}">

              <span v-html="subString(loadLabel(label.name))"></span>
            </label>

            <i v-if="selectedLabels.includes(label.name)" class="fas fa-times"
               :class="{cancel_ar : isRtlLayout, cancel : !isRtlLayout}"></i>

          </li>

        </template>

        <li v-if="labels.length === 0">

          <p class="text-center">{{lang('no_results_found')}}</p>
        </li>

        <li class="label_button">

          <button class="btn btn-sm btn-light" @click="onCancel()"
                  :class="{right :isRtlLayout, left : !isRtlLayout}">

            <i class="fas fa-times"> </i> {{lang('cancel')}}

          </button>

          <button class="btn btn-sm btn-primary left" @click="onSubmit()"
                  :class="{left : isRtlLayout, right : !isRtlLayout}">

            <i class="fas fa-check"> </i> {{lang('apply')}}

          </button>
        </li>
      </template>
    </ul>
  </div>
</template>

<script>

import { errorHandler, successHandler} from "../../../../helpers/responseHandler";

import axios from 'axios';

import {getSubStringValue, renderLabelWithEmoji} from "../../../../helpers/extraLogics";
export default{

  name : 'user-label',

  description : 'User label component',

  props : {

    userObj : { type : Object, default : ()=>{}},

    reloadDetails : { type : Function }
  },

  data(){

    return {

      labels : '',

      loading : true,

      checked :false,

      selectedLabels : [],

      show_loader : false,

      search : ''
    }
  },

  beforeMount(){

    this.getSelectedLabels();

  },

  methods :{

    getSelectedLabels(){

      if(this.userObj.labels){
        this.userObj.labels.forEach(el=>{
          this.selectedLabels.push(el.title)
        })
      }
    },

    subString(value){

      return getSubStringValue(value,30)
    },

    onCreate(){

      this.redirect('/labels/create')
    },

    onCancel(){

      var element = document.getElementById("label-dropdown");

      element.classList.remove("show");

      this.loading = false;
    },

    onClick(label){

      if(this.selectedLabels.includes(label)){

        for(var i in this.selectedLabels){

          if (this.selectedLabels[i] === label) {
            this.selectedLabels.splice(i, 1);
            break;
          }
        }
      } else {

        this.selectedLabels.push(label)
      }
    },

    getLabels(search){

      axios.get('/api/dependency/labels?limit=all&meta=true&limit-by-status=false&search-query='+search).then(res=>{

        this.loading = false;

        this.labels = res.data.data.labels;

      }).catch(error=>{

        this.loading = false;
      })
    },

    onSubmit(){

      this.loading = true;

      const data = {};

      data['user_id'] = this.userObj.id;

      data['labels'] = this.selectedLabels;

      axios.post('/labels-user',data).then(res=>{

        window.emitter.emit('refreshUserData');

        this.onCancel();

        this.loading = false;

        successHandler(res,'user-view');


      }).catch(err=>{

        this.onCancel();

        this.loading = false;

        errorHandler(err,'user-view');

      })
    },

    loadLabel(label) {
      return renderLabelWithEmoji(label);
    }
  }
};
</script>

<style scoped>

.btn-sm {
  background-image: inherit !important;
}

#label_color{
  margin-top: -1px;
}

li .color {
  border-radius: 3px;
  display: inline-block;
  height: 14px;
  vertical-align: middle;
  width: 14px;
}

.mr-2 {
  margin-right: 4px!important;
  margin-left: 4px!important;
}

.labels:hover,.active{
  background: #eee;
}

.labels,#label_title{
  cursor: pointer;
  margin-bottom: 3px !important;
  font-weight: 500;
}
.label_menu{
  width: 300px;
  padding: 10px;
  max-height: 200px;
  overflow-y: scroll;
  overflow-x: hidden;
}

#label-dropdown::-webkit-scrollbar-track
{
  background-color: #f1f1f1;
  border-radius:10px;
}

#label-dropdown::-webkit-scrollbar
{
  width: 6px;
  background-color: #f1f1f1;
}

#label-dropdown::-webkit-scrollbar-thumb
{
  background-color: #c1c1c1;
  border-radius: 10px;
}

.label_button{
  margin: 3px;
  margin-top: 10px;
  padding-bottom: 20px;
}

.left{
  float : left;
}

.right{
  float : right;
}

.has-search .form-control-feedback {

  color: #ccc;
}

.cancel{
  float: right;
  margin: 4px;
}

.cancel_ar{
  float: left;
  margin: 4px;
}

.new_left{
  margin-left: 4px !important;
  margin-top: -1px;
}

.new_right{
  margin-right: 14px !important;
  margin-top: -1px;
}

#labels-div .btn-xs { font-size: .75rem !important;}
</style>