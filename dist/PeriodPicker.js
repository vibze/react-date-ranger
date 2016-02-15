var React, cx;

React = require('react');

cx = require('classnames');

module.exports = React.createClass({
  propTypes: {
    allowedPeriods: React.PropTypes.string.isRequired,
    period: React.PropTypes.string.isRequired,
    onChange: React.PropTypes.func
  },
  render: function() {
    return React.createElement("div", {
      "className": "react-date-ranger-period-picker"
    }, this.renderPeriodButtons());
  },
  renderPeriodButtons: function() {
    return this.props.allowedPeriods.split('').map((function(_this) {
      return function(period, i) {
        var classString;
        classString = cx({
          "selected": period === _this.props.period
        });
        return React.createElement("button", {
          "key": i,
          "className": classString,
          "onClick": _this._onPeriodClick,
          "value": period
        }, period);
      };
    })(this));
  },
  _onPeriodClick: function(e) {
    var period;
    period = e.currentTarget.value;
    return this.props.onChange(period);
  }
});
