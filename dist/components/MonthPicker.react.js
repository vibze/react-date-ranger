var React, cx, moment;

React = require('react');

moment = require('moment');

cx = require('classnames');

module.exports = React.createClass({
  propTypes: {
    allowedRange: React.PropTypes.array,
    date: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func
  },
  getInitialState: function() {
    return {
      year: this.props.date.year()
    };
  },
  render: function() {
    var nextDisabled, prevDisabled;
    prevDisabled = this.props.allowedRange && this.state.year <= this.props.allowedRange[0].year();
    nextDisabled = this.props.allowedRange && this.state.year >= this.props.allowedRange[1].year();
    return React.createElement("div", {
      "className": "react-date-ranger-month-picker"
    }, React.createElement("div", {
      "className": "react-date-ranger-calendar-toolbar"
    }, React.createElement("button", {
      "disabled": prevDisabled,
      "onClick": this.prevYear
    }, "\x3C"), this.state.year, React.createElement("button", {
      "disabled": nextDisabled,
      "onClick": this.nextYear
    }, "\x3E")), React.createElement("table", {
      "className": "react-date-ranger-calendar"
    }, React.createElement("tbody", null, this.renderDates())));
  },
  nextYear: function() {
    return this.setState({
      year: this.state.year + 1
    });
  },
  prevYear: function() {
    return this.setState({
      year: this.state.year - 1
    });
  },
  renderDates: function() {
    var allowedMax, allowedMin, cells, curr, disabled, end, i, rows;
    curr = moment(this.state.year, 'YYYY').startOf('year');
    end = moment(this.state.year, 'YYYY').endOf('year');
    if (this.props.allowedRange) {
      allowedMin = moment(this.props.allowedRange[0]).subtract(1, 'months');
      allowedMax = moment(this.props.allowedRange[1]).add(1, 'months');
    }
    i = 1;
    cells = [];
    rows = [];
    while (curr.isSameOrBefore(end)) {
      disabled = this.props.allowedRange && !curr.isBetween(allowedMin, allowedMax, 'month');
      cells.push(React.createElement("td", {
        "key": i
      }, React.createElement("button", {
        "className": cx("month", {
          "selected": curr.format('YYYYMM') === this.props.date.format('YYYYMM')
        }),
        "onClick": this._onMonthClick,
        "value": curr.format('YYYY-MM-DD'),
        "disabled": disabled
      }, curr.format('MMM'))));
      if (i > 0 && i % 3 === 0) {
        rows.push(React.createElement("tr", {
          "key": i / 3
        }, cells));
        cells = [];
      }
      curr.add(1, 'months') && i++;
    }
    return rows;
  },
  _onMonthClick: function(e) {
    return this.props.onChange(moment(e.currentTarget.value));
  }
});
