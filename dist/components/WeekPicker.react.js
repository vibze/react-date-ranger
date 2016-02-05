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
      month: moment(this.props.date)
    };
  },
  render: function() {
    var nextDisabled, prevDisabled;
    prevDisabled = this.props.allowedRange && this.state.month.isSameOrBefore(this.props.allowedRange[0]);
    nextDisabled = this.props.allowedRange && this.state.month.isSameOrAfter(this.props.allowedRange[1]);
    return React.createElement("div", {
      "className": "react-date-ranger-week-picker"
    }, React.createElement("div", {
      "className": "react-date-ranger-calendar-toolbar"
    }, React.createElement("button", {
      "disabled": prevDisabled,
      "onClick": this.prevMonth
    }, "\x3C"), this.state.month.format('MMM YYYY'), React.createElement("button", {
      "disabled": nextDisabled,
      "onClick": this.nextMonth
    }, "\x3E")), React.createElement("table", {
      "className": "react-date-ranger-calendar"
    }, React.createElement("tbody", null, this.renderDates())));
  },
  nextMonth: function() {
    return this.setState({
      month: this.state.month.add(1, 'months')
    });
  },
  prevMonth: function() {
    return this.setState({
      month: this.state.month.subtract(1, 'months')
    });
  },
  renderDates: function() {
    var allowedMax, allowedMin, blurred, cells, curr, disabled, end, i, rows, selected;
    console.log(this.props.date.format('YYYYWW'));
    curr = moment(this.state.month).startOf('month').startOf('isoWeek');
    end = moment(this.state.month).endOf('month').endOf('isoWeek');
    if (this.props.allowedRange) {
      allowedMin = moment(this.props.allowedRange[0]).subtract(1, 'days');
      allowedMax = moment(this.props.allowedRange[1]).add(1, 'days');
    }
    i = 1;
    cells = [];
    rows = [];
    while (curr.isSameOrBefore(end)) {
      disabled = this.props.allowedRange && !curr.isBetween(allowedMin, allowedMax, 'day');
      blurred = curr.format('YYYYMM') !== this.state.month.format('YYYYMM');
      selected = curr.format('YYYYWW') === this.props.date.format('YYYYWW');
      cells.push(React.createElement("td", {
        "key": i
      }, React.createElement("button", {
        "className": cx("day", {
          "selected": selected,
          "blurred": blurred
        }),
        "onClick": this._onDayClick,
        "value": moment(curr).startOf('isoWeek').format('YYYY-MM-DD'),
        "disabled": disabled
      }, curr.format('D'))));
      if (i > 0 && i % 7 === 0) {
        rows.push(React.createElement("tr", {
          "key": i / 7
        }, cells));
        cells = [];
      }
      curr.add(1, 'days') && i++;
    }
    return rows;
  },
  _onDayClick: function(e) {
    return this.props.onChange(moment(e.currentTarget.value));
  }
});
