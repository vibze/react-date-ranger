var Calendar, React, cx, moment;

React = require('react');

moment = require('moment');

cx = require('classnames');

Calendar = require('./Calendar.react');

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
      allowedMin = moment(this.props.allowedRange[0]);
      allowedMax = moment(this.props.allowedRange[1]);
    }
    if (this.props.highlightToDate) {
      if (this.props.date.isSameOrBefore(this.props.highlightToDate)) {
        hlStart = moment(this.props.date);
        hlEnd = moment(this.props.highlightToDate).add(1, 'weeks').endOf('isoWeek');
      } else {
        hlStart = moment(this.props.highlightToDate).subtract(1, 'weeks');
        hlEnd = moment(this.props.date);
      }
    }
    return React.createElement(Calendar, {
      "page": moment(this.props.date),
      "prevDisabled": ((function(_this) {
        return function(page) {
          return _this.props.allowedRange && page.isSameOrBefore(allowedMin, 'month');
        };
      })(this)),
      "nextDisabled": ((function(_this) {
        return function(page) {
          return _this.props.allowedRange && page.isSameOrAfter(allowedMax, 'month');
        };
      })(this)),
      "prevPage": (function(page) {
        return page.subtract(1, 'months');
      }),
      "nextPage": (function(page) {
        return page.add(1, 'months');
      }),
      "headerRenderer": (function(page) {
        return page.format('MMM YYYY');
      }),
      "calStartDate": (function(page) {
        return moment(page).startOf('month').startOf('isoWeek');
      }),
      "calEndDate": (function(page) {
        return moment(page).endOf('month').endOf('isoWeek');
      }),
      "calDateIncrement": (function(date) {
        date.add(1, 'days');
        return date;
      }),
      "calCellsInRow": 7.,
      "dateIsDisabled": ((function(_this) {
        return function(date) {
          return _this.props.allowedRange && !date.isBetween(allowedMin, allowedMax, 'day');
        };
      })(this)),
      "dateIsHighlighted": ((function(_this) {
        return function(date) {
          return _this.props.highlightToDate && date.isBetween(hlStart, hlEnd, 'isoWeek');
        };
      })(this)),
      "dateIsSelected": ((function(_this) {
        return function(date) {
          return date.format('YYYYWW') === _this.props.date.format('YYYYWW');
        };
      })(this)),
      "dateIsBlurred": ((function(_this) {
        return function(date, page) {
          return date.format('YYYYMM') !== page.format('YYYYMM');
        };
      })(this)),
      "dateFormat": (function(date) {
        return date.format('DD');
      }),
      "onDateClick": this._onDayClick
    });
  },
  _onDayClick: function(value) {
    return this.props.onChange(moment(value));
  }
});
