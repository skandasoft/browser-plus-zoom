{CompositeDisposable} = require 'atom'

module.exports = BrowserPlusZoom =
  subscriptions: null

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    atom.workspace.observePaneItems (editor) ->
      fn = ->
        return unless editor.view
        editor.view.subscriptions?.add atom.commands.add '.browser-plus', 'browser-plus-view:zoomIn': -> editor.view.zoom(10)
        editor.view.subscriptions?.add atom.commands.add '.browser-plus', 'browser-plus-view:zoomOut': -> editor.view.zoom(-10)
        editor.view.zoomFactor = 100
        editor.view.zoom = (factor)->
            if 20 <= @zoomFactor+factor <= 500
              @zoomFactor += factor
            # remove from ui
            atom.notifications.getNotifications()[0]?.dismiss()
            # remove from NotficationManager.notifications
            atom.notifications.clear()
            atom.notifications.addInfo("zoom: #{@zoomFactor}%", {dismissable:true})
            @htmlv[0].executeJavaScript("jQuery('body').css('zoom', '#{@zoomFactor}%')")
        # editor.view
      if editor.constructor.name is 'HTMLEditor'
         return if editor.uri is 'browser-plus://blank'
         setTimeout(fn,1000)

    # @subscriptions.add atom.commands.add 'atom-workspace', 'browser-plus-zoom:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
