var DatePickers, PeriodPicker, React, ReactDOM, cx, getDefaultRange, moment;

React = require('react');

ReactDOM = require('react-dom');

moment = require('moment');

cx = require('classnames');

PeriodPicker = require('./PeriodPicker.react');

DatePickers = {
  Y: require('./YearPicker.react'),
  Q: require('./QuarterPicker.react'),
  M: require('./MonthPicker.react'),
  W: require('./WeekPicker.react')
};

getDefaultRange = function() {
  return [moment().startOf('month'), moment().endOf('month')];
};

module.exports = React.createClass({
  propTypes: {
    allowedPeriods: React.PropTypes.string,
    allowedRange: React.PropTypes.array,
    allowedRangeFormat: React.PropTypes.string,
    range: React.PropTypes.array,
    period: React.PropTypes.string
  },
  getDefaultProps: function() {
    return {
      allowedPeriods: "YQMWD",
      allowedRange: null,
      allowedRangeFormat: 'YYYY-MM-DD',
      range: getDefaultRange(),
      period: "M"
    };
  },
  getInitialState: function() {
    return {
      range: this.props.range.slice(0),
      period: this.props.period,
      showPicker: false
    };
  },
  render: function() {
    return React.createElement("div", {
      "className": "react-date-ranger"
    }, React.createElement("div", {
      "className": "react-date-ranger-display",
      "onClick": this.showPicker
    }, React.createElement("div", {
      "className": "segment"
    }, React.createElement("label", null, "Период"), this.renderPeriod(this.props.period)), React.createElement("div", {
      "className": "segment"
    }, React.createElement("label", null, "Диапазон"), this.props.range.map(this.renderDate).join(' - '))), (this.state.showPicker ? this.renderPanel() : void 0));
  },
  renderPanel: function() {
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
      "className": "react-date-ranger-panel"
    }, React.createElement("div", null, React.createElement("label", null, "Период"), React.createElement(PeriodPicker, {
      "period": this.state.period,
      "allowedPeriods": this.props.allowedPeriods,
      "onChange": this._onPeriodChange
    })), React.createElement("div", null, React.createElement("label", null, "Начало"), React.createElement(DatePicker, {
      "allowedRange": parsedAllowedRange,
      "date": this.state.range[0],
      "onChange": this._onFromChange
    })), React.createElement("div", null, React.createElement("label", null, "Конец"), React.createElement(DatePicker, {
      "allowedRange": parsedAllowedRange,
      "date": this.state.range[1],
      "onChange": this._onToChange
    })), React.createElement("br", null), React.createElement("button", {
      "onClick": this._onSubmit
    }, "Применить"), React.createElement("button", {
      "onClick": this._onCancel
    }, "Отмена"));
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
  showPicker: function() {
    return this.setState({
      showPicker: true
    });
  },
  _onPeriodChange: function(newPeriod) {
    return this.setState({
      period: newPeriod
    });
  },
  _onFromChange: function(newFrom) {
    this.state.range[0] = newFrom;
    return this.forceUpdate();
  },
  _onToChange: function(newTo) {
    this.state.range[1] = newTo;
    return this.forceUpdate();
  },
  _onSubmit: function(e) {
    this.setState({
      showPicker: false
    });
    console.log(this.state.period);
    return console.log(this.state.range);
  },
  _onCancel: function(e) {
    this.setState({
      showPicker: false
    });
    return this.setState({
      period: this.props.period,
      range: this.props.range.slice(0)
    });
  }
});
