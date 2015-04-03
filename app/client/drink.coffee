Template.drink.helpers
    getSize: ->
        width = Session.get 'viewportWidth' # This is set in main.coffee
        if width > 1000
            [0.6 * width,undefined] 
        else if width > 800
            [0.8 * width,undefined]
        else 
            [width,undefined]