<template>
  <v-app id="app">
    <v-toolbar color="red lighten-3" dark>
      <v-toolbar-title>Snippet App</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn flat @click="togglePostModal">New Snippet</v-btn>
    </v-toolbar>

    <v-container style="height: 1000px; max-width: 2400px;">
      <v-layout>
        <!-- xsN のように数値 N を加えることによって全体横幅の N/12 分の横幅を指定 -->
        <v-flex xs5>
          <h2>Select Language</h2>
          <!-- セレクトボックスの値が変わったときにabstructメソッドが動く -->
          <v-select v-model="selectedLanguage" :items="languages" label="Language" @change="abstruct"></v-select>
          <h2>Snippets Shortcut</h2>
          <ul>
            <li v-for="snippet in snippetList">
              <span id="name" @click="goElem(snippet.id)">[{{ snippet.language }}] {{ snippet.title }}</span>
            </li>
          </ul>
        </v-flex>
        <v-flex xs7 style="margin: 10px;">
          <h2>Search Snippet</h2>
          <v-text-field v-model="searchWord" @keyup="abstruct" label="Input keyword" style="margin-top :4px"></v-text-field>
          <v-card style="margin-top: 10px;" v-for="(snippet, index) in snippetList" :key="index">
            <v-card-title primary-title>
              <a v-bind:id="snippet.id"></a>
              <h3 class="headline" style="background-color:#FFCDD2">[{{ snippet.language }}] {{ snippet.title }}</h3>
            </v-card-title>
            <div style="margin: 10px 20px;">{{ snippet.contents }}</div>
            <v-card-actions>
              <v-btn flat color="red" @click="togglePutModal(snippet.id)">Update</v-btn>
              <v-btn flat color="gray" @click="toggleDeleteModal(snippet.id)">Delete</v-btn>
              <v-spacer></v-spacer>
              <v-btn flat color="red" v-on:click="goTop">Go Top</v-btn>
            </v-card-actions>
          </v-card>
        </v-flex>
      </v-layout>

      <!--
        v-dialog では v-model=変数名 で Vue 側で保持している変数（data: {} 内にある変数）を
        binding（紐づいている）させることができる。
        ここでは変数 dialogPostFlag が true の場合は表示、false の場合は非表示として Modal Window が表示される。
      -->
      <!-- POST用 -->
      <v-dialog v-model="dialogPostFlag" width="800" persistent>
        <v-card>
          <v-card-title class="headline red lighten-3 white--text" primary-title>
            Create Form
          </v-card-title>
          <v-text-field v-model="postTitle" label="Snippet Title" required style="margin: 30px 20px 20px"></v-text-field>
          <v-flex d-flex>
            <v-text-field v-model="postLanguage" label="Language" required style="margin: 20px 20px 0px"></v-text-field>
            <v-select v-model="postLanguage" :items="languagesForActions" label="Select from histroy" style="margin: 20px 20px 0px 0px"></v-select>
          </v-flex>
          <v-card-text>
            <p>Snippet</p>
            <div style="width: 100%;">
              <textarea v-model="postContents" style="width: 100%; height: 300px; background-color: #efefef; padding: 3px;"></textarea>
            </div>
          </v-card-text>

          <v-divider></v-divider>

          <v-card-actions>
            <v-btn color="#grey lighten-4" flat @click="togglePostModal">
              Cancel
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn color="red" flat @click="postSnippet">
              Add Snippet
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <!-- PUT用 -->
      <v-dialog v-model="dialogPutFlag" width="800" persistent>
        <v-card>
          <v-card-title class="headline red lighten-3 white--text" primary-title>
            Edit Form
          </v-card-title>
          <v-text-field v-model="putTitle" label="Snippet Title" required style="margin: 30px 20px 20px"></v-text-field>
          <v-flex d-flex>
            <v-text-field v-model="putLanguage" label="Language" required style="margin: 20px 20px 0px"></v-text-field>
            <v-select v-model="putLanguage" :items="languagesForActions" label="Select from histroy" style="margin: 20px 20px 0px 0px"></v-select>
          </v-flex>
          <v-card-text>
            <p>Snippet</p>
            <div style="width: 100%;">
              <textarea v-model="putContents" style="width: 100%; height: 300px; background-color: #efefef; padding: 3px;"></textarea>
            </div>
          </v-card-text>

          <v-divider></v-divider>

          <v-card-actions>
            <v-btn color="#grey lighten-4" flat @click="togglePutModal">
              Cancel
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn color="red" flat @click="putSnippet">
              Update Snippet
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

      <!-- DELETE用 -->
      <v-dialog v-model="dialogDeleteFlag" width="800" persistent>
        <v-card>
          <v-card-title class="headline red lighten-3 white--text" primary-title>
            Confirm
          </v-card-title>
          <v-spacer></v-spacer>
          <v-card-text>
            <p>本当に削除してもよろしいですか？</p>
          </v-card-text>

          <v-divider></v-divider>

          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="red" flat @click="deleteSnippet">
              Delete
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-container>
  </v-app>
