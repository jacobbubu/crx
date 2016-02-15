# Overview

This is a scaffold project for building Chrome Extension using coffee-script, jade, stylus and support live-reload.

## Usage

Clone this repo and run:

```
npm i
```

Run `npm start` will enter the development mode with watchingm and then you need to load this unpakced extension in Chrome (More Tools->extensions).

Any changes in `src` folder will triggle different tasks been run, bump the manifest version temporarily and reload the extension automatically.

### Generate production dist.

```
npm run prod
```

### Generate development dist. without watching

```
npm run dev
```

## Features

## Manifest File
The manifest file in `src` is in `cson` format for easily editing. The `src/_locales` includes localized files that are also in `cson` format.

## Common JS File
There are different js files imported by different HTMLs respectively. The common part of these js files will be extracted by browserify and put it in a standalone `common.js` for importing, like this:

``` jade
    body
        #container popup

        script(src='js/common.js') // common part of all js files
        script(src='js/popup.js')
```