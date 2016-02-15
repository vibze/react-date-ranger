React = require('react')
ReactDOM = require('react-dom')
TestUtils = require('react-addons-test-utils')
DateRanger = require('../DateRanger')
moment = require('moment')


describe 'DateRanger month mode', ->
  it 'should default range to current month', ->
    dateRanger = TestUtils.renderIntoDocument(<DateRanger period="M" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromMoment = moment(fromPicker.querySelector('button.selected').value)
    toMoment = moment(toPicker.querySelector('button.selected').value)

    expect(fromMoment.isSame(moment(), 'month')).toBeTruthy()
    expect(fromPicker.querySelectorAll('button.highlighted').length).toBe(0)
    expect(toMoment.isSame(moment(), 'month')).toBeTruthy()
    expect(toPicker.querySelectorAll('button.highlighted').length).toBe(0)

  it 'should preset range if provided', ->
    range = ["2014-05-01", "2015-08-01"]
    dateRanger = TestUtils.renderIntoDocument(<DateRanger range={range} period="M" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromMoment = moment(fromPicker.querySelector('button.selected').value)
    toMoment = moment(toPicker.querySelector('button.selected').value)

    expect(fromMoment.isSame(moment(range[0]), 'month')).toBeTruthy()
    expect(fromPicker.querySelectorAll('button.highlighted').length).toBe(7)
    expect(toMoment.isSame(moment(range[1]), 'month')).toBeTruthy()
    expect(toPicker.querySelectorAll('button.highlighted').length).toBe(7)

  it 'should limit range if allowedRange is provided', ->
    range = ["2014-01-01", "2015-01-01"]
    allowedRange = ["2013-01-01", "2016-01-01"]

    dateRanger = TestUtils.renderIntoDocument(<DateRanger
      allowedRange={allowedRange}
      range={range}
      period="M" />)

    # Now we will click through all periods, from min to max, on both datepickers
    for datePicker, i in ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
      heading = datePicker.querySelector('span')
      [prev, next] = datePicker.querySelectorAll('button')
      year = moment(range[i]).year()
      [minYear, maxYear] = allowedRange.map((d) -> moment(d).year())

      expect(parseInt(heading.textContent)).toBe(year)
      expect(prev.disabled).toBe(false)
      expect(next.disabled).toBe(false)

      # Click prev until year equals minYear, at which point prev button
      # should become disabled
      until year == minYear
        expect(prev.disabled).toBe(false)
        TestUtils.Simulate.click(prev)
        year -= 1
        expect(parseInt(heading.textContent)).toBe(year)

      expect(prev.disabled).toBe(true)

      # Click prev one more time to make sure it is disabled
      TestUtils.Simulate.click(prev)
      expect(parseInt(heading.textContent)).toBe(year)

      # Now click next until year equals maxYear, at which point next button
      # should become disabled
      until year == maxYear
        expect(next.disabled).toBe(false)
        TestUtils.Simulate.click(next)
        year += 1
        expect(parseInt(heading.textContent)).toBe(year)

      expect(next.disabled).toBe(true)

      # Click next one more time to make sure it is disabled
      TestUtils.Simulate.click(next)
      expect(parseInt(heading.textContent)).toBe(year)

  it 'should pick range and fire onChange event', ->
    range = null

    dateRanger = TestUtils.renderIntoDocument(<DateRanger
      onChange={(period, newRange) -> range = newRange}
      period="M" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromMonths = fromPicker.querySelectorAll('.react-date-ranger-date-picker-body button')
    toMonths = toPicker.querySelectorAll('.react-date-ranger-date-picker-body button')

    TestUtils.Simulate.click(fromMonths[1])  # February
    TestUtils.Simulate.click(toMonths[4])  # May

    expect(range[0].isSame(moment().month(1), 'month')).toBeTruthy()
    expect(range[1].isSame(moment().month(4), 'month')).toBeTruthy()
