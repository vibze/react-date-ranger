var browserify = require('browserify');
var source = require('vinyl-source-stream');
var gulp = require('gulp');
var gutil = require('gulp-util');
var sass = require('gulp-sass');
var rename = require('gulp-rename');
var clean = require('gulp-clean');
var cjsx = require('gulp-cjsx');


gulp.task('dist:clean', function(){
    return gulp.src('./dist/*')
      .pipe(clean());
});

gulp.task('dist:compile', ['dist:clean'], function(){
    return gulp.src(['src/**/*.cjsx', 'src/**/*.coffee', '!src/__tests__/*'])
      .pipe(cjsx({bare: true}).on('error', gutil.log))
      .pipe(gulp.dest('dist/'));
});

gulp.task('demo:js:compile', ['dist:compile'], function(){
  return browserify('dist/standalone.js')
    .bundle()
    .pipe(source('date-ranger-standalone.js'))
    .pipe(gulp.dest('demo/js/'));
});

gulp.task('demo:css:compile', function(){
    gulp.src('src/styles/main.sass')
      .pipe(sass().on('error', sass.logError))
      .pipe(rename('date-ranger.css'))
      .pipe(gulp.dest('demo/css/'));

    gulp.src('src/styles/theme.sass')
      .pipe(sass().on('error', sass.logError))
      .pipe(rename('date-ranger-theme.css'))
      .pipe(gulp.dest('demo/css/'));
});

gulp.task('demo:compile', ['demo:js:compile', 'demo:css:compile'])

gulp.task('watch', function(){
    gulp.watch('./src/**/*.cjsx', ['dist:compile']);
    gulp.watch('./src/**/*.cjsx', ['demo-compile']);
    gulp.watch('./src/**/*.sass', ['demo-sass']);
});
