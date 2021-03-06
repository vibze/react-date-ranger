React = require('react')
moment = require('moment')
cx = require('classnames')
Calendar = require('./Calendar')


module.exports = React.createClass(
  propTypes:
    allowedRange: React.PropTypes.array  # Moment.js objects
    date: React.PropTypes.object.isRequired  # Moment.js object
    highlightToDate: React.PropTypes.object.isRequired  # Moment.js object
    onChange: React.PropTypes.func

  render: ->
    r = 12

    # Because moment.js isBetween method is exclusive
    if @props.allowedRange
      allowedMin = moment(@props.allowedRange[0]).subtract(1, 'years')
      allowedMax = moment(@props.allowedRange[1]).add(1, 'years')

    if @props.highlightToDate
      if @props.date.isSameOrBefore(@props.highlightToDate)
        hlStart = @props.date
        hlEnd = moment(@props.highlightToDate).add(1, 'years')
      else
        hlStart = moment(@props.highlightToDate).subtract(1, 'years')
        hlEnd = @props.date

    <Calendar
      page={Math.floor(@props.date.year() / r) * r}
      prevDisabled={(page) => @props.allowedRange and page <= @props.allowedRange[0].year()}
      nextDisabled={(page) => @props.allowedRange and page+r > @props.allowedRange[1].year()}
      prevPage={(page) -> page-r}
      nextPage={(page) -> page+r}
      headerRenderer={(page) -> "#{page} - #{page+r-1}"}

      calStartDate={(page) -> moment(r * Math.floor(page / r), 'YYYY')}
      calEndDate={(page) -> moment(r * Math.floor(page / r) + r - 1, 'YYYY')}
      calDateIncrement={(date) -> date.add(1, 'years')}
      calCellsInRow={3}

      dateIsDisabled={(date) => @props.allowedRange and not date.isBetween(allowedMin, allowedMax, 'year')}
      dateIsHighlighted={(date) => @props.highlightToDate and date.isBetween(hlStart, hlEnd, 'year')}
      dateIsSelected={(date) => date.format('YYYY') == @props.date.format('YYYY')}
      dateFormat={(date) -> date.format('YYYY')}

      onDateClick={@_onQuarterClick}
       />

  _onQuarterClick: (value) ->
    @props.onChange(moment(value))
)
