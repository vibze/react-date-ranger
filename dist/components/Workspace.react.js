var React, Window, _;

React = require('react');

Window = require('./Window.react');

_ = require('underscore');

module.exports = React.createClass({
  getInitialState: function() {
    return {
      counter: 1,
      windows: []
    };
  },
  createWindow: function(props) {
    var id;
    id = this.state.counter++;
    this.state.windows.push({
      id: id,
      element: React.createElement(Window, React.__spread({
        "id": id,
        "key": id
      }, props, {
        "onMouseDown": this._onWindowMouseDown
      }))
    });
    return this.forceUpdate();
  },
  render: function() {
    return React.createElement("div", {
      "className": "rw-workspace"
    }, this.renderWindows());
  },
  renderWindows: function() {
    return this.state.windows.map(function(w, i) {
      w.element.ref = "w_" + i;
      console.log(w.element);
      return w.element;
    });
  },
  _onWindowMouseDown: function(id) {
    var index;
    index = _.findIndex(this.state.windows, function(w) {
      return w.id === id;
    });
    this.state.windows.splice(this.state.windows.length - 1, 0, this.state.windows.splice(index, 1)[0]);
    console.log(this.refs);
    return this.forceUpdate();
  }
});
