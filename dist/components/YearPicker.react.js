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
    var allowedMax, allowedMin, hlEnd, hlStart, r;
    r = 12;
    if (this.props.allowedRange) {
      allowedMin = moment(this.props.allowedRange[0]).subtract(1, 'years');
      allowedMax = moment(this.props.allowedRange[1]).add(1, 'years');
    }
    if (this.props.highlightToDate) {
      if (this.props.date.isSameOrBefore(this.props.highlightToDate)) {
        hlStart = this.props.date;
        hlEnd = moment(this.props.highlightToDate).add(1, 'years');
      } else {
        hlStart = moment(this.props.highlightToDate).subtract(1, 'years');
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
          return _this.props.allowedRange && page + r >= _this.props.allowedRange[1].year();
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
        return moment(page, 'YYYY').startOf('year');
      }),
      "calEndDate": (function(page) {
        return moment(page + r - 1, 'YYYY').endOf('year');
      }),
      "calDateIncrement": (function(date) {
        return date.add(1, 'years');
      }),
      "calCellsInRow": 3.,
      "dateIsDisabled": ((function(_this) {
        return function(date) {
          return _this.props.allowedRange && !date.isBetween(allowedMin, allowedMax, 'year');
        };
      })(this)),
      "dateIsHighlighted": ((function(_this) {
        return function(date) {
          return _this.props.highlightToDate && date.isBetween(hlStart, hlEnd, 'year');
        };
      })(this)),
      "dateIsSelected": ((function(_this) {
        return function(date) {
          return date.format('YYYY') === _this.props.date.format('YYYY');
        };
      })(this)),
      "dateFormat": (function(date) {
        return date.format('YYYY');
      }),
      "onDateClick": this._onQuarterClick
    });
  },
  _onQuarterClick: function(value) {
    return this.props.onChange(moment(value));
  }
});
