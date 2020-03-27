<template>
  <div>
    <router-view></router-view>
  </div>
</template>

<script>
  import Vue from 'vue'
  import VueRouter from 'vue-router'
  import Vuetify from 'vuetify'
  import 'vuetify/dist/vuetify.min.css';

  import SnippetIndex from 'SnippetIndex.vue'

  const router = new VueRouter({
    routes: [
      {
        path: '/',
        component: SnippetIndex
      }
    ]
  })

  Vue.use(VueRouter)
  Vue.use(Vuetify)

  export default {
    router
  }
</script>

<style scoped>
</style>
