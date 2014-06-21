class window.CardView extends Backbone.View

  className: 'card'

  template: _.template '<%= rankName %> of <%= suitName %>'

  initialize: ->
    @model.on 'change', => @render
    if !(@model.get 'revealed')
      @path = 'img/card-back.png'
    else
      @path = 'img/cards/' + @model.get('rankName').toString().toLowerCase()  + '-' + @model.get('suitName').toLowerCase() + '.png'
    @render()


  render: ->
    @$el.children().detach().end().html
     #@$el.html @template @model.attributes
    @$el.append('<img src="' + @path + '"/>')
    @$el.addClass 'covered' unless @model.get 'revealed'
