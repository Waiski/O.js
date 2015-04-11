restoreEditObject = (saved) ->
  edit = new share.Edit(saved.maker)
  edit.time = saved.time
  edit.edits = saved.edits
  edit.original = unless _.isEmpty saved.original then saved.original else edit.getOlds()
  edit

share.Edit = (makerId) ->
  # Enable with accounts-package
  #@maker = if makerId then makerID else Meteor.userId() 
  @maker = ''
  @edits = {}
  return

share.Edit.prototype =
  # Required by EJSON
  typeName: ->
    'edit'

  # Original property can be used when creating edits so
  # that old properties don't always have to be passed
  setOriginal: (originalDoc) ->
    @original = EJSON.toJSONValue originalDoc

  add: (property, newVal, oldVal) ->
    # Some way of getting the old value must be available
    if not oldVal
      if @original[property]
        oldVal = @original[property]
      else
        throw new Meteor.Error 'No old value available!'
    if oldVal is newVal
      false
    else
      @edits[property] = set: newVal, old: oldVal
      true

  remove: (property) ->
    delete @edits[property]

  setter: ->
    this.time = new Date
    $set: @get(false)

  # Returns a modifier that adds this edit to the edits array
  pusher: ->
    saveable = @toJSONValue()
    delete saveable.original # The original document info does not need to be saved
    $push: editHistory: saveable

  undoSetter: ->
    $set: @get(true)

  getOlds: ->
    @get(true)

  get: (old) ->
    direction = if old then 'old' else 'set'
    obj = {}
    _.each @edits, (change, property) ->
      obj[property] = change[direction]
    obj

  toJSONValue: ->
    maker: @maker
    time: @time or new Date
    edits: @edits
    original: @original

EJSON.addType 'edit', (json) ->
  restoreEditObject json
