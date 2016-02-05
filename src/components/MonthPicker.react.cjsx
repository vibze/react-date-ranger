React = require('react')
moment = require('moment')
cx = require('classnames')


module.exports = React.createClass(
  propTypes:
    allowedRange: React.PropTypes.array  # Moment.js objects
    date: React.PropTypes.object.isRequired  # Moment.js object
    onChange: React.PropTypes.func

  getInitialState: ->
    year: @props.date.year()

  render: ->
    prevDisabled = @props.allowedRange and @state.year <= @props.allowedRange[0].year()
    nextDisabled = @props.allowedRange and @state.year >= @props.allowedRange[1].year()

    <div className="react-date-ranger-month-picker">
      <div className="react-date-ranger-calendar-toolbar">
        <button disabled={prevDisabled} onClick={@prevYear}>&lt;</button>
        {@state.year}
        <button disabled={nextDisabled} onClick={@nextYear}>&gt;</button>
      </div>
      <table className="react-date-ranger-calendar">
        <tbody>
          {@renderDates()}
        </tbody>
      </table>
    </div>

  nextYear: ->
    @setState(year: @state.year+1)

  prevYear: ->
    @setState(year: @state.year-1)

  renderDates: ->
    curr = moment(@state.year, 'YYYY').startOf('year')
    end = moment(@state.year, 'YYYY').endOf('year')

    # Because moment.js isBetween method is exclusive
    if @props.allowedRange
      allowedMin = moment(@props.allowedRange[0]).subtract(1, 'months')
      allowedMax = moment(@props.allowedRange[1]).add(1, 'months')

    i = 1
    cells = []
    rows = []
    while curr.isSameOrBefore(end)
      disabled = @props.allowedRange and not curr.isBetween(allowedMin, allowedMax, 'month')

      cells.push(
        <td key={i}>
          <button
            className={cx("month", "selected": curr.format('YYYYMM') == @props.date.format('YYYYMM'))}
            onClick={@_onMonthClick}
            value={curr.format('YYYY-MM-DD')}
            disabled={disabled}>
            {curr.format('MMM')}
          </button>
        </td>
      )

      if i > 0 and i%3 == 0
        rows.push(<tr key={i/3}>{cells}</tr>)
        cells = []

      curr.add(1, 'months') and i++
    rows

  _onMonthClick: (e) ->
    @props.onChange(moment(e.currentTarget.value))
)
