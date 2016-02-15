React = require('react')
ReactDOM = require('react-dom')
TestUtils = require('react-addons-test-utils')
DateRanger = require('../DateRanger')
moment = require('moment')


describe 'DateRanger day mode', ->
  it 'should default range to current week', ->
    dateRanger = TestUtils.renderIntoDocument(<DateRanger period="D" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromMoment = moment(fromPicker.querySelector('button.selected').value)
    toMoment = moment(toPicker.querySelector('button.selected').value)

    expect(fromMoment.format('YYYY-MM-DD')).toBe(moment().format('YYYY-MM-DD'))
    expect(fromPicker.querySelectorAll('button.highlighted').length).toBe(0)
    expect(toMoment.format('YYYY-MM-DD')).toBe(moment().format('YYYY-MM-DD'))
    expect(toPicker.querySelectorAll('button.highlighted').length).toBe(0)

  it 'should preset range if provided', ->
    range = ["2014-05-01", "2015-08-05"]
    dateRanger = TestUtils.renderIntoDocument(<DateRanger range={range} period="D" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromMoment = moment(fromPicker.querySelector('button.selected').value)
    toMoment = moment(toPicker.querySelector('button.selected').value)

    expect(fromMoment.isSame(moment(range[0]), 'week')).toBeTruthy()
    expect(fromPicker.querySelectorAll('button.highlighted').length).toBe(31)
    expect(toMoment.isSame(moment(range[1]), 'week')).toBeTruthy()
    expect(toPicker.querySelectorAll('button.highlighted').length).toBe(9)

  it 'should limit range if allowedRange is provided', ->
    range = ["2014-01-01", "2015-01-01"]
    allowedRange = ["2013-01-01", "2016-01-01"]

    dateRanger = TestUtils.renderIntoDocument(
      <DateRanger
        allowedRange={allowedRange}
        range={range}
        period="D" />
    )

    # Now we will click through all periods, from min to max, on both datepickers
    for datePicker, i in ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
      heading = datePicker.querySelector('span')
      [prev, next] = datePicker.querySelectorAll('button')
      month = moment(range[i])
      [minMonth, maxMonth] = allowedRange.map((d) -> moment(d))

      expect(heading.textContent).toBe(month.format('MMM YYYY'))
      expect(prev.disabled).toBe(false)
      expect(next.disabled).toBe(false)

      # Click prev until year equals minMonth, at which point prev button
      # should become disabled
      until month.isSame(minMonth, 'month')
        expect(prev.disabled).toBe(false)
        TestUtils.Simulate.click(prev)
        month.subtract(1, 'months')
        expect(heading.textContent).toBe(month.format('MMM YYYY'))

      expect(prev.disabled).toBe(true)

      # Click prev one more time to make sure it is disabled
      TestUtils.Simulate.click(prev)
      expect(heading.textContent).toBe(month.format('MMM YYYY'))

      # Now click next until year equals maxMonth, at which point next button
      # should become disabled
      until month.isSame(maxMonth, 'month')
        expect(next.disabled).toBe(false)
        TestUtils.Simulate.click(next)
        month.add(1, 'months')
        expect(heading.textContent).toBe(month.format('MMM YYYY'))

      expect(next.disabled).toBe(true)

      # Click next one more time to make sure it is disabled
      TestUtils.Simulate.click(next)
      expect(heading.textContent).toBe(month.format('MMM YYYY'))

  it 'should pick range and fire onChange event', ->
    range = null

    dateRanger = TestUtils.renderIntoDocument(<DateRanger
      range={["2016-02-01", "2016-02-29"]}
      onChange={(period, newRange) -> range = newRange}
      period="D" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromDays = fromPicker.querySelectorAll('.react-date-ranger-date-picker-body button')
    toDays = toPicker.querySelectorAll('.react-date-ranger-date-picker-body button')

    TestUtils.Simulate.click(fromDays[8])  # 09/02/2016
    TestUtils.Simulate.click(toDays[15])  # 16/02/2016

    expect(range[0].format("YYYY-MM-DD")).toBe("2016-02-09")
    expect(range[1].format("YYYY-MM-DD")).toBe("2016-02-16")
