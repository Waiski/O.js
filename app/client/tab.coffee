ticker = new Tracker.Dependency

Template.tab.onRendered ->
  # Re-run time-dependent stuff every 10 seconds
  @intervalId = setInterval ->
    ticker.changed()
  , 10000

Template.tab.onDestroyed ->
  clearInterval @intervalId

Template.tab.helpers
  transactions: ->
    # TODO: some limiting/pagination, the moment calls etc.
    # might get quite expensive for 1000+ transactions...
    Transactions.find { userId: @.user._id }, { sort: time: -1 }
  getTime: ->
    ticker.depend()
    if @time > moment().subtract(1, 'day').toDate()
      moment(@time).fromNow()
    else
      moment(@time).format 'HH:mm DD.MM.YYYY'
  getDoneBy: ->
    user = Meteor.users.findOne @doneBy
    if user then user.username else 'Unknown'
  getColor: ->
    val = @user.tabValue
    # Just some fun colors based on tab value,
    # these could be adjusted if need be.
    if val > 50
      'red'
    else if val > 0
      'orange'
    else if val is 0
      'blue'
    else if val < -50
      'green'
    else # -50 - 0
      'olive'
  action: ->
    ticker.depend()
    # For recent transactions
    if @time > moment().subtract(5, 'minutes').toDate()
      'undoLink'
    else
      undefined

