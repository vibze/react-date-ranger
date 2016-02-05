var React, ReactDOM, TimeseriesChart;

React = require('react');

ReactDOM = require('react-dom');

TimeseriesChart = require('../charts/timeseries');

module.exports = React.createClass({
  propTypes: {
    data: React.PropTypes.array.isRequired
  },
  getDefaultProps: function() {
    return {
      width: 400,
      height: 300,
      margin: {
        top: 0,
        left: 0,
        right: 0,
        bottom: 30
      },
      xaxis: {
        orientation: 'bottom'
      },
      yaxis: {
        orientation: 'left'
      }
    };
  },
  componentDidMount: function() {
    return this._chart = new TimeseriesChart(ReactDOM.findDOMNode(this), this.props.data, this.props);
  },
  componentDidUpdate: function() {
    return this._chart.update(this.props.data, this.props);
  },
  componentWillUnmount: function() {},
  render: function() {
    return React.createElement("div", {
      "className": "origami-chart origami-timeseries-chart"
    });
  }
});
