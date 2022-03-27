## 初めてのwebpack
https://webpack.js.org/

1. 用意する開発環境

```
NodeJS
VSCode
```

2. nodeプロジェクトを初期化
   `npm init -y`

3. webpack関連libインストール
   `npm install -D webpack webpack-cli`



4. プロジェクトファイルを用意する

```
src
--index.html
--index.js (foo.js, bar.jsをインポート)
```

`npx webpack`を実行する

5. index.htmlからJSファイルをインポート、確認する



## webpackカスタマイズ

1. デフォルト設定を変更したい場合、設定ファイル作成するのはおすすめ

```js
# webpack.config.js
const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
  },
};
```


2. webpackのコンセプト
https://webpack.js.org/concepts/

```
- entry  入口
- output　出力
- loaders　各種ファイル解析用
- plugins　その他機能
- mode　パッケージモード
```

3. 出力名の設定

```
filename: [name].[contenthash].[ext]
```

   

## htmlをパッケージ

出力名変更すると、index.htmlも変更必要なので、動的に変更してもらう

```javascript
npm i html-webpack-plugin -D

const HtmlWebpackPlugin = require('html-webpack-plugin');
plugins: [new HtmlWebpackPlugin({ template: './src/index.html' })]
```

## webpack-dev-server

即時修正を反映するための有能なツール

```js
npm i webpack-dev-server -D  

devServer: {
    static: {
      directory: path.join(__dirname, 'public'),
    },
    compress: true,
    port: 9000,
  }
```

## 画像をパッケージ

画像のリソースをそのまま使用

```
#resource
module: {
    rules: [
        { test: /\.jpg$/, type: 'asset/resource'}]}

import vue from './imgs/vue.jpg'
const vueImg = document.createElement("img");
vueImg.src = vue;
document.body.appendChild(vueImg);
```

画像をDataUrl式のBase64文字列変更


```
#inline
{ test: /\.svg$/, type: 'asset/inline'},

```

リソースの出力名の変更

```
assetModuleFilename: 'images/[name].[contenthash].js',
```



## cssをパッケージ

通常のcssスタイルの使用

```
npm i style-loader css-loader -D

  module: {
    rules: [
      { test: /\.css$/, use: ['style-loader', 'css-loader'] }
    ],
  },

import './style.css'
```

scssを使用

```scss
$bg-color: rgb(182, 182, 182);

body {
  background-color: $bg-color;
}
```

```
npm i sass-loader sass -D

  module: {
    rules: [
      { test: /\.sass$/, use: [style-loader', 'css-loader', 'sass-loader'] }
    ],
  },
```

cssを単独のファイルに格納

```
npm i mini-css-extract-plugin -D

plugins: [new MiniCssExtractPlugin()],
{
  test: /\.css$/i,
  use: [MiniCssExtractPlugin.loader, "css-loader"],
},
```

cssの格納場所

`new MiniCssExtractPlugin({filename: 'css/[name].[contenthash].css'}),`



## ES6+ --> ES5

```js
export default class Book {
    name="";
    constructor(name) {
        this.name = name;
    }
    getName(){
        console.log(this.name);
        return this.name;
    }
}
```

古いブラウザはES6サポートしないため、javascriptのバージョンダウン行う

```
npm i babel-loader @babel/core @babel/preset-env -D

{ test: /\.js$/, exclude: /node_modules/, use: {
  loader: 'babel-loader',
  options: {
    presets: ['@babel/preset-env']
  }
}}
```



## 実践webpack for reactjs
```
npm i create-react-app -D

npx create-react-app demo

loader: "babel-loader",
options: {
  presets: ["@babel/preset-env", "@babel/preset-react"],
},

*import react for app.js
```

jsファイル構成の説明  フォルダ構造の変更

```
App.js
...
↓
app
 -- App.js
 -- ...
```

## おまけ

Javascriptのデバッグ-->Chrome

urlとwebrootを修正

