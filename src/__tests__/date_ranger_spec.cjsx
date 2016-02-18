React = require('react')
ReactDOM = require('react-dom')
TestUtils = require('react-addons-test-utils')
DateRanger = require('../DateRanger')
moment = require('moment')


describe 'DateRanger', ->
  it 'should remember date after switching period', ->
    range = ["2015-04-11", "2015-08-25"]
    pickedRange = []
    dateRanger = TestUtils.renderIntoDocument(
      <DateRanger
        range={range}
        period="D"
        onChange={(period, range) -> pickedRange = range} />
    )
    buttons = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-period-picker button')

    # Year
    TestUtils.Simulate.click(buttons[0])
    expect(pickedRange[0].format('YYYY-MM-DD')).toBe("2015-01-01")
    expect(pickedRange[1].format('YYYY-MM-DD')).toBe("2015-12-31")

    # Quarter
    TestUtils.Simulate.click(buttons[1])
    expect(pickedRange[0].format('YYYY-MM-DD')).toBe("2015-04-01")
    expect(pickedRange[1].format('YYYY-MM-DD')).toBe("2015-09-30")

    # Month
    TestUtils.Simulate.click(buttons[2])
    expect(pickedRange[0].format('YYYY-MM-DD')).toBe("2015-04-01")
    expect(pickedRange[1].format('YYYY-MM-DD')).toBe("2015-08-31")

    # Week
    TestUtils.Simulate.click(buttons[3])
    expect(pickedRange[0].format('YYYY-MM-DD')).toBe("2015-04-06")
    expect(pickedRange[1].format('YYYY-MM-DD')).toBe("2015-08-30")

    # Back to day
    TestUtils.Simulate.click(buttons[4])
    expect(pickedRange[0].format('YYYY-MM-DD')).toBe("2015-04-11")
    expect(pickedRange[1].format('YYYY-MM-DD')).toBe("2015-08-25")

  it 'should return sorted range', ->
    pickedRange = []
    dateRanger = TestUtils.renderIntoDocument(
      <DateRanger
        period="M"
        onChange={(period, range) -> pickedRange = range} />
    )
    [fromPicker, toPicker] = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-date-picker')
    fromButtons = fromPicker.querySelectorAll('.react-date-ranger-date-picker-body button')
    toButtons = toPicker.querySelectorAll('.react-date-ranger-date-picker-body button')

    TestUtils.Simulate.click(fromButtons[5])
    TestUtils.Simulate.click(toButtons[3])
    expect(pickedRange[0].month()).toBe(3)
    expect(pickedRange[1].month()).toBe(5)
