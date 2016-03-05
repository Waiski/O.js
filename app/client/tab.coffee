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