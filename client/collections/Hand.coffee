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
    #check if dealer
    @trigger('bust')

    alert('You are dead')
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
       # @endGame
        playOn = false
    else
      if @scores()[0] > 16
        #@endGame
        playOn = false
      else if @scores()[1] > 17 and @scores()[1] < 22
     #   @endGame
        playOn = false
    while playOn
      do @hit
      if @scores().length is 1
        if @scores()[0] > 16
        #  @endGame
          playOn = false
      else
        if @scores()[0] > 16
       #   @endGame
          playOn = false
        else if @scores()[1] > 17 and @scores()[1] < 22
          @endGame
          playOn = false



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

