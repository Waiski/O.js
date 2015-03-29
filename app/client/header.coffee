Template.headerTmpl.helpers
  showTemplate: ->
    Template[@.name]
  leftActionTemplate: ->
    Session.get 'leftAction'
  rightActionTemplate: ->
    Session.get 'rightAction'
  headerCenterTemplate: ->
    Session.get 'headerCenter'