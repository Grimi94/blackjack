class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  isStanding = false
  isBust = false

  hit: ->
    if @isStanding or @isBust
      return
    @add(@deck.pop()).last()
    if @scores()[0] > 21 then do @bust

  bust: ->
    if !@isDealer
      @trigger('bust')
      @isBust = true


  dealerFlip: ->
    @at(0).flip()

  stand: ->
    if (!@isStanding and !@isBust)
      @trigger('stand')
    @isStanding = true
    #trigger stand event

  dealerPlay: ->
    do @dealerFlip
    #check if scores().length === 1 then
    # if scores()[0] >= 17 stand
    # else hit
    #else
    #if scores(1) >= 18 and <= 21 stop
    #else if scores(0) >= 17 stop
    #else keep going

    playOn = true
    if @scores().length is 1
      if @scores()[0] > 16
        @trigger('endGame')
        playOn = false
    else
      if @scores()[0] > 16
        @trigger('endGame')
        playOn = false
      else if @scores()[1] > 17 and @scores()[1] < 22
        @trigger('endGame')
        playOn = false
    while playOn
      do @hit
      if @scores().length is 1
        if @scores()[0] > 16
          @trigger('endGame')
          playOn = false
      else
        if @scores()[0] > 16
          @trigger('endGame')
          playOn = false
        else if @scores()[1] > 17 and @scores()[1] < 22
          @trigger('endGame')
          playOn = false

  hasBlackJack: ->
    # score = @reduce (score, card) ->
    #   score + card.get 'value'
    # console.log([score])
    # if score is 21
    #   return true
    # else
    #   return false
    #
    # console.log(@at(0))
    if @at(0).get('value') is 1 and @at(1).get('value') is 10 or
    @at(0).get('value') is 10 and @at(1).get('value') is 1
      return true
    else
      return false


  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]