</template>

<script>
  import axios from 'axios';

  export default {
    data () {
      return {
        snippetList: [],
        allData: [],
        languages: ['ALL'],
        languagesForActions: [],
        selectedLanguage: 'ALL',
        searchWord: '',
        dialogPostFlag: false,
        postTitle: '',
        postLanguage: '',
        postContents: '',
        dialogPutFlag: false,
        putTitle: '',
        putLanguage: '',
        putContents: '',
        dialogDeleteFlag: false
      }
    },
    mounted () {
      this.listSnippet();
    },
    methods: {
      listSnippet: function() {
        axios.get('/api/v1/snippets.json')
          .then(response => {
            this.allData = response.data
            this.snippetList = this.allData
            this.listLanguages();
            this.abstruct();
          }
        );
      },
      // セレクトボックスに表示するデータを集める
      listLanguages: function() {
        this.languages = ['ALL']
        this.languagesForActions = []
        for (var i=0;i<this.allData.length;i++) {
          // indexOf 関数では array.indexOf(str) と記述することで str の文字列が
          // array の何個目で一致するかを返し、一致しない場合は -1 と返す。
          if (this.languages.indexOf(this.allData[i].language) == -1) {
            this.languages.push(this.allData[i].language)
            this.languagesForActions.push(this.allData[i].language)
          }
        }
      },
      // セレクトボックスで選択した言語と一致するデータを取得する
      abstruct: function() {
        if (this.selectedLanguage == 'ALL') {
          this.snippetList = []
          for (var i=0;i<this.allData.length;i++) {
            if ((this.allData[i].contents.indexOf(this.searchWord) !== -1) || (this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].language.indexOf(this.searchWord) !== -1)) {
              this.snippetList.push(this.allData[i])
            }
          }
        } else {
          this.snippetList = []
          for (var i=0; i<this.allData.length; i++) {
            if (this.allData[i].language == this.selectedLanguage) {
              if ((this.allData[i].contents.indexOf(this.searchWord) !== -1) || (this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].language.indexOf(this.searchWord) !== -1)) {
                this.snippetList.push(this.allData[i])
              }                }
          }
        }
      },
      togglePostModal: function() {
        this.dialogPostFlag = !this.dialogPostFlag
      },
      postSnippet: function() {
        axios.post('/api/v1/snippets.json', {
          title: this.postTitle, language: this.postLanguage, contents: this.postContents
        })
        .then(response => {
          this.listSnippet();
          this.postTitle = ''
          this.postLanguage = ''
          this.postContents = ''
        });

        this.dialogPostFlag = false
      },
      togglePutModal: function(id) {
        axios.get('/api/v1/snippets/' + id + '.json')
          .then(response => {
            this.putTitle = response.data.title
            this.putLanguage = response.data.language
            this.putContents = response.data.contents
          });

        this.id = id
        this.dialogPutFlag = !this.dialogPutFlag
      },
      putSnippet: function() {
        axios.put('/api/v1/snippets/' + this.id + '.json', {
          title: this.putTitle, language: this.putLanguage, contents: this.putContents
        })
        .then(response => {
          this.listSnippet();
        });

        this.dialogPutFlag = false
      },
      toggleDeleteModal: function(id) {
        this.id = id
        this.dialogDeleteFlag = !this.dialogDeleteFlag
      },
      deleteSnippet: function() {
        axios.delete('/api/v1/snippets/' + this.id + '.json')
          .then(response => {
            this.listSnippet();
          });

        this.dialogDeleteFlag = false
      },
      goElem: function(id) {
        document.getElementById(id).scrollIntoView(true)
      },
      goTop: function() {
        document.getElementById("app").scrollIntoView(true)
      }
    }
  }
</script>

<style scoped>
</style>
