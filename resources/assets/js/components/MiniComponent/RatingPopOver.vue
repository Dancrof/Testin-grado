<template>
  <div>
    <faveo-box class="mb-0" title="Additional Ratings">
<!--      <span v-html="message"></span>-->
      <table>
        <tbody>
        <tr v-for="(rating, index) in ratings" :key="index">
          <td>{{ rating.name }}&nbsp;</td>
          <td>
            <star-rating class="tooltip-target additional-rating"
              :rating="rating.value" :max-rating="rating.scale"
               :read-only="true" :star-size="15" :show-rating="false"
            />
          </td>
        </tr>
        </tbody>
      </table>

    </faveo-box>
  </div>
</template>

<script>

export default {
  name: "RatingPopOver",


  data: () => ({
    value: ""
  }),
  props: {
    ratings: {type: Array, default: () => []}
  }
}
</script>

<style scoped>
  .additional-rating {
    margin-top: -5px !important;
  }
</style>