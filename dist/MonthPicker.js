var Calendar, React, cx, moment;

React = require('react');

moment = require('moment');

cx = require('classnames');

Calendar = require('./Calendar');

module.exports = React.createClass({
  propTypes: {
    allowedRange: React.PropTypes.array,
    date: React.PropTypes.object.isRequired,
    highlightToDate: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func
  },
  render: function() {
    var allowedMax, allowedMin, hlEnd, hlStart;
    if (this.props.allowedRange) {
      allowedMin = moment(this.props.allowedRange[0]).subtract(1, 'months');
      allowedMax = moment(this.props.allowedRange[1]).add(1, 'months');
    }
    if (this.props.highlightToDate) {
      if (this.props.date.isSameOrBefore(this.props.highlightToDate)) {
        hlStart = this.props.date;
        hlEnd = moment(this.props.highlightToDate).add(1, 'months');
      } else {
        hlStart = moment(this.props.highlightToDate).subtract(1, 'months');
        hlEnd = this.props.date;
      }
    }
    return React.createElement(Calendar, {
      "page": this.props.date.year(),
      "prevDisabled": ((function(_this) {
        return function(page) {
          return _this.props.allowedRange && page <= _this.props.allowedRange[0].year();
        };
      })(this)),
      "nextDisabled": ((function(_this) {
        return function(page) {
          return _this.props.allowedRange && page >= _this.props.allowedRange[1].year();
        };
      })(this)),
      "prevPage": (function(page) {
        return page - 1;
      }),
      "nextPage": (function(page) {
        return page + 1;
      }),
      "headerRenderer": (function(page) {
        return page;
      }),
      "calStartDate": (function(page) {
        return moment(page, 'YYYY').startOf('year');
      }),
      "calEndDate": (function(page) {
        return moment(page, 'YYYY').endOf('year');
      }),
      "calDateIncrement": (function(date) {
        return date.add(1, 'months');
      }),
      "calCellsInRow": 3.,
      "dateIsDisabled": ((function(_this) {
        return function(date) {
          return _this.props.allowedRange && !date.isBetween(allowedMin, allowedMax, 'month');
        };
      })(this)),
      "dateIsHighlighted": ((function(_this) {
        return function(date) {
          return _this.props.highlightToDate && date.isBetween(hlStart, hlEnd, 'month');
        };
      })(this)),
      "dateIsSelected": ((function(_this) {
        return function(date) {
          return date.format('YYYYMM') === _this.props.date.format('YYYYMM');
        };
      })(this)),
      "dateFormat": (function(date) {
        return date.format('MMM');
      }),
      "onDateClick": this._onMonthClick
    });
  },
  _onMonthClick: function(value) {
    return this.props.onChange(moment(value));
  }
});
