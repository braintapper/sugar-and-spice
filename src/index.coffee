Sugar = require "sugar"
require('sugar-inflections')

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
    return num / 1000
  msToMinutes: (num)->
    num.msToSeconds() / 60
  msToHours: (num)->
    num.msToMinutes() / 60
  msToDays: (num)->
    num.toHours() / 24
  sToMilliseconds: (num)->
    num * 1000
  mToMilliseconds: (num)->
    num.sToMilliseconds() * 60
  hToMilliseconds: (num)->
    num.mToMilliseconds() * 60

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
  getIsoYear: (date) ->
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
    Math.ceil parseInt(date.format("%m")) / 3
  toDateId: (date)->
    parseInt date.format("%Y%m%d")
  toMonthId: (date)->
    parseInt date.format("%Y%m")
  toQuarterId: (date)->
    parseInt "#{date.format("%Y%m")}#{date.getQuarterNumber()}"
  toTimestampId: (date)->
    parseInt date.format("%Y%m%d%H%M%S")
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
  toWeekCalendar: (date)->
    # todo: add additional info to the calendar
    # * selected date
    # * in selected dates' month
    days = []
    calendarStart = date.clone().beginningOfWeek()
    calendarEnd = date.clone().endOfWeek()
    runningDate = calendarStart.clone()
    currentWeek = []
    count = 0
    range = Date.range(calendarStart, calendarEnd)

    #while runningDate.isBetween(calendarStart, calendarEnd)
    #  days.push runningDate.clone().toObject()
    #  runningDate.addDays(1)
    return range.every("day").map (d)->
      return d.toObject()

  toMonthCalendar: (date)->
    # generate data for a month view
    # calendars always start on sun and end on sat
    # this will produce dates before and after the date's month where applicable
    # because the most common usage will be in a standard calendar

    # todo: this can be refactored using to WeekCalendar
    # todo: add additional info to the calendar
    # * selected date
    # * in selected dates' month
    calendarStart = date.clone().beginningOfMonth().beginningOfWeek()
    calendarEnd = date.clone().endOfMonth().endOfWeek()
    range = Date.range(calendarStart, calendarEnd)
    return range.every("day").map (d)->
      return d.toObject()
  dbDate: (date)->   # db friendly date
    return date.format("%Y-%m-%d")


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
    # todo
    console.log "to be implemented"
    0
  diffYears: (date,args)->
    # arg 1: second date
    start = date.clone().beginningOfDay()
    end = args.first().clone().beginningOfDay()
    end.yearsSince(start)

  isSameDayAs: (date, args)->
    return date.toDateId() == args[0].toDateId()
  isSameMonthAs: (date, args)->
    return date.toMonthId() == args[0].toMonthId()
  isSameQuarterAs: (date, args)->
    return date.toQuarterId() == args[0].toDQuarterId()
  isSameYearAs: (date, args)->
    return date.getYear() == args[0].getYear()
  isSameOrdinalWeekAs: (date, args)->
    if date.isSameYearAs(args.first())
      return date.getOrdinalWeek() == args.first().getOrdinalWeek()
    else
      return false
  isSameIsoWeekAs: (date, args)->
    if date.getISOYear() == args.first().getISOYear()
      return date.getISOWeek() == args.first().getISOWeek()
    else
      return false
  isOnOrBefore: (date, args)->
    return date.toDateId() <= args.first().toDateId()

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

  weekdaysSince: (date, args)->
    calendarStart = date
    calendarEnd = args.first()
    range = Date.range(calendarStart, calendarEnd)
    return range.every("day").sum (day)->
      if day.getDay().isBetween(1,5)
        return 1
      else
        return 0

  relativeDateToNow: (date, args)-> # does not factor time
    # this, next and last have some ambiguity and mixed use in English
    today = Date.create()
    if date.isToday()
      "Today"
    else if date.isTomorrow()
      "Tomorrow"
    else if date.isYesterday()
      "Yesterday"
    else if date.isBetween(today, today.endOfWeek()) # now until Saturday, just use weekday name
      date.format("%A")
    else if date.isBetween(today.addWeeks(1).beginningOfWeek(), today.addWeeks(1).endOfWeek()) # anything after saturday in the next week has "Next" prefix
      date.format("Next %A")
    else # just show the date
      date.format("%a, %b {d}, %Y")




# String

Sugar.String.defineInstance
  toBoolean: (string)->
    regex=/^\s*(true|1|on)\s*$/i
    return regex.test(string)

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
