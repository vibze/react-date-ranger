var gulp = require('gulp');
var gutil = require('gulp-util');
var cjsx = require('gulp-cjsx');
var sass = require('gulp-sass');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');

gulp.task('dist', function(){
    gulp.src('./src/**/*.cjsx')
      .pipe(cjsx({bare: true}).on('error', gutil.log))
      .pipe(gulp.dest('./dist/'))
});

gulp.task('dist-browserify', function(){
    gulp.src('./src/main.coffee', {read: false})
      .pipe(browserify({
          transform: ['coffee-reactify'],
          extensions: ['.coffee', '.cjsx']
      }))
      .on('error', console.log.bind(console))
      .pipe(rename('main.js'))
      .pipe(gulp.dest('./dist/'))
});

gulp.task('sass', function(){
    gulp.src('./src/styles/main.sass')
      .pipe(sass().on('error', sass.logError))
      .pipe(gulp.dest('./dist'))
})

gulp.task('watch', function(){
    gulp.watch('./src/**/*.cjsx', ['dist']);
    gulp.watch('./src/**/*.cjsx', ['dist-browserify']);
    gulp.watch('./src/**/*.sass', ['sass']);
});
