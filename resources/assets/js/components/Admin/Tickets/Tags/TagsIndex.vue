<template>
	
	<div id="tags-list" class="col-sm-12">
		
		<alert componentName="dataTableModal" />

		<faveo-box :title="trans('list_of_tags')">

            <template #customActions>

                <div class="card-tools">

                    <router-link class="btn btn-tool" to="/tag/create" v-tooltip="trans('create_tag')">

                        <i class="glyphicon glyphicon-plus"> </i>
                    </router-link>
                </div>
            </template>

			<data-table :url="apiUrl" :dataColumns="columns"  :option="options" scroll_to ="tags-list">
					
			</data-table>
		</faveo-box>
	</div>
</template>

<script>

import {getSubStringValue, lang, renderLabelWithEmoji} from '../../../../helpers/extraLogics'
    import DataTableActions from "../../../MiniComponent/DataTableComponents/DataTableActions.vue";
	
	export default {

		name : 'source-index',

		data () {

			return {

				columns : ['name', 'ticket_count', 'visible_to', 'description', 'action'],

				apiUrl : '/api/tags-list',

				options : {}
			}
		},

		beforeMount () {

			const self = this;

			this.options = {

        headings : {
          name: this.trans('name'),

          ticket_count : this.trans('ticket_count'),

          visible_to : this.trans('visible_to'),

          description : this.trans('description'),

          action : this.trans('actions')
        },

				columnsClasses : {

					name: 'tag-name',

					ticket_count : 'tag-count',

					visible_to : 'tag-visible',

					description : 'tag-desc',

					action: 'tag-action',
				},

				sortIcon: {

					base : 'glyphicon',

					up: 'glyphicon-chevron-down',

					down: 'glyphicon-chevron-up'
				},

				texts: { filter: "", limit: "" },

				templates: {

          name: function(createElement, row) {
            let icon = self.h('i', { class: 'fas fa-tag' });

            // Extract emoji short codes and their positions
            let emojiMatches = [...row.name.matchAll(/:\w+:/g)];
            let textWithoutEmojis = row.name.replace(/:\w+:/g, '');

            // Get the substring of the text without emojis
            let subStringText = self.subString(textWithoutEmojis);

            // Reinsert the emoji short codes at their original positions
            let finalText = subStringText;
            emojiMatches.forEach(match => {
              let position = match.index;
              if (position < subStringText.length) {
                finalText = finalText.slice(0, position) + match[0] + finalText.slice(position);
              } else {
                finalText += match[0];
              }
            });

            let span = self.h('span', {
              style: {
                backgroundColor: 'lightgray', color: '#444', fontSize: '12px',
              },
              title: self.loadLable(row.name),
              class: 'badge',
            }, [icon, '\u00A0', self.loadLable(finalText)]);

            return self.h('div', [span]);
          },

					description(h,row) {

						return row.description ? row.description : '--'
					},

					visible_to(h,row) {

						if(row.visible_to) {

							let arr = [];

							 row.visible_to.split(',').forEach((value)=>{ arr.push(lang(value)) })

							return arr.toString();
						} else {

							return '--'
						}
					},

					ticket_count: function(createElement, row) {

						return self.h('a', {

                            href: self.basePath() + '/panel/tickets?show%5B%5D=inbox&departments%5B%5D=All&filter-by-url=1&category=all&tag-ids[]=' + row.id,

						}, row.ticket_count);
					},

		  			action: (f,row) => {

                        return self.h(DataTableActions,{
                            data : row
                        })
                    },
				},
				
				sortable: [ 'name', 'description' ],

				filterable: [ 'name', 'description' ],
				
				pagination:{chunk:5,nav: 'fixed',edge:true},
				
				requestAdapter(data) {
			  	
			  		return {
				 		
				 		'sort-field': data.orderBy ? data.orderBy : "id",
				 		
				 		'sort-order': data.ascending ? "desc" : "asc",
				 		
				 		'search-query': data.query.trim(),
				 		
				 		page: data.page,
				 		
				 		limit: data.limit
			  		};
				},

				responseAdapter({ data }) {  

			  		return {
				 		
				 		data: data.data.tags.map(data => {
							
							data.edit_url = "/tag/" + data.id + '/edit';
							
							data.delete_url = self.basePath() + "/api/tag-delete/" + data.id;
							
							return data;
				 		}),
				 		
				 		count: data.data.total
			  		};
				},

				orderBy: { column: 'id', ascending: true },
		 	};
		},

    methods: {

      loadLable(name) {

        return renderLabelWithEmoji(name);
      },

      subString(value){
        return getSubStringValue(value,30)
      },
    }
	};
</script>

<style>
	
	.tag-name,.tag-desc,.tag-count,.tag-action,.tag-visible{ max-width: 250px; word-break: break-all;}
	
	#tags-list .VueTables .table-responsive {
		overflow-x: auto;
	}

	#tags-list .VueTables .table-responsive > table{
		width : max-content;
		min-width : 100%;
		max-width : max-content;
		overflow: auto !important;
	}
</style>