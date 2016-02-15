React = require('react')
ReactDOM = require('react-dom')
TestUtils = require('react-addons-test-utils')
DateRanger = require('../DateRanger')
moment = require('moment')


describe 'DateRanger quarter mode', ->
  it 'should default range to current quarter', ->
    dateRanger = TestUtils.renderIntoDocument(<DateRanger period="Q" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromMoment = moment(fromPicker.querySelector('button.selected').value)
    toMoment = moment(toPicker.querySelector('button.selected').value)

    expect(fromMoment.isSame(moment(), 'quarter')).toBeTruthy()
    expect(fromPicker.querySelectorAll('button.highlighted').length).toBe(0)
    expect(toMoment.isSame(moment(), 'quarter')).toBeTruthy()
    expect(toPicker.querySelectorAll('button.highlighted').length).toBe(0)

  it 'should preset range if provided', ->
    range = ["2007-05-01", "2017-08-01"]
    dateRanger = TestUtils.renderIntoDocument(<DateRanger range={range} period="Q" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromMoment = moment(fromPicker.querySelector('button.selected').value)
    toMoment = moment(toPicker.querySelector('button.selected').value)

    expect(fromMoment.isSame(moment(range[0]), 'quarter')).toBeTruthy()
    expect(fromPicker.querySelectorAll('button.highlighted').length).toBe(2)
    expect(toMoment.isSame(moment(range[1]), 'quarter')).toBeTruthy()
    expect(toPicker.querySelectorAll('button.highlighted').length).toBe(6)

  it 'should limit range if allowedRange is provided', ->
    range = ["2014-01-01", "2015-01-01"]
    allowedRange = ["2002-01-01", "2018-01-01"]

    dateRanger = TestUtils.renderIntoDocument(<DateRanger
      allowedRange={allowedRange}
      range={range}
      period="Q" />)

    # Now we will click through all periods, from min to max, on both datepickers
    for datePicker, i in ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
      heading = datePicker.querySelector('span')
      [prev, next] = datePicker.querySelectorAll('button')
      year = Math.floor(moment(range[i]).year() / 4) * 4
      [minYear, maxYear] = allowedRange.map((d) -> Math.floor(moment(d).year() / 4) * 4)

      expect(heading.textContent).toBe("#{year} - #{year+4-1}")
      expect(prev.disabled).toBe(false)
      expect(next.disabled).toBe(false)

      # Click prev until year equals minYear, at which point prev button
      # should become disabled
      until year == minYear
        expect(prev.disabled).toBe(false)
        TestUtils.Simulate.click(prev)
        year -= 4
        expect(heading.textContent).toBe("#{year} - #{year+4-1}")

      expect(prev.disabled).toBe(true)

      # Click prev one more time to make sure it is disabled
      TestUtils.Simulate.click(prev)
      expect(heading.textContent).toBe("#{year} - #{year+4-1}")

      # Now click next until year equals maxYear, at which point next button
      # should become disabled
      until year == maxYear
        expect(next.disabled).toBe(false)
        TestUtils.Simulate.click(next)
        year += 4
        expect(heading.textContent).toBe("#{year} - #{year+4-1}")

      expect(next.disabled).toBe(true)

      # Click next one more time to make sure it is disabled
      TestUtils.Simulate.click(next)
      expect(parseInt(heading.textContent)).toBe(year)

  it 'should pick range and fire onChange event', ->
    range = null

    dateRanger = TestUtils.renderIntoDocument(<DateRanger
      range={["2010-01-01", "2012-01-01"]}
      onChange={(period, newRange) -> range = newRange}
      period="Q" />)
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromButtons = fromPicker.querySelectorAll('.react-date-ranger-date-picker-body button')
    toButtons = toPicker.querySelectorAll('.react-date-ranger-date-picker-body button')

    TestUtils.Simulate.click(fromButtons[1])
    TestUtils.Simulate.click(toButtons[4])

    expect(range[0].format('YYYY[Q]Q')).toBe('2008Q2')
    expect(range[1].format('YYYY[Q]Q')).toBe('2013Q1')
