module.exports = {
  Y: {
    picker: require('./YearPicker'),
    keyword: 'year'
  },
  Q: {
    picker: require('./QuarterPicker'),
    keyword: 'quarter'
  },
  M: {
    picker: require('./MonthPicker'),
    keyword: 'month'
  },
  W: {
    picker: require('./WeekPicker'),
    keyword: 'isoWeek'
  },
  D: {
    picker: require('./DayPicker'),
    keyword: 'day'
  }
};
