var React, cx, moment, rangeSize;

React = require('react');

moment = require('moment');

cx = require('classnames');

rangeSize = 12;

module.exports = React.createClass({
  propTypes: {
    allowedRange: React.PropTypes.array,
    date: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func
  },
  getInitialState: function() {
    return {
      year: Math.floor(this.props.date.year() / rangeSize) * rangeSize
    };
  },
  render: function() {
    var nextDisabled, prevDisabled;
    prevDisabled = this.props.allowedRange && this.state.year <= this.props.allowedRange[0].year();
    nextDisabled = this.props.allowedRange && this.state.year + rangeSize >= this.props.allowedRange[1].year();
    return React.createElement("div", {
      "className": "react-date-ranger-year-picker"
    }, React.createElement("div", {
      "className": "react-date-ranger-calendar-toolbar"
    }, React.createElement("button", {
      "disabled": prevDisabled,
      "onClick": this.prevYears
    }, "\x3C"), this.state.year, "-", this.state.year + rangeSize - 1, React.createElement("button", {
      "disabled": nextDisabled,
      "onClick": this.nextYears
    }, "\x3E")), React.createElement("table", {
      "className": "react-date-ranger-calendar"
    }, React.createElement("tbody", null, this.renderDates())));
  },
  nextYears: function() {
    return this.setState({
      year: this.state.year + rangeSize
    });
  },
  prevYears: function() {
    return this.setState({
      year: this.state.year - rangeSize
    });
  },
  renderDates: function() {
    var allowedMax, allowedMin, cells, curr, disabled, end, i, rows;
    curr = moment(this.state.year, 'YYYY').startOf('year');
    end = moment(this.state.year + rangeSize - 1, 'YYYY').endOf('year');
    if (this.props.allowedRange) {
      allowedMin = moment(this.props.allowedRange[0]).subtract(1, 'years');
      allowedMax = moment(this.props.allowedRange[1]).add(1, 'years');
    }
    i = 1;
    cells = [];
    rows = [];
    while (curr.isSameOrBefore(end)) {
      disabled = this.props.allowedRange && !curr.isBetween(allowedMin, allowedMax, 'year');
      cells.push(React.createElement("td", {
        "key": i
      }, React.createElement("button", {
        "className": cx("year", {
          "selected": curr.year() === this.props.date.year()
        }),
        "onClick": this._onYearClick,
        "value": curr.format('YYYY-MM-DD'),
        "disabled": disabled
      }, curr.format('YYYY'))));
      if (i > 0 && i % 3 === 0) {
        rows.push(React.createElement("tr", {
          "key": i / 3
        }, cells));
        cells = [];
      }
      curr.add(1, 'years') && i++;
    }
    return rows;
  },
  _onYearClick: function(e) {
    return this.props.onChange(moment(e.currentTarget.value));
  }
});
