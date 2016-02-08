React = require('react')
ReactDOM = require('react-dom')
moment = require('moment')
cx = require('classnames')
PeriodPicker = require('./PeriodPicker.react')
DatePickers =
  Y: require('./YearPicker.react')
  Q: require('./QuarterPicker.react')
  M: require('./MonthPicker.react')
  W: require('./WeekPicker.react')
  D: require('./DayPicker.react')


getDefaultRange = ->
  [moment().startOf('month'), moment().endOf('month')]


momentQueryKeywords =
  Y: 'year'
  Q: 'quarter'
  M: 'month'
  W: 'isoWeek'
  D: 'day'

module.exports = React.createClass(
  propTypes:
    allowedPeriods: React.PropTypes.string
    allowedRange: React.PropTypes.array
    allowedRangeFormat: React.PropTypes.string
    range: React.PropTypes.array
    period: React.PropTypes.string
    onChange: React.PropTypes.func

  getDefaultProps: ->
    allowedPeriods: "YQMWD"
    allowedRange: null
    allowedRangeFormat: 'YYYY-MM-DD'
    range: null
    period: null

  getInitialState: ->
    range: @props.range
    period: @props.period

  componentWillMount: ->
    if @state.period is null
      @state.period = @props.allowedPeriods[0]

    if @state.range is null
      @state.range = [
        moment().startOf(momentQueryKeywords[@state.period]),
        moment().endOf(momentQueryKeywords[@state.period])
      ]

  componentDidMount: ->
    @props.onChange(@state.range)

  render: ->
    DatePicker = DatePickers[@state.period]

    if @props.allowedRange
      parsedAllowedRange = @props.allowedRange.map((dateString) => moment(dateString, @props.allowedRangeFormat))
    else
      null

    <div className="react-date-ranger">
      <PeriodPicker period={@state.period} allowedPeriods={@props.allowedPeriods} onChange={@_onPeriodChange} />
      <div>
      <DatePicker
        allowedRange={parsedAllowedRange}
        date={@state.range[0]}
        highlightToDate={@state.range[1]}
        onChange={@_onFromChange} />
      <DatePicker
        allowedRange={parsedAllowedRange}
        date={@state.range[1]}
        highlightToDate={@state.range[0]}
        onChange={@_onToChange} />
      </div>
    </div>

  renderDate: (date) ->
    dict =
      Y: 'YYYY'
      Q: 'YYYY-[Q]Q'
      M: 'YYYY-MM'
      W: 'YYYY-[W]WW'
      D: 'YYYY-MM-DD'
    date.format(dict[@props.period])

  renderPeriod: (period) ->
    dict =
      Y: "Год"
      Q: "Квартал"
      M: "Месяц"
      W: "Неделя"
      D: "День"
    dict[period]

  _onPeriodChange: (newPeriod) ->
    if newPeriod in ["Y", "Q", "M"]
      updatedRange = [
        @state.range[0].endOf('isoWeek').startOf(momentQueryKeywords[newPeriod]),
        @state.range[1].startOf('isoWeek').endOf(momentQueryKeywords[newPeriod])
      ]
    else
      updatedRange = [
        @state.range[0].startOf(momentQueryKeywords[newPeriod]),
        @state.range[1].endOf(momentQueryKeywords[newPeriod])
      ]

    @setState(
      period: newPeriod
      range: updatedRange
    )

  _onFromChange: (newFrom) ->
    @state.range[0] = newFrom.startOf(momentQueryKeywords[@state.period])
    @props.onChange(@state.range)
    @forceUpdate()

  _onToChange: (newTo) ->
    @state.range[1] = newTo.endOf(momentQueryKeywords[@state.period])
    @props.onChange(@state.range)
    @forceUpdate()
)
