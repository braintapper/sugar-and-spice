SugarAndSpice = require "../index.js"
SugarAndSpice.extend()

console.log "Date.create"
console.log Date.create()

console.log "Namify"
console.log ["Joe","Q","public"].toName()

console.log ["Joe","Q","public"].toFamilyName()

console.log "Date SID"
console.log Date.create("yesterday").toDateId()

console.log "Date Diff"
console.log Date.create("last Friday").diffDays(Date.create())


console.log "Date Diff"
console.log Date.create().diffDays(Date.create("last Friday"))


console.log "isBetween"
console.log (2).isBetween(5,4)
console.log (2).isBetween(5,4)

console.log "Pluralize is"
console.log "is".pluralize()

console.log "Quarter"
console.log Date.create().getQuarterNumber()

console.log "Ordinal Week"
console.log Date.create().getOrdinalWeek()

console.log "Ordinal Week NUmber"
console.log Date.create().getOrdinalWeekNumber()

console.log "Pluck"
testArray = [
  {
    id: 1
    name: "A"
    val: 1
  }
  {
    id: 2
    name: "B"
    val: 2
  }
  {
    id: 3
    name: "C"
    val: 3
  }
]

console.log testArray.pluck("name","val")
console.log testArray.pluck("name")

console.log "Week Calendar:"
console.log Date.create().toWeekCalendar()
console.log "Month Calendar:"
console.log Date.create().toMonthCalendar()
