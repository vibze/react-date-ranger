var PeriodPicker, React, ReactDOM, moment, periods;

React = require('react');

ReactDOM = require('react-dom');

moment = require('moment');

periods = require('./periods');

PeriodPicker = require('./PeriodPicker');

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
      period: null,
      onChange: function(range) {
        return true;
      }
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
      return this.state.range = [moment().startOf(periods[this.state.period].keyword), moment().endOf(periods[this.state.period].keyword)];
    } else {
      return this.state.range = this.state.range.map(function(d) {
        return moment(d);
      });
    }
  },
  componentDidMount: function() {
    return this.props.onChange(this.state.period, this.state.range);
  },
  emitOnChange: function() {
    var ref, updatedRange;
    if ((ref = this.state.period) === "Y" || ref === "Q" || ref === "M") {
      updatedRange = [moment(this.state.range[0]).endOf('isoWeek').startOf(periods[this.state.period].keyword), moment(this.state.range[1]).startOf('isoWeek').endOf(periods[this.state.period].keyword)];
    } else {
      updatedRange = [moment(this.state.range[0]).startOf(periods[this.state.period].keyword), moment(this.state.range[1]).endOf(periods[this.state.period].keyword)];
    }
    return this.props.onChange(this.state.period, updatedRange);
  },
  render: function() {
    var DatePicker, parsedAllowedRange;
    DatePicker = periods[this.state.period].picker;
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
    return date.format(periods[this.props.period].format);
  },
  _onPeriodChange: function(period) {
    this.state.period = period;
    this.emitOnChange();
    return this.forceUpdate();
  },
  _onFromChange: function(newFrom) {
    this.state.range[0] = newFrom.startOf(periods[this.state.period].keyword);
    this.props.onChange(this.state.period, this.state.range);
    return this.forceUpdate();
  },
  _onToChange: function(newTo) {
    this.state.range[1] = newTo.endOf(periods[this.state.period].keyword);
    this.props.onChange(this.state.period, this.state.range);
    return this.forceUpdate();
  }
});
