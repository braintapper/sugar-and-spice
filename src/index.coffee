Sugar = require "sugar"
require('sugar-inflections')
require('sugar-language')
# Array

Sugar.Array.defineInstance

  toName: (array)->
    array.join(" ").compact()

  toFamilyName: (array)->
    lastName = array.pop() + ","
    array.splice(0,0,lastName)
    array.join(" ").compact()


Sugar.Array.defineInstanceWithArguments
  pluck: (array, args)->
    return array.map (item)->
      return Object.select(item, args)


# Number

Sugar.Number.defineInstance
  msToSeconds: (num)->
    return num * 1000
  msToMinutes: (num)->
    num.msToSeconds() / 60
  msToHours: (num)->
    num.msToMinutes() / 60
  msToDays: (num)->
    num.toHours() / 24
  sToMilliseconds: (num)->
    num * 1000
  mToMilliseconds: (num)->
    num.sToMilliseconds * 60
  hToMilliseconds: (num)->
    num.mToMilliseconds * 60

Sugar.Number.defineInstanceWithArguments
  isBetween: (num, args)->
    if args.length == 2
      return (num >= args.min()) && (num <= args.max())
    else
      throw "2 numeric arguments are required"

# Date

Sugar.Date.defineInstance
  isBusinessDay: (date)->
    date.getWeekday().isBetween(1,5)
  getIsoWeek: (date)->
    date.setHours 0, 0, 0, 0
    # Thursday in current week decides the year.
    date.setDate date.getDate() + 3 - ((date.getDay() + 6) % 7)
    # January 4 is always in week 1.
    week1 = new Date(date.getFullYear(), 0, 4)
    # Adjust to Thursday in week 1 and count number of weeks from date to week1.
    1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7)
  getIsoWeekYear: (date) ->
    date.setDate date.getDate() + 3 - ((date.getDay() + 6) % 7)
    date.getFullYear()
  getOrdinalWeek: (date)->
    start = date.clone().beginningOfYear().beginningOfDay()
    elapsed = date.daysSince(start)
    return (elapsed / 7).floor()
  getOrdinalWeekNumber: (date)->
    date.getOrdinalWeek() + 1
  getWeekDayNumber: (date)->
    date.getWeekday() + 1
  getMonthNumber: (date)->
    date.getMonth() + 1
  getQuarterNumber: (date)->
    switch parseInt(date.format("%m"))
      when 1,2,3
        1
      when 4,5,6
        2
      when 7,8,9
        3
      when 10,11,12
        4
  toDateId: (date)->
    parseInt date.format("%Y%m%d")
  toMonthId: (date)->
    parseInt date.format("%Y%m")
  toQuarterId: (date)->
    parseInt "#{date.format("%Y%m")}#{date.getQuarterNumber()}"
  posted: (date)->
    # relative date with a few more rules for posting dates\
  toObject: (date)->
    date: date
    year: date.getYear()
    month: date.getMonthNumber()
    monthName: date.format("%B")
    monthAbbreviation: date.format("%b")
    day: date.getDate()
    dayOfWeek: date.getDay() + 1
    weekday: date.format("%A")
    weekdayAbbreviation: date.format("%a")



Sugar.Date.defineInstanceWithArguments
  diffDays: (date,args)->
    # arg 1: second date
    start = date.clone().beginningOfDay()
    end = args.first().clone().beginningOfDay()
    end.daysSince(start)
  diffWeeks: (date,args)->
    # arg 1: second date
    start = date.clone().beginningOfDay()
    end = args.first().clone().beginningOfDay()
    end.weeksSince(start)
  diffMonths: (date,args)->
    # arg 1: second date
    start = date.clone().beginningOfDay()
    end = args.first().clone().beginningOfDay()
    end.monthsSince(start)
  diffQuarters: (date, args)->
    console.log "to be implemented"
    0
  diffYears: (date,args)->
    # arg 1: second date
    start = date.clone().beginningOfDay()
    end = args.first().clone().beginningOfDay()
    end.yearsSince(start)
  dbDate: (date)->
    # db friendly date
    return date.format("%Y-%m-%d")
  isSameHourAs: (date, args)->
    console.log "to be implemented"
    return true
  isSameDayAs: (date, args)->
    return date.toDateId == args[0].toDateId
  isSameWeekAs: (date, args)->
    return true
  isSameMonthAs: (date, args)->
    return date.toMonthId == args[0].toMonthId
  isSameQuarterAs: (date, args)->
    return date.toQuarterId == args[0].toDQuarterId
  isSameYearAs: (date, args)->
    return date.getYear() == args[0].getYear()
  comparedTo: (date, args)->
    # return a string compared to arg[0]
    # can be used for class names for styling
    if date.isSameDayAs(args.first())
      return "on"
    else
      if date.toDateId() < args.first().toDateId()
        return "before"
      else
        return "after"
  toWeekCalendar: (date, args)->
    # todo: add additional info to the calendar
    # * selected date
    # * in selected dates' month
    days = []
    calendarStart = date.clone().beginningOfWeek()
    calendarEnd = date.clone().endOfWeek()
    runningDate = calendarStart.clone()
    currentWeek = []
    count = 0
    while runningDate.isBetween(calendarStart, calendarEnd)
      days.push runningDate.clone().toObject()
      runningDate.addDays(1)
    return days

  toMonthCalendar: (date, args)->
    # generate data for a month view
    # calendars always start on sun and end on sat
    # this will produce dates before and after the date's month where applicable
    # because the most common usage will be in a standard calendar
    # this returns an array of weeks containing day objects
    # todo: this can be refactored using to WeekCalendar
    # todo: add additional info to the calendar
    # * selected date
    # * in selected dates' month
    weeks = []
    calendarStart = date.clone().beginningOfMonth().beginningOfWeek()
    calendarEnd = date.clone().endOfMonth().endOfWeek()


    runningDate = calendarStart.clone()
    currentWeek = []
    count = 0
    while runningDate.isBetween(calendarStart, calendarEnd)
      currentWeek.push runningDate.clone().toObject()
      runningDate.addDays(1)
      count++
      if count == 7
        weeks.push currentWeek
        currentWeek = []
        count = 0

    return weeks

# String

# Custom Pluralizations

Sugar.String.addPlural "is", "are"

Sugar.Date.defineInstance
  validateNumber: (string)->
    # is a valid number
    true
  validateInteger: (string)->
    # is an integer
    true
  validateDate: (string)->
    # is a valid date
    true
  validatePresent: (string)->
    # not blank


Sugar.Object.defineInstance
  toJSON: (obj)->
    JSON.stringify(obj, null, 2)


module.exports = Sugar
