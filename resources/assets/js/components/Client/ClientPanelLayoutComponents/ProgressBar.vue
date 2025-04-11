<template>
  <ul id="progressbar" class="col-md-6 offset-md-3 form-helper">
    <li v-for="step in steps" :id="step.id" :class="step.class" :style="style"><strong> {{ step.label }}</strong></li>
  </ul>
</template>

<script>

export default {

  name : 'verification-progress',

  description : 'Verification Progress Bar',

  props : {

    active : {type: String, required : true},

    token : {type: String, default: ''},
  },

  beforeMount() {
    this.getVerificationSteps();
  },

  data() {
    return {
      loading: false,

      steps : [],

      style : 'width:33.33%',

    }
  },

  methods : {

    getVerificationSteps() {

      axios.get('api/verification-steps?token='+this.token).then((res) => {
        this.steps = res.data.data.verifications;
        this.style = "width:"+ (100 / res.data.data.verifications.length) +"%";
        let isVerifiedAlready = true;
        this.steps.forEach( (step) => {
          if (step.id === this.active) {
            step.class = 'active';
            isVerifiedAlready = false;
          }

          if (isVerifiedAlready) {
            step.class = 'active';
          }

          return step;
        });
      })
    }
  },
}
</script>

<style scoped>

#progressbar {
  margin-bottom: 30px;
  overflow: hidden;
  color: lightgrey;
}

#progressbar .active {
  color: rgb(0, 154, 186);
}

#progressbar li {
  list-style-type: none;
  font-size: 15px;
  float: left;
  position: relative;
  font-weight: 400;
  text-align: center;
  z-index: 999;
}

/*Icons in the ProgressBar*/
#progressbar #otp-verify:before {
  font-family: FontAwesome;
  content: " \f023";
  text-align: center;
}

#progressbar #email-verify:before {
  font-family: FontAwesome;
  content: "\f0e0";
}

#progressbar #final:before {
  font-family: FontAwesome;
  content: "\f164";
}

/*Icon ProgressBar before any progress*/
#progressbar li:before {
  width: 50px;
  height: 50px;
  line-height: 45px;
  display: block;
  font-size: 20px;
  color: #ffffff;
  background: lightgray;
  border-radius: 50%;
  margin: 0 auto 10px auto;
  padding: 2px;
}

/*ProgressBar connectors*/
#progressbar li:after {
  content: '';
  width: 100%;
  height: 2px;
  background: lightgray;
  position: absolute;
  left: 0;
  top: 25px;
  z-index: -1;
}

/*Color number of the step and the connector before it*/
#progressbar li.active:before, #progressbar li.active:after {
  background: rgb(0, 154, 186);
}
</style>
