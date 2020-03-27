<template>
  <div id="app">
    <p>{{ message }}</p>
    <p>{{ message2 }}</p>
    <button @click="changeMsg">Change</button>
    <table border="1">
      <tr>
        <th>タイトル</th> <th>言語</th> <th>内容</th>
      </tr>
      <tr v-for="data in list">
        <td>{{ data.title }}</td> <td>{{ data.language }}</td> <td>{{ data.contents }}</td>
      </tr>
    </table>
    <button @click="listSnippet">listSnippet</button>
    <div>
      <input type="text" v-model="title" placeholder="title">
      <input type="text" v-model="language" placeholder="language">
      <input type="text" v-model="contents" placeholder="contents">
    </div>
    <button @click="postSnippet">postSnippet</button>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data() {
      return {
        message: "Hello Vue!",
        message2: "hoge",
        list: [{title: 'test1'}, {title: 'test2'}],
        title: 'new title',
        language: 'Ruby',
        contents: 'contents'
      }
    },
    // mounted で、アプリが立ち上がった最初のタイミングで実行される関数を定義。
    // this とすることで、Vue オブジェクト自身を指す事ができる。
    // this.setMsg() とすることで、これから定義する setMsg メソッドを実行できる。
    mounted() {
      this.setMsg();
    },
    methods: {
      setMsg: function() {
        // this.message とすることで、Vue オブジェクトの data 内で定義した変数 message を参照できる。
        this.message = 'Set Message';
      },
      changeMsg: function() {
        this.message = 'Changed Message'
        axios.get('/api/v1/snippets.json')
        .then(response => (
            // APIを使ってDBからjson形式のデータを取得
            this.message2 = response.data[0]['title']
          )
        )
      },
      listSnippet: function() {
        axios.get('/api/v1/snippets.json')
          .then(response => (
              this.list = response.data
          ))
      },
      postSnippet: function() {
        axios.post('/api/v1/snippets.json', { title: this.title, language: this.language, contents: this.contents })
          .then(response => (
            this.listSnippet()
          ))
      }
    }
  }
</script>

<style scoped>
</style>
