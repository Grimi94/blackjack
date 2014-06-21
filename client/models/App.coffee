#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

  playerBust: ->
    (@get 'dealerHand'). dealerFlip()
    #inform player that they lost and are terrible
    #subtract moneys?

  getWinner: ->
    playerScore = @get('playerHand').scores()
    dealerScore = @get('dealerHand').scores()

    if dealerScore.length > 1
      if dealerScore[1] > 21
        dealerScore = dealerScore[0]
      else
        dealerScore = dealerScore[1]
    else
      dealerScore = dealerScore[0]

    if playerScore.length > 1
      if playerScore[1] > 21
        playerScore = playerScore[0]
      else
        playerScore = playerScore[1]
    else
      playerScore = playerScore[0]

    if dealerScore > 21
      return 'Player -dealerBusts'
    if playerScore > dealerScore
      return 'Player'
    if dealerScore > playerScore
      return 'Dealer'
    return 'push'
