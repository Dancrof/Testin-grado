<template>

    <div :class="classname" v-if="articles.length">

        <div class="widget-area">

            <section id="section-popular-articles">

                <h2 class="section-title h4 clearfix" :class="{align1: lang_locale == 'ar'}">
                    <i class="line" :style="lineStyle"></i>{{ lang('kb_popular_articles') }}
                </h2>

                <div class="list-group ">

                    <router-link v-for="article in articles" :key="article.id" :title="article.name" :to="{ name:'Articles', params:{slug:article.slug} }"
                                 class="list-group-item list-group-item-action article" :class="{align1: lang_locale == 'ar'}" :id="'kb_popular_article_'+article.id">
                        <span :title="`${article.visits} Visist(s)`" :class="{left: lang_locale == 'ar'}" class="badge badge-pill pull-right float-end"
							id="badge" :style="badgeStyle">{{article.visits}}
							</span>
                        {{subString(article.name)}}
                    </router-link>

                </div>

            </section>

        </div>

    </div>

</template>

<script>

    import { getSubStringValue } from '../../../../../helpers/extraLogics';

    import axios from 'axios';

    export default {

        name : "popular-article-sidebar",

        description : "This component shows popular articles",

        props:{

            classname:{type:String},

            layout : { type : Object, default : ()=>{}},
        },

        mounted() {
            this.getPopularArticles();
        },

        data() {
            return {

                lineStyle: {

                    borderColor : this.layout.portal.client_header_color,
                },

                badgeStyle : {

					backgroundColor : this.layout.portal.client_header_color
				},

                lang_locale : this.layout.language,

                articles: []
            }
        },

        methods : {

            subString(value){

                return getSubStringValue(value,20)
            },

            async getPopularArticles() {
                try {
                    let { data } = await axios.get('/api/popular-articles')
                    this.articles = data.data.popular_articles
                } catch (e) {
                    // no use of handling; since if this request fails no state data is changed
                }
            }
        }
    };

</script>

<style scoped>

    .article {
        padding: 5px !important;
        margin-bottom: 4px !important;
        border-radius: 0 !important;
    }

    #badge {
        color: white !important;
        font-weight: 300 !important;
    }

</style>
