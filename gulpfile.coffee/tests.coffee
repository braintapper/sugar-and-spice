gulp   = require('gulp')
coffee = require("gulp-coffee")


# set the compilation order of the client
sourcePaths = ["src/tests/**/*.coffee"]
module.exports = (cb)->


  destinationPath = "./tests"


  #stream = gulp.src(sourcePaths).pipe(plumber()).pipe(coffee({bare:true})).pipe(concat("application.js")).pipe(gulp.dest(destinationPath)) #.pipe(jsmin()).pipe(gulp.dest(destinationPath))

  # note if you change the order, make sure you fix electron-prebuild

  stream = gulp.src(sourcePaths)
  .pipe(coffee({bare:true}))
  .pipe(gulp.dest(destinationPath)) #.pipe(jsmin()).pipe(gulp.dest(destinationPath))
  stream.on 'end', ()->
    console.log "Source compiled"
    cb()

module.exports.watch = sourcePaths
module.exports.displayName = "tests"
