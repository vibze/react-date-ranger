React = require('react')
ReactDOM = require('react-dom')
TestUtils = require('react-addons-test-utils')
DateRanger = require('../DateRanger')
moment = require('moment')


describe 'PeriodPicker', ->
  it 'should work with limited periods', ->
    dateRanger = TestUtils.renderIntoDocument(<DateRanger allowedPeriods="YQD" />)
    buttons = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-period-picker button')

    expect(buttons.length).toEqual(3)
    expect(buttons[0].textContent).toEqual("Y")
    expect(buttons[1].textContent).toEqual("Q")
    expect(buttons[2].textContent).toEqual("D")

  it 'should switch periods correctly and fire onChange event', ->
    period = null
    dateRanger = TestUtils.renderIntoDocument(
      <DateRanger allowedPeriods="YQM" onChange={(newPeriod, range) -> period = newPeriod} />)
    buttons = ReactDOM.findDOMNode(dateRanger).querySelectorAll('.react-date-ranger-period-picker button')

    TestUtils.Simulate.click(buttons[2])
    expect(period).toBe("M")
