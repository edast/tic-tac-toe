
window.app = app = React.createClass
  getInitialState: ->
    items: [0,0,0,0,0,0,0,0,0]
    player: 1
    finished: -1

  render: ->
    li = (text, i) =>
      React.DOM.li {className: "cell", onClick: @onClick, 'data-id': i, 'data-val': text  }, @getSymbol(text)

    React.DOM.div {className: "wrapper"}, null, [
        React.DOM.div {className: "player"}, @getPlayerText()
        React.DOM.ul {className: "board"}, this.state.items.map li
        React.DOM.div {className: "player"}, @getFinishText()
      ]

  getSymbol: (i) -> ["", "X", "O"][i]

  getPlayerText: () ->
    if this.state.finished == -1
      "turn: player#{this.state.player}"
    else
      "GAME OVER"

  getFinishText: () ->
    switch this.state.finished
      when 0 then "its a draw"
      when 1,2 then "Player #{this.state.finished} wins!"
      else ''
        
  onClick: (e) ->
    if this.state.finished > -1 or e.target.getAttribute('data-val') isnt "0"
      return
    index = e.target.getAttribute('data-id')
    board = this.state.items
    p = this.state.player
    board[index] = p
    if p is 1
      p = 2
    else
      p = 1

    finished = isSolved board
    this.setState
      items: board
      player: p
      finished: finished

React.renderComponent app(null), document.getElementById 'container'


isSolved = (board) ->
  solutions = [7,56,73,84,146,273,292,448]
  for solution in solutions
    res = checkSolution board, solution
    if res.length == 3
      sum = (res.reduce (prev, curr) -> prev + curr)
      return sum / 3 if sum > 0 and sum % 3 is 0
  if isFull board
    0
  else
    -1

isFull = (arr) ->
  arr.filter (el) ->
    el is 0
  .length is 0

checkSolution = (arr, solution) ->
  arr.reduce (prev, curr, i) ->
    if !!(solution & (1<<i)) and curr > 0
      prev.push curr
    prev
  , []

