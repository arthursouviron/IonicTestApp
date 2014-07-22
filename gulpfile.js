var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
// var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var livereload = require('gulp-livereload');
var connect = require('gulp-connect');
var plumber = require('gulp-plumber');


var paths = {
  sass: ['./scss/**/*.scss','./www/lib/ionic/scss/**/*.scss'],
  coffee_app: ['app/coffee/app.coffee'],
  coffee_ctrl: ['app/coffee/controllers/*.coffee'],
  coffee_services: ['app/coffee/services/*.coffee'],
  html: ['app/templates/*.html']
};


gulp.task('sass', function() {
  gulp.src(paths.sass)
    .pipe(plumber())
    // .pipe(sass())
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(concat('style.css'))
    .pipe(gulp.dest('./www/css/'));
});

gulp.task('coffee', function(){
  gulp.src(paths.coffee_app)
  .pipe(plumber())
  .pipe(coffee({
    sourceMap: false
  }))
  .pipe(concat('app.js'))
  .pipe(gulp.dest('./www/js/'));

  gulp.src(paths.coffee_ctrl)
  .pipe(plumber())
  .pipe(coffee({
    sourceMap: false
  }))
  .pipe(concat('controllers.js'))
  .pipe(gulp.dest('./www/js/'));

  gulp.src(paths.coffee_services)
  .pipe(plumber())
  .pipe(coffee({
    sourceMap: false
  }))
  .pipe(concat('services.js'))
  .pipe(gulp.dest('./www/js/'));

});

gulp.task('html', function() {
  gulp.src(paths.html)
  .pipe(gulp.dest('./www/templates/'));
});



gulp.task('reload', function() {
  gulp.src('./www/*.html')
    .pipe(connect.reload());
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee_app, ['coffee']);
  gulp.watch(paths.coffee_ctrl, ['coffee']);
  gulp.watch(paths.coffee_services, ['coffee']);
  gulp.watch(paths.html, ['html']);
  gulp.watch(['www/**'], ['reload']);

});

gulp.task('connect', function() {
  connect.server({
    root: ['www'],
    livereload: true
  }); 
});

gulp.task('default', ['connect', 'watch']);


gulp.task('install', ['git-check'], function() {
  return bower.commands.install()
    .on('log', function(data) {
      gutil.log('bower', gutil.colors.cyan(data.id), data.message);
    });
});

gulp.task('git-check', function(done) {
  if (!sh.which('git')) {
    console.log(
      '  ' + gutil.colors.red('Git is not installed.'),
      '\n  Git, the version control system, is required to download Ionic.',
      '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
      '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
    );
    process.exit(1);
  }
  done();
});
