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
    playerBlackJack = @model.get('playerHand').hasBlackJack()
    dealerBlackJack = @model.get('dealerHand').hasBlackJack()
    console.log(playerBlackJack)
    if (playerBlackJack or dealerBlackJack) then console.log('foo')
    @model.get('playerHand').on('stand', => @model.get('dealerHand').dealerPlay())
    @model.get('playerHand').on('bust', =>
      @model.playerBust()
      @renderPlayerBust())
    @model.get('dealerHand').on('endGame', => @renderWinner())

    @render()

  renderWinner: ->
    winner = @model.getWinner()
    if winner.indexOf('dealerBusts') > -1 then alert('Dealer got busted, congratulations!!')
    else alert(winner + ' has won!!')

  renderPlayerBust: ->
    alert('You have been busted! :(')

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

