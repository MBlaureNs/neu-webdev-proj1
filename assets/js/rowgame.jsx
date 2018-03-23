import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root, channel) { 
  ReactDOM.render(<Demo channel = {channel}/>, root);
}

class Demo extends React.Component {
  constructor(props) {
		super(props);
		this.channel = props.channel;

                this.channel.join()
                  .receive("ok", this.gotView.bind(this))
                  .receive("error", resp => {console.log("Unable to join", resp)});
  }

  gotView(view) {
    this.setState(view.game);
  }

  render() {
    var board = [];
    for (var i = 0; i < board_size; i++) {
      var row = [];
      for (var j = 0; j < board_size; j++) {
	row.push(<Tile x={j} y={i}/>)
      }
      var x = (<div className="row">{row}</div>);
      board.push(x);
    }
    return board;
  }

}

function Tile(params) {
  var div_id = "tile-" + params.x + "-" + params.y; 
  return (<button id={div_id} className="tile"/>);
}
