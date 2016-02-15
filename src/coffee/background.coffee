chrome.runtime.onInstalled.addListener (details) ->
    console.log 'previousVersion', details.previousVersion

# chrome.browserAction.setBadgeText {text: 'Wow!'}

console.log 'Event Page for Browser Action'
