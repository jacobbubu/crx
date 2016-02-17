# Overview

This is a scaffold project for building Chrome Extension using coffee-script, jade, stylus and supporting live-reload.

## Usage

Clone this repo and run:

```
git clone https://github.com/jacobbubu/crx.git
npm i
```

Run `npm start` will enter development mode with watching and then you need to load this unpakced extension into Chrome (In Chrome, find the menu in the right-top corner, More Tools->extensions).

The file changes in `src` folder will triggle the task running according to the configuration in `gulpfile.coffee`. That will also bump the manifest version temporarily (just in watching mode) and reload the extension automatically.

### Generate production distribution

```
npm run prod
```

### Generate development distribution without watching

```
npm run dev
```

## Features

## Manifest File
The manifest file in `src` is in `cson` format for easily editing. The `src/_locales` includes localized files that are also in `cson` format.

## Common JS File
There are different js files imported by different HTMLs respectively. The common part of these js files will be extracted by browserify and put it in a standalone `common.js` for page importing, like this:

``` jade
    body
        #container popup

        script(src='js/common.js') // common part of all js files
        script(src='js/popup.js')
```