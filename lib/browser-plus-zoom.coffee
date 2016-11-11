{CompositeDisposable} = require 'atom'

module.exports = BrowserPlusZoom =
  subscriptions: null

  activate: (state) ->

    @subscriptions = new CompositeDisposable

  consumeAddPlugin: (@bp)->
    requires =
      onInit: ->
        jQuery.jStorage.set('zoomfactor','100')
      # js: ["resources/init.js"]
      # css:["resources/browser-plus-zoom.css"]
      menus:[
        {
          ctrlkey: 'ctrl+='
          fn: (evt,data)->
            return if location.href is 'browser-plus://blank'
            zoomFactor = 5 + Number( jQuery.jStorage.get('zoomfactor') or 100 )
            if zoomFactor > 300
              zoomFactor = 300
              alert('max zoom-out reached')
            jQuery('body').css('zoom', "#{zoomFactor}%")
            jQuery.jStorage.set('zoomfactor',zoomFactor)
            jQuery.notifyBar
                html: "zoom: #{zoomFactor}%"
                delay: 2000
                animationSpeed: "normal"
        }
        {
          ctrlkey: 'ctrl+-'
          fn: (evt,data)->
            return if location.href is 'browser-plus://blank'
            zoomFactor = Number( jQuery.jStorage.get('zoomfactor') or 100 ) - 5
            if zoomFactor < 30
              zoomFactor = 30
              alert('max zoom-out reached')
            jQuery('body').css('zoom', "#{zoomFactor}%")
            jQuery.jStorage.set('zoomfactor',zoomFactor)
            jQuery.notifyBar
                html: "zoom: #{zoomFactor}%"
                delay: 2000
                animationSpeed: "normal"

        }
      ]
    @bp.addPlugin requires,@

  deactivate: ->
    @subscriptions.dispose()
