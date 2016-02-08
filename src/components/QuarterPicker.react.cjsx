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
    r = 4

    # Because moment.js isBetween method is exclusive
    if @props.allowedRange
      allowedMin = moment(@props.allowedRange[0]).subtract(1, 'quarters')
      allowedMax = moment(@props.allowedRange[1]).add(1, 'quarters')

    if @props.highlightToDate
      if @props.date.isSameOrBefore(@props.highlightToDate)
        hlStart = @props.date
        hlEnd = moment(@props.highlightToDate).add(1, 'quarters')
      else
        hlStart = moment(@props.highlightToDate).subtract(1, 'quarters')
        hlEnd = @props.date

    <Calendar
      page={@props.date.year()}
      prevDisabled={(page) => @props.allowedRange and page <= @props.allowedRange[0].year()}
      nextDisabled={(page) => @props.allowedRange and page+r >= @props.allowedRange[1].year()}
      prevPage={(page) -> page-r}
      nextPage={(page) -> page+r}
      headerRenderer={(page) -> "#{page} - #{page+r-1}"}

      calStartDate={(page) -> moment(page, 'YYYY').startOf('year')}
      calEndDate={(page) -> moment(page+r-1, 'YYYY').endOf('year')}
      calDateIncrement={(date) -> date.add(1, 'quarters')}
      calCellsInRow={4}

      dateIsDisabled={(date) => @props.allowedRange and not date.isBetween(allowedMin, allowedMax, 'quarter')}
      dateIsHighlighted={(date) => @props.highlightToDate and date.isBetween(hlStart, hlEnd, 'quarter')}
      dateIsSelected={(date) => date.format('YYYYQ') == @props.date.format('YYYYQ')}
      dateFormat={(date) -> date.format('YYYY-[Q]Q')}

      onDateClick={@_onQuarterClick}
       />

  _onQuarterClick: (value) ->
    @props.onChange(moment(value))
)
