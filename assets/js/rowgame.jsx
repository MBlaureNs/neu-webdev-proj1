import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_rowgame(root, channel) {
  ReactDOM.render(<Rowgame channel = {channel} />, root);
}

class Rowgame extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };

    this.channel = props.channel;
    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp) });
    this.channel.on('update', this.gotView.bind(this));
  }

  gotView(view) {
    this.setState(view.game);
  }

  render() {
    return (
      asdasf
    );
  }
}
