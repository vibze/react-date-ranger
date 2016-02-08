var React, cx;

React = require('react');

cx = require('classnames');

module.exports = React.createClass({
  propTypes: {
    page: React.PropTypes.any.isRequired,
    prevDisabled: React.PropTypes.func.isRequired,
    nextDisabled: React.PropTypes.func.isRequired,
    prevPage: React.PropTypes.func.isRequired,
    nextPage: React.PropTypes.func.isRequired,
    headerRenderer: React.PropTypes.func.isRequired,
    calStartDate: React.PropTypes.func.isRequired,
    calEndDate: React.PropTypes.func.isRequired,
    calDateIncrement: React.PropTypes.func.isRequired,
    calCellsInRow: React.PropTypes.number.isRequired,
    dateIsDisabled: React.PropTypes.func.isRequired,
    dateIsHighlighted: React.PropTypes.func.isRequired,
    dateIsSelected: React.PropTypes.func.isRequired,
    dateIsBlurred: React.PropTypes.func,
    dateFormat: React.PropTypes.func.isRequired,
    onDateClick: React.PropTypes.func
  },
  getDefaultProps: function() {
    return {
      page: null,
      dateIsBlurred: function() {
        return false;
      }
    };
  },
  getInitialState: function() {
    return {
      page: this.props.page
    };
  },
  render: function() {
    console.log(this.state.page);
    return React.createElement("div", {
      "className": "react-date-ranger-date-picker"
    }, React.createElement("div", {
      "className": "react-date-ranger-calendar-toolbar"
    }, React.createElement("button", {
      "disabled": this.props.prevDisabled(this.state.page),
      "onClick": this._onPrevPageClick
    }, "❮"), this.props.headerRenderer(this.state.page), React.createElement("button", {
      "disabled": this.props.nextDisabled(this.state.page),
      "onClick": this._onNextPageClick
    }, "❯")), React.createElement("table", {
      "className": "react-date-ranger-calendar"
    }, React.createElement("tbody", null, this.renderDates())));
  },
  renderDates: function() {
    var cells, classString, curr, end, i, rows;
    curr = this.props.calStartDate(this.state.page);
    end = this.props.calEndDate(this.state.page);
    console.log(curr.isSameOrBefore(end));
    i = 1;
    cells = [];
    rows = [];
    while (curr.isSameOrBefore(end)) {
      classString = cx({
        "selected": this.props.dateIsSelected(curr),
        "highlighted": this.props.dateIsHighlighted(curr),
        "blurred": this.props.dateIsBlurred(curr)
      });
      cells.push(React.createElement("td", {
        "key": i
      }, React.createElement("button", {
        "className": classString,
        "onClick": this._onDateClick,
        "value": curr.format('YYYY-MM-DD'),
        "disabled": this.props.dateIsDisabled(curr)
      }, this.props.dateFormat(curr))));
      if (i > 0 && i % this.props.calCellsInRow === 0) {
        rows.push(React.createElement("tr", {
          "key": i / this.props.calCellsInRow
        }, cells));
        cells = [];
      }
      this.props.calDateIncrement(curr) && i++;
    }
    return rows;
  },
  _onPrevPageClick: function() {
    return this.setState({
      page: this.props.prevPage(this.state.page)
    });
  },
  _onNextPageClick: function() {
    return this.setState({
      page: this.props.nextPage(this.state.page)
    });
  },
  _onDateClick: function(e) {
    return this.props.onDateClick(e.currentTarget.value);
  }
});
