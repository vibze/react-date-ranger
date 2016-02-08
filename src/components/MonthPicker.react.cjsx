React = require('react')
moment = require('moment')
cx = require('classnames')
Calendar = require('./Calendar.react')


module.exports = React.createClass(
  propTypes:
    allowedRange: React.PropTypes.array  # Moment.js objects
    date: React.PropTypes.object.isRequired  # Moment.js object
    highlightToDate: React.PropTypes.object.isRequired  # Moment.js object
    onChange: React.PropTypes.func

  render: ->
    # Because moment.js isBetween method is exclusive
    if @props.allowedRange
      allowedMin = moment(@props.allowedRange[0]).subtract(1, 'months')
      allowedMax = moment(@props.allowedRange[1]).add(1, 'months')

    if @props.highlightToDate
      if @props.date.isSameOrBefore(@props.highlightToDate)
        hlStart = @props.date
        hlEnd = moment(@props.highlightToDate).add(1, 'months')
      else
        hlStart = moment(@props.highlightToDate).subtract(1, 'months')
        hlEnd = @props.date

    <Calendar
      page={@props.date.year()}
      prevDisabled={(page) => @props.allowedRange and page <= @props.allowedRange[0].year()}
      nextDisabled={(page) => @props.allowedRange and page >= @props.allowedRange[1].year()}
      prevPage={(page) -> page-1}
      nextPage={(page) -> page+1}
      headerRenderer={(page) -> page}

      calStartDate={(page) -> moment(page, 'YYYY').startOf('year')}
      calEndDate={(page) -> moment(page, 'YYYY').endOf('year')}
      calDateIncrement={(date) -> date.add(1, 'months')}
      calCellsInRow={3}

      dateIsDisabled={(date) => @props.allowedRange and not date.isBetween(allowedMin, allowedMax, 'month')}
      dateIsHighlighted={(date) => @props.highlightToDate and date.isBetween(hlStart, hlEnd, 'month')}
      dateIsSelected={(date) => date.format('YYYYMM') == @props.date.format('YYYYMM')}
      dateFormat={(date) -> date.format('MMM')}

      onDateClick={@_onMonthClick}
       />

  _onMonthClick: (value) ->
    @props.onChange(moment(value))
)
