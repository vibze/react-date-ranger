var DatePickers, PeriodPicker, React, ReactDOM, cx, getDefaultRange, moment, momentQueryKeywords;

React = require('react');

ReactDOM = require('react-dom');

moment = require('moment');

cx = require('classnames');

PeriodPicker = require('./PeriodPicker.react');

DatePickers = {
  Y: require('./YearPicker.react'),
  Q: require('./QuarterPicker.react'),
  M: require('./MonthPicker.react'),
  W: require('./WeekPicker.react'),
  D: require('./DayPicker.react')
};

getDefaultRange = function() {
  return [moment().startOf('month'), moment().endOf('month')];
};

momentQueryKeywords = {
  Y: 'year',
  Q: 'quarter',
  M: 'month',
  W: 'isoWeek',
  D: 'day'
};

module.exports = React.createClass({
  propTypes: {
    allowedPeriods: React.PropTypes.string,
    allowedRange: React.PropTypes.array,
    allowedRangeFormat: React.PropTypes.string,
    range: React.PropTypes.array,
    period: React.PropTypes.string,
    onChange: React.PropTypes.func
  },
  getDefaultProps: function() {
    return {
      allowedPeriods: "YQMWD",
      allowedRange: null,
      allowedRangeFormat: 'YYYY-MM-DD',
      range: null,
      period: null
    };
  },
  getInitialState: function() {
    return {
      range: this.props.range,
      period: this.props.period
    };
  },
  componentWillMount: function() {
    if (this.state.period === null) {
      this.state.period = this.props.allowedPeriods[0];
    }
    if (this.state.range === null) {
      return this.state.range = [moment().startOf(momentQueryKeywords[this.state.period]), moment().endOf(momentQueryKeywords[this.state.period])];
    }
  },
  componentDidMount: function() {
    return this.props.onChange(this.state.range);
  },
  render: function() {
    var DatePicker, parsedAllowedRange;
    DatePicker = DatePickers[this.state.period];
    if (this.props.allowedRange) {
      parsedAllowedRange = this.props.allowedRange.map((function(_this) {
        return function(dateString) {
          return moment(dateString, _this.props.allowedRangeFormat);
        };
      })(this));
    } else {
      null;
    }
    return React.createElement("div", {
      "className": "react-date-ranger"
    }, React.createElement(PeriodPicker, {
      "period": this.state.period,
      "allowedPeriods": this.props.allowedPeriods,
      "onChange": this._onPeriodChange
    }), React.createElement("div", null, React.createElement(DatePicker, {
      "allowedRange": parsedAllowedRange,
      "date": this.state.range[0],
      "highlightToDate": this.state.range[1],
      "onChange": this._onFromChange
    }), React.createElement(DatePicker, {
      "allowedRange": parsedAllowedRange,
      "date": this.state.range[1],
      "highlightToDate": this.state.range[0],
      "onChange": this._onToChange
    })));
  },
  renderDate: function(date) {
    var dict;
    dict = {
      Y: 'YYYY',
      Q: 'YYYY-[Q]Q',
      M: 'YYYY-MM',
      W: 'YYYY-[W]WW',
      D: 'YYYY-MM-DD'
    };
    return date.format(dict[this.props.period]);
  },
  renderPeriod: function(period) {
    var dict;
    dict = {
      Y: "Год",
      Q: "Квартал",
      M: "Месяц",
      W: "Неделя",
      D: "День"
    };
    return dict[period];
  },
  _onPeriodChange: function(newPeriod) {
    var updatedRange;
    if (newPeriod === "Y" || newPeriod === "Q" || newPeriod === "M") {
      updatedRange = [this.state.range[0].endOf('isoWeek').startOf(momentQueryKeywords[newPeriod]), this.state.range[1].startOf('isoWeek').endOf(momentQueryKeywords[newPeriod])];
    } else {
      updatedRange = [this.state.range[0].startOf(momentQueryKeywords[newPeriod]), this.state.range[1].endOf(momentQueryKeywords[newPeriod])];
    }
    return this.setState({
      period: newPeriod,
      range: updatedRange
    });
  },
  _onFromChange: function(newFrom) {
    this.state.range[0] = newFrom.startOf(momentQueryKeywords[this.state.period]);
    this.props.onChange(this.state.range);
    return this.forceUpdate();
  },
  _onToChange: function(newTo) {
    this.state.range[1] = newTo.endOf(momentQueryKeywords[this.state.period]);
    this.props.onChange(this.state.range);
    return this.forceUpdate();
  }
});
