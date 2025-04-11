export const scriptMixin = {

    data () {

        return {

            scripts : []
        }
    },

    methods : {

        getScripts(valueOf) {

            this.loading = true;

            axios.get('/custom-js/get-list-of-scripts').then(res=>{

                this.loading = false;

                this.scripts = res.data.data[valueOf];

                this.fireScripts(this.$route.path,valueOf);

            }).catch(err=>{

                this.scripts = [];

                this.loading = false;
            })
        },

        fireScripts(path,valueOf = '') {

            let completePath = ''

            if(valueOf == 'adminlayout') {

                completePath = 'admin'+path;

            } else if(valueOf == 'agentlayout') {

                completePath = 'panel'+path;

            } else {

                completePath = path.slice(1)
            }

            for(let i in this.scripts) {

                if(this.scripts[i].parameter == 'Entire Layout') {

                    this.executeScript(this.scripts[i].script);

                } else if(this.scripts[i].parameter == completePath) {

                    this.executeScript(this.scripts[i].script);
                }
            }
        },

        executeScript(value) {

            let agentScript = document.createElement('script')

            let doc = document.implementation.createHTMLDocument(); // Sandbox

            doc.body.innerHTML = value; // Parse HTML properly

            [].map.call(doc.getElementsByTagName('script'), function(el) {

                agentScript.text = el.textContent;

                document.head.appendChild(agentScript);
            });
        },
    }
}