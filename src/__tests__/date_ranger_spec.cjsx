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
