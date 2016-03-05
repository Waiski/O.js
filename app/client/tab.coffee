Template.tab.helpers
  transactions: ->
    Transactions.find { userId: @.user._id }, { sort: time: -1 }
  getTime: ->
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