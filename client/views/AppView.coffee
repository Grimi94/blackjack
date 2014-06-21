class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    # when player stands : @model.get('dealerHand').dealerFlip()

  initialize: ->
    @playerBlackJack = @model.get('playerHand').hasBlackJack()
    @dealerBlackJack = @model.get('dealerHand').hasBlackJack()
    # console.log(playerBlackJack)
    if (@playerBlackJack or @dealerBlackJack) then @renderBlackJack()
    @model.get('playerHand').on('stand', => @model.get('dealerHand').dealerPlay())
    @model.get('playerHand').on('bust', =>
      @model.playerBust()
      @renderPlayerBust())
    @model.get('dealerHand').on('endGame', => @renderWinner())

    @render()

  renderBlackJack: ->
    @model.get('dealerHand').dealerFlip()
    if @playerBlackJack and @dealerBlackJack then setTimeout((=>alert('Push!')), 20)
    else if @playerBlackJack then setTimeout((=>alert('You have a blackjack !!')), 20)
    else if @dealerBlackJack then setTimeout((=>alert('Dealer has a blackjack !!')), 20)


  renderWinner: ->
    winner = @model.getWinner()
    @render()
    if winner.indexOf('dealerBusts') > -1 then setTimeout((=>alert('Dealer got busted, congratulations!!')), 20)
    else setTimeout((=>alert(winner + ' has won!!')), 20)

  renderPlayerBust: ->
    @render()
    setTimeout((=>alert('You have been busted! :(')), 20)

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

