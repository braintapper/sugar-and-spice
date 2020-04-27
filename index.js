var Sugar;

Sugar = require("sugar");

require('sugar-inflections');

require('sugar-language');

// Array
Sugar.Array.defineInstance({
  toName: function(array) {
    return array.join(" ").compact();
  },
  toFamilyName: function(array) {
    var lastName;
    lastName = array.pop() + ",";
    array.splice(0, 0, lastName);
    return array.join(" ").compact();
  }
});

Sugar.Array.defineInstanceWithArguments({
  pluck: function(array, args) {
    return array.map(function(item) {
      return Object.select(item, args);
    });
  }
});

// Number
Sugar.Number.defineInstance({
  msToSeconds: function(num) {
    return num * 1000;
  },
  msToMinutes: function(num) {
    return num.msToSeconds() / 60;
  },
  msToHours: function(num) {
    return num.msToMinutes() / 60;
  },
  msToDays: function(num) {
    return num.toHours() / 24;
  },
  sToMilliseconds: function(num) {
    return num * 1000;
  },
  mToMilliseconds: function(num) {
    return num.sToMilliseconds() * 60;
  },
  hToMilliseconds: function(num) {
    return num.mToMilliseconds() * 60;
  }
});

Sugar.Number.defineInstanceWithArguments({
  isBetween: function(num, args) {
    if (args.length === 2) {
      return (num >= args.min()) && (num <= args.max());
    } else {
      throw "2 numeric arguments are required";
    }
  }
});

// Date
Sugar.Date.defineInstance({
  isBusinessDay: function(date) {
    return date.getWeekday().isBetween(1, 5);
  },
  getIsoWeek: function(date) {
    var week1;
    date.setHours(0, 0, 0, 0);
    // Thursday in current week decides the year.
    date.setDate(date.getDate() + 3 - ((date.getDay() + 6) % 7));
    // January 4 is always in week 1.
    week1 = new Date(date.getFullYear(), 0, 4);
    // Adjust to Thursday in week 1 and count number of weeks from date to week1.
    return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7);
  },
  getIsoYear: function(date) {
    date.setDate(date.getDate() + 3 - ((date.getDay() + 6) % 7));
    return date.getFullYear();
  },
  getOrdinalWeek: function(date) {
    var elapsed, start;
    start = date.clone().beginningOfYear().beginningOfDay();
    elapsed = date.daysSince(start);
    return (elapsed / 7).floor();
  },
  getOrdinalWeekNumber: function(date) {
    return date.getOrdinalWeek() + 1;
  },
  getWeekDayNumber: function(date) {
    return date.getWeekday() + 1;
  },
  getMonthNumber: function(date) {
    return date.getMonth() + 1;
  },
  getQuarterNumber: function(date) {
    switch (parseInt(date.format("%m"))) {
      case 1:
      case 2:
      case 3:
        return 1;
      case 4:
      case 5:
      case 6:
        return 2;
      case 7:
      case 8:
      case 9:
        return 3;
      case 10:
      case 11:
      case 12:
        return 4;
    }
  },
  toDateId: function(date) {
    return parseInt(date.format("%Y%m%d"));
  },
  toMonthId: function(date) {
    return parseInt(date.format("%Y%m"));
  },
  toQuarterId: function(date) {
    return parseInt(`${date.format("%Y%m")}${date.getQuarterNumber()}`);
  },
  toTimestampId: function(date) {
    return parseInt(date.format("%Y%m%d%H%M%S"));
  },
  posted: function(date) {},
  // relative date with a few more rules for posting dates\
  toObject: function(date) {
    return {
      date: date,
      year: date.getYear(),
      month: date.getMonthNumber(),
      monthName: date.format("%B"),
      monthAbbreviation: date.format("%b"),
      day: date.getDate(),
      dayOfWeek: date.getDay() + 1,
      weekday: date.format("%A"),
      weekdayAbbreviation: date.format("%a")
    };
  },
  toWeekCalendar: function(date) {
    var calendarEnd, calendarStart, count, currentWeek, days, range, runningDate;
    // todo: add additional info to the calendar
    // * selected date
    // * in selected dates' month
    days = [];
    calendarStart = date.clone().beginningOfWeek();
    calendarEnd = date.clone().endOfWeek();
    runningDate = calendarStart.clone();
    currentWeek = [];
    count = 0;
    range = Date.range(calendarStart, calendarEnd);
    //while runningDate.isBetween(calendarStart, calendarEnd)
    //  days.push runningDate.clone().toObject()
    //  runningDate.addDays(1)
    return range.every("day").map(function(d) {
      return d.toObject();
    });
  },
  toMonthCalendar: function(date) {
    var calendarEnd, calendarStart, range;
    // generate data for a month view
    // calendars always start on sun and end on sat
    // this will produce dates before and after the date's month where applicable
    // because the most common usage will be in a standard calendar

    // todo: this can be refactored using to WeekCalendar
    // todo: add additional info to the calendar
    // * selected date
    // * in selected dates' month
    calendarStart = date.clone().beginningOfMonth().beginningOfWeek();
    calendarEnd = date.clone().endOfMonth().endOfWeek();
    range = Date.range(calendarStart, calendarEnd);
    return range.every("day").map(function(d) {
      return d.toObject();
    });
  }
});

