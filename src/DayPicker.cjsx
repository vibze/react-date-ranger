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
    # Because moment.js isBetween method is exclusive
    if @props.allowedRange
      allowedMin = moment(@props.allowedRange[0])
      allowedMax = moment(@props.allowedRange[1])

    if @props.highlightToDate
      if @props.date.isSameOrBefore(@props.highlightToDate)
        hlStart = moment(@props.date)
        hlEnd = moment(@props.highlightToDate).add(1, 'days')
      else
        hlStart = moment(@props.highlightToDate).subtract(1, 'days')
        hlEnd = moment(@props.date)

    <Calendar
      page={moment(@props.date)}
      prevDisabled={(page) => @props.allowedRange and page.isSameOrBefore(allowedMin, 'month')}
      nextDisabled={(page) => @props.allowedRange and page.isSameOrAfter(allowedMax, 'month')}
      prevPage={(page) -> page.subtract(1, 'months')}
      nextPage={(page) -> page.add(1, 'months')}
      headerRenderer={(page) -> page.format('MMM YYYY')}

      calStartDate={(page) -> moment(page).startOf('month').startOf('isoWeek')}
      calEndDate={(page) -> moment(page).endOf('month').endOf('isoWeek')}
      calDateIncrement={(date) ->
        date.add(1, 'days')
        date
      }
      calCellsInRow={7}

      dateIsDisabled={(date) => @props.allowedRange and not date.isBetween(allowedMin, allowedMax, 'day')}
      dateIsHighlighted={(date) => @props.highlightToDate and date.isBetween(hlStart, hlEnd, 'day')}
      dateIsSelected={(date) => date.format('YYYYMMDD') == @props.date.format('YYYYMMDD')}
      dateIsBlurred={(date, page) => date.format('YYYYMM') != page.format('YYYYMM')}
      dateFormat={(date) -> date.format('DD')}

      onDateClick={@_onDayClick}
       />

  _onDayClick: (value) ->
    @props.onChange(moment(value))
)
