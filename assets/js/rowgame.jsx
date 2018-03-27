import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root, channel) { 
  ReactDOM.render(<Demo channel = {channel}/>, root);
}

class Demo extends React.Component {
  constructor(props) {
    super(props);
    this.state = this.defaultState();
    this.channel = props.channel;
    
    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => {console.log("Unable to join", resp)});
  }

  defaultState() {
    var s = {
      "game_id": window.gameName,
      "host_id": -1,
      "host_name": "Loading...",
      "client_id": -2,
      "client_name": "Loading...",
      "board_size": 1,
      "win_length": 2,
      "cur_turn": 0,
      "is_started": false,
      "is_finished": false,
      "winner_id": 0,
      "move": [],
      "chat": [],
      "board": [["empty"]]
    };
    //console.log("def state", s)
    return s;
  }

  gotView(view) {
    //console.log("new view", view);
    if (view.board_size != this.state.board_size) {
      var board = [];
      for (var i = 0; i < view.board_size; i++) {
	var row = [];
	for (var j = 0; j < view.board_size; j++) {
          row.push("empty");
	}
	board.push(row);
      }
      this.state.board = board;
    }
    this.setState(view);
    for (var i=0; i<this.state.move.length; i++) {
      var m = this.state.move[i];
      console.log("m", m)
    }
  }

  isMyTurn() {
    return (this.state.curturn % 2 == 1) == (this.state.host == window.current_user_id);
  }
  
  handleClick(x,y) {
    console.log(this.isMyTurn());
    this.channel.push("click", {"x": x, "y": y})
	.receive("ok", this.gotView.bind(this));
  }

  handleStart() {
    this.channel.push("start")
	.receive("ok", this.gotView.bind(this));
  }

  handleJoin() {
    this.channel.push("join", current_user)
	.receive("ok", this.gotView.bind(this));
  }
  
  renderTile(x,y) {
    return (
      <Tile
        state = {this.state.board[y][x]}
        onClick = {() => this.handleClick(x,y)}
      />
    );
  }
  
  render() {
    var board = [];
    for (var i = 0; i < this.state.board_size; i++) {
      var row = [];
      for (var j = 0; j < this.state.board_size; j++) {
        row.push(this.renderTile(j,i));
      }
      var x = (<div className="row">{row}</div>);
      board.push(x);
    }
    return (
      <div>
	{board}
      </div>
    );
  }
}

function Tile(params) {
  var div_id = "tile-" + params.x + "-" + params.y;
  if (params.state == "white") {
    return (<button id={div_id} className="tile tile-white"/>);
  } else if (params.state == "black") {
    return (<button id={div_id} className="tile tile-black"/>);
  } else { //params.state = "empty"
    return (<button id={div_id} className="tile tile-empty" onClick={params.onClick}/>);
  }
}
