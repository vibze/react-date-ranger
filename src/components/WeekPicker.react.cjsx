React = require('react')
moment = require('moment')
cx = require('classnames')


module.exports = React.createClass(
  propTypes:
    allowedRange: React.PropTypes.array  # Moment.js objects
    date: React.PropTypes.object.isRequired  # Moment.js object
    onChange: React.PropTypes.func

  getInitialState: ->
    month: moment(@props.date)

  render: ->
    prevDisabled = @props.allowedRange and @state.month.isSameOrBefore(@props.allowedRange[0])
    nextDisabled = @props.allowedRange and @state.month.isSameOrAfter(@props.allowedRange[1])

    <div className="react-date-ranger-week-picker">
      <div className="react-date-ranger-calendar-toolbar">
        <button disabled={prevDisabled} onClick={@prevMonth}>&lt;</button>
        {@state.month.format('MMM YYYY')}
        <button disabled={nextDisabled} onClick={@nextMonth}>&gt;</button>
      </div>
      <table className="react-date-ranger-calendar">
        <tbody>
          {@renderDates()}
        </tbody>
      </table>
    </div>

  nextMonth: ->
    @setState(month: @state.month.add(1, 'months'))

  prevMonth: ->
    @setState(month: @state.month.subtract(1, 'months'))

  renderDates: ->
    console.log @props.date.format('YYYYWW')
    curr = moment(@state.month).startOf('month').startOf('isoWeek')
    end = moment(@state.month).endOf('month').endOf('isoWeek')

    # Because moment.js isBetween method is exclusive
    if @props.allowedRange
      allowedMin = moment(@props.allowedRange[0]).subtract(1, 'days')
      allowedMax = moment(@props.allowedRange[1]).add(1, 'days')

    i = 1
    cells = []
    rows = []
    while curr.isSameOrBefore(end)
      disabled = @props.allowedRange and not curr.isBetween(allowedMin, allowedMax, 'day')
      blurred = curr.format('YYYYMM') != @state.month.format('YYYYMM')
      selected = curr.format('YYYYWW') == @props.date.format('YYYYWW')

      cells.push(
        <td key={i}>
          <button
            className={cx("day", "selected": selected, "blurred": blurred)}
            onClick={@_onDayClick}
            value={moment(curr).startOf('isoWeek').format('YYYY-MM-DD')}
            disabled={disabled}>
            {curr.format('D')}
          </button>
        </td>
      )

      if i > 0 and i%7 == 0
        rows.push(<tr key={i/7}>{cells}</tr>)
        cells = []

      curr.add(1, 'days') and i++
    rows

  _onDayClick: (e) ->
    @props.onChange(moment(e.currentTarget.value))
)
