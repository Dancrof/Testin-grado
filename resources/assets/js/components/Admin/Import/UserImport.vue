S<template>
  <div class="col-sm-12">
    <custom-loader :animation-duration="4000" :size="60" v-if="loading"/>

    <div v-else>
      <faveo-box :title="trans('user_import')">
        <div class="row">
          <div class="col-md-12">
            <div class="table-responsive">
              <table class="table table-bordered">
                <thead class="thead-light">
                <tr>
                  <th>{{ trans('name') }}</th>
                  <th>{{ trans('type') }}</th>
                  <th>{{ trans('status') }}</th>
                  <th>{{ trans('ended_at')}}</th>
                  <th>{{ trans('created') }}</th>
                  <th>{{ trans('updated') }}</th>
                  <th>{{ trans('totalFailed_label') }}</th>
                  <th v-if="url">{{ lang('sd_import_result_action_label') }}</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                  <td>{{ responseData.import_name }}</td>
                  <td>{{ responseData.type }}</td>
                  <td>{{ responseData.is_complete }}</td>
                  <td>{{ responseData.ended_at }}</td>
                  <td>{{ responseData.totalCreated }}</td>
                  <td>{{ responseData.totalUpdated }}</td>
                  <td>{{ responseData.totalFailed }}</td>
                  <td v-html="getUrlAttribute" v-if="url"></td>
                </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </faveo-box>

      <div class="row" v-if="showFailedRows">
        <div class="col-sm-12">
          <faveo-box :title="trans('user_import_tracking_view_failed_box_label')">
            <data-table :url="failedRowsUrl" :dataColumns="['row', 'field', 'comment']"  :option="dataTableOptions"></data-table>
          </faveo-box>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import {useStore} from "vuex";
import {computed} from "vue";
import {getIdFromUrl} from "../../../helpers/extraLogics";

export default {
  name: "UserImport",

  description: 'Common component to track the import progress',

  data() {
    return {
      url:'',
      id : '',
      responseData: null,
      loading: true,
      dataTableOptions: {
        headings : { row : this.trans('row_number'), field: this.trans('field_name'), comment: this.trans('reason')},
        columnsClasses: { row: 'import__failed__row', field: 'import__failed__field', comment: 'import__failed__comment' },
        filterable: false,
        sortable: [],
        pagination:{chunk:5,nav: 'fixed',edge:true},
        requestAdapter(data) {
          return {
            page : data.page,
            limit : data.limit,
          };
        },
        responseAdapter({data}) {
          return {
            data: data.data.data.map(data => {
              return data;
            }),
            count: data.data.total
          }
        }
      }
    }
  },

  beforeMount() {

    this.id = getIdFromUrl(window.location.pathname);
    this.url = 'panel/user/list'
    this.getData();
  },

  computed: {
    getUrlAttribute() {
      const url = this.basePath() + '/' + this.url;
      const urlLabel = this.urlLabel ? this.urlLabel : this.lang('sd_importer_import_tracking_view_label')
      return `<p><a href="${url}">${urlLabel}</a></p>`;
    },

    showFailedRows() {
      return this.responseData.totalFailed > 0;
    },

    failedRowsUrl() {
      return `/user/import-tracking-failed/${this.id}`
    }
  },

  methods: {

      getData() {
        axios.get(`/user/import-tracking-details/${this.id}`)
            .then(response => {
              this.responseData = response.data.data;
              this.loading = false;
            })
      }
  }
}
</script>

<style>


</style>
