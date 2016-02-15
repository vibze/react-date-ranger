React = require('react')
ReactDOM = require('react-dom')
moment = require('moment')
periods = require('./periods')
PeriodPicker = require('./PeriodPicker')


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
    onChange: (range) -> true

  getInitialState: ->
    range: @props.range
    period: @props.period

  componentWillMount: ->
    if @state.period is null
      @state.period = @props.allowedPeriods[0]

    if @state.range is null
      @state.range = [
        moment().startOf(periods[@state.period].keyword),
        moment().endOf(periods[@state.period].keyword)
      ]
    else
      # Clone moment() objects just in case
      @state.range = @state.range.map((d) -> moment(d))

  componentDidMount: ->
    @props.onChange(@state.period, @state.range)

  emitOnChange: ->
    if @state.period in ["Y", "Q", "M"]
      updatedRange = [
        moment(@state.range[0]).endOf('isoWeek').startOf(periods[@state.period].keyword),
        moment(@state.range[1]).startOf('isoWeek').endOf(periods[@state.period].keyword)
      ]
    else
      updatedRange = [
        moment(@state.range[0]).startOf(periods[@state.period].keyword),
        moment(@state.range[1]).endOf(periods[@state.period].keyword)
      ]

    @props.onChange(@state.period, updatedRange)

  render: ->
    DatePicker = periods[@state.period].picker

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
    date.format(periods[@props.period].format)

  _onPeriodChange: (period) ->
    @state.period = period
    @emitOnChange()
    @forceUpdate()

  _onFromChange: (newFrom) ->
    @state.range[0] = newFrom.startOf(periods[@state.period].keyword)
    @props.onChange(@state.period, @state.range)
    @forceUpdate()

  _onToChange: (newTo) ->
    @state.range[1] = newTo.endOf(periods[@state.period].keyword)
    @props.onChange(@state.period, @state.range)
    @forceUpdate()
)
