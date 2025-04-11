<template>
    <div class="col-sm-12 text-md php-info">
        <div v-html="phpInfo"></div>
    </div>
</template>
<script>
export default {
    data() {
        return {
            phpInfo: ''
        };
    },
    created() {
        this.fetchPhpInfo();
    },
    methods: {
        fetchPhpInfo() {
            // Make an API call to the server to fetch PHP info
            // You can use Axios or any other HTTP library for this
            axios.get('/health/php/info')
                .then(response => {
                    this.phpInfo = response.data;
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }
};
</script>

<style>
    .php-info pre {margin: 0; font-family: monospace;}
    .php-info a:link {color: #009; text-decoration: none; background-color: #fff;}
    .php-info a:hover {text-decoration: underline;}
    .php-info table {border-collapse: collapse; border: 0; width: 934px; box-shadow: 1px 2px 3px #ccc;}
    .php-info .center {text-align: center;}
    .php-info .center table {margin: 1em auto; text-align: left;}
    .php-info .center th {text-align: center !important;}
    .php-info td, .php-info th {border: 1px solid #666; font-size: 75%; vertical-align: baseline; padding: 4px 5px;}
    .php-info th {position: sticky; top: 0; background: inherit;}
    .php-info h1 {font-size: 150%;}
    .php-info h2 {font-size: 125%;}
    .php-info .p {text-align: left;}
    .php-info .e {background-color: #ccf; width: 300px; font-weight: bold;}
    .php-info .h {background-color: #99c; font-weight: bold;}
    .php-info .v {background-color: #ddd; max-width: 300px; overflow-x: auto; word-wrap: break-word;}
    .php-info .v i {color: #999;}
    .php-info img {float: right; border: 0;}
    .php-info hr {width: 934px; background-color: #ccc; border: 0; height: 1px;}
</style>
