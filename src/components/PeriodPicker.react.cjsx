React = require('react')
cx = require('classnames')


module.exports = React.createClass(
  propTypes:
    allowedPeriods: React.PropTypes.string.isRequired
    period: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func

  render: ->
    <div className="react-date-ranger-period-picker">
      {@renderPeriodButtons()}
    </div>

  renderPeriodButtons: ->
    @props.allowedPeriods.split('').map((period, i) =>
      classString = cx("selected": period == @props.period)

      <button
        key={i}
        className={classString}
        onClick={@_onPeriodClick}
        value={period}>
        {period}
      </button>
    )

  _onPeriodClick: (e) ->
    period = e.currentTarget.value
    @props.onChange(period)
)
