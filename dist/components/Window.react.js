var React, ReactDOM, cx;

React = require('react');

ReactDOM = require('react-dom');

cx = require('classnames');

module.exports = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    title: React.PropTypes.string,
    onMouseDown: React.PropTypes.func
  },
  getDefaultProps: function() {
    return {
      title: false,
      initialPos: {
        x: 0,
        y: 0
      },
      onMouseDown: null
    };
  },
  getInitialState: function() {
    return {
      pos: this.props.initialPos,
      dragging: false,
      rel: null,
      active: false
    };
  },
  setActive: function(active) {
    return this.setState({
      active: active
    });
  },
  componentDidUpdate: function(props, state) {
    if (this.state.dragging && !state.dragging) {
      document.addEventListener('mousemove', this._onMouseMove);
      return document.addEventListener('mouseup', this._onMouseUp);
    } else if (!this.state.dragging && state.dragging) {
      document.removeEventListener('mousemove', this._onMouseMove);
      return document.removeEventListener('mouseup', this._onMouseUp);
    }
  },
  render: function() {
    var classString, style;
    classString = {
      "rw-window": "rw-window",
      "active": this.state.active
    };
    style = {
      position: 'absolute',
      left: this.state.pos.x,
      top: this.state.pos.y
    };
    return React.createElement("div", {
      "className": "rw-window",
      "style": style,
      "onMouseDown": this._onMouseDown
    }, React.createElement("div", {
      "className": "rw-window-navbar",
      "onMouseDown": this._onNavbarMouseDown
    }, this.props.title), React.createElement("div", {
      "className": "rw-window-content"
    }, this.props.children));
  },
  _onNavbarMouseDown: function(e) {
    var pos, rect;
    if (e.button !== 0) {
      return null;
    }
    rect = ReactDOM.findDOMNode(this).getBoundingClientRect();
    pos = {
      x: rect.left,
      y: rect.top
    };
    this.setState({
      dragging: true,
      rel: {
        x: e.pageX - pos.x,
        y: e.pageY - pos.y
      }
    });
    if (this.props.onMouseDown) {
      this.props.onMouseDown(this.props.id);
    }
    e.stopPropagation();
    return e.preventDefault();
  },
  _onMouseDown: function(e) {
    if (this.props.onMouseDown) {
      return this.props.onMouseDown(this.props.id);
    }
  },
  _onMouseUp: function(e) {
    this.setState({
      dragging: false
    });
    e.stopPropagation();
    return e.preventDefault();
  },
  _onMouseMove: function(e) {
    if (!this.state.dragging) {
      return null;
    }
    this.setState({
      pos: {
        x: e.pageX - this.state.rel.x,
        y: e.pageY - this.state.rel.y
      }
    });
    e.stopPropagation();
    return e.preventDefault();
  }
});