Sugar.Date.defineInstanceWithArguments({
  diffDays: function(date, args) {
    var end, start;
    // arg 1: second date
    start = date.clone().beginningOfDay();
    end = args.first().clone().beginningOfDay();
    return end.daysSince(start);
  },
  diffWeeks: function(date, args) {
    var end, start;
    // arg 1: second date
    start = date.clone().beginningOfDay();
    end = args.first().clone().beginningOfDay();
    return end.weeksSince(start);
  },
  diffMonths: function(date, args) {
    var end, start;
    // arg 1: second date
    start = date.clone().beginningOfDay();
    end = args.first().clone().beginningOfDay();
    return end.monthsSince(start);
  },
  diffQuarters: function(date, args) {
    // todo
    console.log("to be implemented");
    return 0;
  },
  diffYears: function(date, args) {
    var end, start;
    // arg 1: second date
    start = date.clone().beginningOfDay();
    end = args.first().clone().beginningOfDay();
    return end.yearsSince(start);
  },
  dbDate: function(date) { // db friendly date
    return date.format("%Y-%m-%d");
  },
  isSameDayAs: function(date, args) {
    return date.toDateId() === args[0].toDateId();
  },
  isSameMonthAs: function(date, args) {
    return date.toMonthId() === args[0].toMonthId();
  },
  isSameQuarterAs: function(date, args) {
    return date.toQuarterId() === args[0].toDQuarterId();
  },
  isSameYearAs: function(date, args) {
    return date.getYear() === args[0].getYear();
  },
  isSameOrdinalWeekAs: function(date, args) {
    if (date.isSameYearAs(args.first())) {
      return date.getOrdinalWeek() === args.first().getOrdinalWeek();
    } else {
      return false;
    }
  },
  isSameIsoWeekAs: function(date, args) {
    if (date.getISOYear() === args.first().getISOYear()) {
      return date.getISOWeek() === args.first().getISOWeek();
    } else {
      return false;
    }
  },
  isOnOrBefore: function(date, args) {
    return date.toDateId() <= args.first().toDateId();
  },
  comparedTo: function(date, args) {
    // return a string compared to arg[0]
    // can be used for class names for styling
    if (date.isSameDayAs(args.first())) {
      return "on";
    } else {
      if (date.toDateId() < args.first().toDateId()) {
        return "before";
      } else {
        return "after";
      }
    }
  },
  weekdaysSince: function(date, args) {
    var calendarEnd, calendarStart, range;
    calendarStart = date;
    calendarEnd = args.first();
    range = Date.range(calendarStart, calendarEnd);
    return range.every("day").sum(function(day) {
      if (day.getDay().isBetween(1, 5)) {
        return 1;
      } else {
        return 0;
      }
    });
  },
  relativeDateToNow: function(date, args) { // does not factor time
    var today;
    // this, next and last have some ambiguity and mixed use in English
    today = Date.create();
    if (date.isToday()) {
      return "Today";
    } else if (date.isTomorrow()) {
      return "Tomorrow";
    } else if (date.isYesterday()) {
      return "Yesterday";
    } else if (date.isBetween(today, today.endOfWeek())) { // now until Saturday, just use weekday name
      return date.format("%A");
    } else if (date.isBetween(today.addWeeks(1).beginningOfWeek(), today.addWeeks(1).endOfWeek())) { // anything after saturday in the next week has "Next" prefix
      return date.format("Next %A"); // just show the date
    } else {
      return date.format("%a, %b {d}, %Y");
    }
  }
});

// String

// Custom Pluralizations
Sugar.String.addPlural("is", "are");

Sugar.Date.defineInstance({
  validateNumber: function(string) {
    // is a valid number
    return true;
  },
  validateInteger: function(string) {
    // is an integer
    return true;
  },
  validateDate: function(string) {
    // is a valid date
    return true;
  },
  validatePresent: function(string) {}
});

// not blank
Sugar.Object.defineInstance({
  toJSON: function(obj) {
    return JSON.stringify(obj, null, 2);
  }
});

module.exports = Sugar;
