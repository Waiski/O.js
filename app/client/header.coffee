Template.headerTmpl.helpers
  showTemplate: ->
    Template[@.name]
  headerCenterTemplate: ->
    Session.get 'headerCenter'