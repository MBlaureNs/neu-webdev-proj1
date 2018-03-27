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
      .receive("error", resp => {console.log("Unable to join", resp);});
    this.channel.on("update", this.gotView.bind(this));
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
      "board": [[]]
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
      view.board = board;
    } else {
      view.board = this.state.board;
    }
    for (var i=0; i<view.move.length; i++) {
      var m = view.move[i];
      if (m.turn % 2 == 0) {
	view.board[m.y][m.x] = "white";
      } else {
	view.board[m.y][m.x] = "black";
      }
      //console.log("m", m);
    }
    this.setState(view);
    //console.log(this.state);
  }

  isHost() {
    return this.state.host_id == window.current_user_id; 
  }

  isClient() {
    return this.state.client_id == window.current_user_id;
  }

  isSpec() {
    return !this.isHost() && !this.isClient();
  }
  
  isMyTurn() {
    return !this.state.is_finished &&
      this.state.is_started &&
      !this.isSpec() &&
      ((this.state.cur_turn % 2 == 1) == this.isHost());
  }
  
  handleClick(x,y) {
    console.log(this.isMyTurn());
    this.channel.push("click", {"x": x, "y": y, "turn": this.state.cur_turn})
	.receive("ok", this.gotView.bind(this));
  }

  handleStart() {
    this.channel.push("start")
	.receive("ok", this.gotView.bind(this));
  }

  handleJoin() {
    this.channel.push("join", {"client": window.current_user_id})
	.receive("ok", this.gotView.bind(this));
  }
  
  renderTile(x,y) {
    var c = this.state.board[y][x];
    //console.log("c",y,x,this.state.board,this.state.board[y],this.state.board[y][x],c);
    return (
      <Tile
        state = {c}
        onClick = {() => this.handleClick(x,y)}
	x = {x}
	y = {y}
	isMyTurn = {this.isMyTurn()}
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
      <div className="container">
	<RuleBar
	   win_length={this.state.win_length}
	   />
	<StatusBar
	   turn={this.state.cur_turn}
	   start={this.state.is_started}
	   finish={this.state.is_finished}
	   host_id={this.state.host_id}
	   host_name={this.state.host_name}
	   client_id={this.state.client_id}
	   client_name={this.state.client_name}
	   winner_id={this.state.winner_id}
	   isHost={this.isHost()}
	   isClient={this.isClient()}
	   isSpec={this.isSpec()}
	   start_onClick={() => this.handleStart()}
	   join_onClick={() => this.handleJoin()}
	   />
	{board}
      </div>
    );
  }
}

function RuleBar(params) {
  var p = params;
  return (
    <div id="rule-bar" className="row">
      {p.win_length} in a row to win
    </div>
  );
}

//this is the worst code i've written
function StatusBar(params) {
  var p = params;

  if (p.finish) {  //game finished
    if (p.winner_id == p.host_id) { //host won
      return (
	<div id="status-bar" className="row">
	  Game over<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  Winner: {p.host_name}
	</div>
      );
    } else { //p.winner_id == p.client_id, client won
      return (
	<div id="status-bar" className="row">
	  Game over<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  Winner: {p.client_name}
	</div>
      );
    }
  } else if (p.start) { //game in progress
    var whoseTurn = "";
    if (p.turn % 2 == 1) {
      whoseTurn = p.host_name + "'s turn";
    } else {
      whoseTurn = p.client_name + "'s turn";
    }
    if (p.isSpec) {
      return (
	<div id="status-bar" className="row">
	  You are spectating:<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  Turn: {p.turn}<br/>
	  {whoseTurn}<br/>
	</div>
      );
    } else if (p.isClient) {
      return (
	<div id="status-bar" className="row">
	  You are client:<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  Turn: {p.turn}<br/>
	  {whoseTurn}<br/>
	</div>
      );
    } else { //p.isHost
      return (
	<div id="status-bar" className="row">
	  You are host:<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  Turn: {p.turn}<br/>
	  {whoseTurn}<br/>
	</div>
      );
    }
  } else if (p.client_id) { // client joined
    if (p.isSpec) {
      return (
	<div id="status-bar" className="row">
	  You are spectating:<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  Waiting for host to start...
	</div>
      );
    } else if (p.isClient) {
      return (
	<div id="status-bar" className="row">
	  You are client:<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  Waiting for host to start...
	</div>
      );
    } else { //p.isHost
      return (
	<div id="status-bar" className="row">
	  You are host:<br/>
	  {p.host_name} (B) vs. {p.client_name} (W)<br/>
	  <button id="start-button" onClick={p.start_onClick}>Start game</button>
	</div>
      );
    }
  } else { // waiting for client
    if (p.isSpec) {
      if (window.current_user_id == -1) {
	return (
	  <div id="status-bar" className="row">
	    You are spectating:<br/>
	    {p.host_name} (B) vs. [waiting for player] (W)<br/>
	    <a href="/">Log in to join games</a>
	  </div>
	);
      } else {
	  return (
	    <div id="status-bar" className="row">
	      You are spectating:<br/>
	      {p.host_name} (B) vs. [waiting for player] (W)<br/>
	      <button id="start-button" onClick={p.join_onClick}>Join game</button>
	    </div>
	  );
      }
    } else { //p.isHost
      return (
	<div id="status-bar" className="row">
	  You are host:<br/>
	  {p.host_name} (B) vs. [waiting for player] (W)<br/>
	  Waiting for client...
	</div>
      );
    }
  }
}


function Tile(params) {
  var p = params;
  var div_id = "tile-" + p.x + "-" + p.y;
  if (p.state == "white") {
    return (<div id={div_id} className="tile tile-white">w</div>);
  } else if (p.state == "black") {
    return (<div id={div_id} className="tile tile-black">b</div>);
  } else { //p.state = "empty"
    if (p.isMyTurn) {
      return (<div id={div_id} className="tile tile-empty" onClick={params.onClick}/>);
    } else {
      return (<div id={div_id} className="tile tile-empty"/>);
    }
  }
}
