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
    var allowedMax, allowedMin, hlEnd, hlStart, r;
    r = 4;
    if (this.props.allowedRange) {
      allowedMin = moment(this.props.allowedRange[0]).subtract(1, 'quarters');
      allowedMax = moment(this.props.allowedRange[1]).add(1, 'quarters');
    }
    if (this.props.highlightToDate) {
      if (this.props.date.isSameOrBefore(this.props.highlightToDate)) {
        hlStart = this.props.date;
        hlEnd = moment(this.props.highlightToDate).add(1, 'quarters');
      } else {
        hlStart = moment(this.props.highlightToDate).subtract(1, 'quarters');
        hlEnd = this.props.date;
      }
    }
    return React.createElement(Calendar, {
      "page": Math.floor(this.props.date.year() / r) * r,
      "prevDisabled": ((function(_this) {
        return function(page) {
          return _this.props.allowedRange && page <= _this.props.allowedRange[0].year();
        };
      })(this)),
      "nextDisabled": ((function(_this) {
        return function(page) {
          return _this.props.allowedRange && page + r > _this.props.allowedRange[1].year();
        };
      })(this)),
      "prevPage": (function(page) {
        return page - r;
      }),
      "nextPage": (function(page) {
        return page + r;
      }),
      "headerRenderer": (function(page) {
        return page + " - " + (page + r - 1);
      }),
      "calStartDate": (function(page) {
        return moment(r * Math.floor(page / r), 'YYYY');
      }),
      "calEndDate": (function(page) {
        return moment(r * Math.floor(page / r) + r - 1, 'YYYY').quarter(4);
      }),
      "calDateIncrement": (function(date) {
        return date.add(1, 'quarters');
      }),
      "calCellsInRow": 4.,
      "dateIsDisabled": ((function(_this) {
        return function(date) {
          return _this.props.allowedRange && !date.isBetween(allowedMin, allowedMax, 'quarter');
        };
      })(this)),
      "dateIsHighlighted": ((function(_this) {
        return function(date) {
          return _this.props.highlightToDate && date.isBetween(hlStart, hlEnd, 'quarter');
        };
      })(this)),
      "dateIsSelected": ((function(_this) {
        return function(date) {
          return date.format('YYYYQ') === _this.props.date.format('YYYYQ');
        };
      })(this)),
      "dateFormat": (function(date) {
        return date.format('YYYY-[Q]Q');
      }),
      "onDateClick": this._onQuarterClick
    });
  },
  _onQuarterClick: function(value) {
    return this.props.onChange(moment(value));
  }
});
