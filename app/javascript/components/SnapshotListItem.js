import React from "react"
import PropTypes from "prop-types"

export default class SnapshotListItem extends React.Component {

  render () {
    return (
      <div className={`row dataRow ${this.props.altrow ? "alt-row" : ""}`}>
        <div className="coinListName coinListSubValue col-xs-2"><img className="coin-icon" src={this.props.imageurl} />{this.props.coinname} ({this.props.name})</div>
        <div className="coinListValue col-xs-2">
          <div className="row">
            <div className="coinListSubLabel col-xs-6">From: ${this.props.snapshot.fromsymbol}</div>
            <div className="coinListSubLabel col-xs-6">To: ${this.props.snapshot.tosymbol}</div>
          </div>
          <div className="row">
            <div className="coinListSubLabel col-xs-12">Market</div>
            <div className="coinListSubValue col-xs-12">{this.props.snapshot.market}</div>
          </div>
        </div>

      </div>
    );
  }
}
