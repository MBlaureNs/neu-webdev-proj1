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
    console.log("dlksahfljashfla");
    return (
      "asdsf"
    );
  }
}
