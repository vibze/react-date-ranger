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


getDefaultRange = ->
  [moment().startOf('month'), moment().endOf('month')]

module.exports = React.createClass(
  propTypes:
    allowedPeriods: React.PropTypes.string
    allowedRange: React.PropTypes.array
    allowedRangeFormat: React.PropTypes.string
    range: React.PropTypes.array
    period: React.PropTypes.string

  getDefaultProps: ->
    allowedPeriods: "YQMWD"
    allowedRange: null
    allowedRangeFormat: 'YYYY-MM-DD'
    range: getDefaultRange()
    period: "M"

  getInitialState: ->
    range: @props.range[..]
    period: @props.period
    showPicker: false

  render: ->
    <div className="react-date-ranger">
      <div className="react-date-ranger-display" onClick={@showPicker}>
        <div className="segment">
          <label>Период</label>
          {@renderPeriod(@props.period)}
        </div>
        <div className="segment">
          <label>Диапазон</label>
          {@props.range.map(@renderDate).join(' - ')}
        </div>
      </div>
      {@renderPanel() if @state.showPicker}
    </div>

  renderPanel: ->
    DatePicker = DatePickers[@state.period]

    if @props.allowedRange
      parsedAllowedRange = @props.allowedRange.map((dateString) => moment(dateString, @props.allowedRangeFormat))
    else
      null

    <div className="react-date-ranger-panel">
      <div>
        <label>Период</label>
        <PeriodPicker period={@state.period} allowedPeriods={@props.allowedPeriods} onChange={@_onPeriodChange} />
      </div>
      <div>
        <label>Начало</label>
        <DatePicker allowedRange={parsedAllowedRange} date={@state.range[0]} onChange={@_onFromChange} />
      </div>
      <div>
        <label>Конец</label>
        <DatePicker allowedRange={parsedAllowedRange} date={@state.range[1]} onChange={@_onToChange} />
      </div>
      <br/>
      <button onClick={@_onSubmit}>Применить</button>
      <button onClick={@_onCancel}>Отмена</button>
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

  showPicker: ->
    @setState(showPicker: true)

  _onPeriodChange: (newPeriod) ->
    @setState(period: newPeriod)

  _onFromChange: (newFrom) ->
    @state.range[0] = newFrom
    @forceUpdate()

  _onToChange: (newTo) ->
    @state.range[1] = newTo
    @forceUpdate()

  _onSubmit: (e) ->
    @setState(showPicker: false)
    console.log @state.period
    console.log @state.range

  _onCancel: (e) ->
    @setState(showPicker: false)
    @setState(
      period: @props.period
      range: @props.range[..]
    )
)
