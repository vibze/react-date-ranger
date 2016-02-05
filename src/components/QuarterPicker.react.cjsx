React = require('react')
moment = require('moment')
cx = require('classnames')

rangeSize = 4

module.exports = React.createClass(
  propTypes:
    allowedRange: React.PropTypes.array  # Moment.js objects
    date: React.PropTypes.object.isRequired  # Moment.js object
    onChange: React.PropTypes.func

  getInitialState: ->
    year: Math.floor(@props.date.year()/rangeSize)*rangeSize

  render: ->
    prevDisabled = @props.allowedRange and @state.year <= @props.allowedRange[0].year()
    nextDisabled = @props.allowedRange and @state.year+rangeSize >= @props.allowedRange[1].year()

    <div className="react-date-ranger-quarter-picker">
      <div className="react-date-ranger-calendar-toolbar">
        <button disabled={prevDisabled} onClick={@prevYears}>&lt;</button>
        {@state.year}-{@state.year+rangeSize-1}
        <button disabled={nextDisabled} onClick={@nextYears}>&gt;</button>
      </div>
      <table className="react-date-ranger-calendar">
        <tbody>
          {@renderDates()}
        </tbody>
      </table>
    </div>

  nextYears: ->
    @setState(year: @state.year+rangeSize)

  prevYears: ->
    @setState(year: @state.year-rangeSize)

  renderDates: ->
    curr = moment(@state.year, 'YYYY').startOf('year')
    end = moment(@state.year+rangeSize-1, 'YYYY').endOf('year')

    # Because moment.js isBetween method is exclusive
    if @props.allowedRange
      allowedMin = moment(@props.allowedRange[0]).subtract(1, 'quarters')
      allowedMax = moment(@props.allowedRange[1]).add(1, 'quarters')

    i = 1
    cells = []
    rows = []
    while curr.isSameOrBefore(end)
      disabled = @props.allowedRange and not curr.isBetween(allowedMin, allowedMax, 'quarter')

      cells.push(
        <td key={i}>
          <button
            className={cx("quarter", "selected": curr.format('YYYYQ') == @props.date.format('YYYYQ'))}
            onClick={@_onYearClick}
            value={curr.format('YYYY-MM-DD')}
            disabled={disabled}>
            {curr.format('YYYY-[Q]Q')}
          </button>
        </td>
      )

      if i > 0 and i%4 == 0
        rows.push(<tr key={i/4}>{cells}</tr>)
        cells = []

      curr.add(1, 'quarters') and i++
    rows

  _onYearClick: (e) ->
    @props.onChange(moment(e.currentTarget.value))
)
