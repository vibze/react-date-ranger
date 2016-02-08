React = require('react')
cx = require('classnames')


module.exports = React.createClass(
  propTypes:
    page: React.PropTypes.any.isRequired
    prevDisabled: React.PropTypes.func.isRequired
    nextDisabled: React.PropTypes.func.isRequired
    prevPage: React.PropTypes.func.isRequired
    nextPage: React.PropTypes.func.isRequired
    headerRenderer: React.PropTypes.func.isRequired

    calStartDate: React.PropTypes.func.isRequired
    calEndDate: React.PropTypes.func.isRequired
    calDateIncrement: React.PropTypes.func.isRequired
    calCellsInRow: React.PropTypes.number.isRequired

    dateIsDisabled: React.PropTypes.func.isRequired
    dateIsHighlighted: React.PropTypes.func.isRequired
    dateIsSelected: React.PropTypes.func.isRequired
    dateIsBlurred: React.PropTypes.func
    dateFormat: React.PropTypes.func.isRequired

    onDateClick: React.PropTypes.func

  getDefaultProps: ->
    page: null
    dateIsBlurred: () -> false

  getInitialState: ->
    page: @props.page

  render: ->
    <div className="react-date-ranger-date-picker">
      <div className="react-date-ranger-calendar-toolbar">
        <button disabled={@props.prevDisabled(@state.page)} onClick={@_onPrevPageClick}>❮</button>
        {@props.headerRenderer(@state.page)}
        <button disabled={@props.nextDisabled(@state.page)} onClick={@_onNextPageClick}>❯</button>
      </div>
      <table className="react-date-ranger-calendar">
        <tbody>
          {@renderDates()}
        </tbody>
      </table>
    </div>

  renderDates: ->
    curr = @props.calStartDate(@state.page)
    end = @props.calEndDate(@state.page)

    i = 1
    cells = []
    rows = []
    while curr.isSameOrBefore(end)
      classString = cx(
        "selected": @props.dateIsSelected(curr),
        "highlighted": @props.dateIsHighlighted(curr),
        "blurred": @props.dateIsBlurred(curr, @state.page)
      )

      cells.push(
        <td key={i}>
          <button
            className={classString}
            onClick={@_onDateClick}
            value={curr.format('YYYY-MM-DD')}
            disabled={@props.dateIsDisabled(curr)}>
            {@props.dateFormat(curr)}
          </button>
        </td>
      )

      if i > 0 and i%@props.calCellsInRow == 0
        rows.push(<tr key={i/@props.calCellsInRow}>{cells}</tr>)
        cells = []

      @props.calDateIncrement(curr) and i++
    rows

  _onPrevPageClick: ->
    @setState(page: @props.prevPage(@state.page))

  _onNextPageClick: ->
    @setState(page: @props.nextPage(@state.page))

  _onDateClick: (e) ->
    @props.onDateClick(e.currentTarget.value)
)
