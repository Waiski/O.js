restoreEditObject = (saved) ->
  edit = new share.Edit(saved.maker)
  edit.time = saved.time
  edit.edits = saved.edits
  edit.original = unless _.isEmpty saved.original then saved.original else edit.getOlds()
  edit

share.Edit = (makerId) ->
  @maker = if makerId then makerId else Meteor.userId() 
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
    if not oldVal
      if _.contains Drink.prototype.topLevelProps, property
        orig = @original[property]
      else if @original.properties and @original.properties[property]
        oldVal = @original.properties[property]
      else
        oldVal = "" # Default to empty

    if oldVal is newVal
      # If trying to set to the old value, just ignore
      # this from the edit object altogether. Note that
      # the edit might already be done, and now the
      # user wants to restore the old value.
      delete @edits[property]
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
    # These are separately defined in the Drink schema
    # and don't go in the properties-subobject
    _.each @edits, (change, property) ->
      # Note that the setter needs to work with the dot notation so that
      # the whole properties object won't be replaced on update.
      propName = if _.contains(Drink.prototype.topLevelProps, property) then property else 'properties.' + property
      obj[propName] = change[direction]
    obj

  toJSONValue: ->
    maker: @maker
    time: @time or new Date
    edits: @edits
    original: @original

EJSON.addType 'edit', (json) ->
  restoreEditObject json

# For validating objects that store edit history
share.EditSchema = new SimpleSchema
  maker: 
    type: String
    regEx: SimpleSchema.RegEx.Id
  time:
    type: Date
  edits:
    type: Object
    blackbox: true
