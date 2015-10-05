coverage = require 'browserify-istanbul'

module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ''


    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['browserify', 'jasmine']


    # list of files / patterns to load in the browser
    files: [
        'http://code.jquery.com/jquery-2.1.4.js'
        'index.coffee'
        'spec_helper/compileDirective.coffee'
        'node_modules/angular-mocks/angular-mocks.js'
        'themis_components/**/*.mock.coffee'
        'themis_components/**/*.spec.coffee'
        'spec_helper/compileDirective.coffee'
        {
            pattern: 'themis_components/**/*.{directive,service}.coffee'
            watched: true
            included: false
            served: false
        }
    ]


    # list of files to exclude
    exclude: [
    ]


    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
        'index.coffee' : ['browserify']
        'themis_components/**/*.mock.coffee' : ['coffee']
        'themis_components/**/*.spec.coffee' : ['coffee']
        'spec_helper/*.coffee' : ['coffee']
    }


    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress', 'coverage', 'notify']


    # web server port
    port: 9876


    # enable / disable colors in the output (reporters and logs)
    colors: true


    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO


    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true


    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS']


    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false

    browserify:
        debug: true
        watch: true
        extensions: ['.coffee']
        # fix for dbl karma compiling of coffeescript
        # https://github.com/nikku/karma-browserify/issues/130
        postFilter: (id, file, pkg) ->
            if pkg.name == "lib-ThemisUI"
                pkg.browserify.transform = []
            true
        transform: ['coffeeify']
        configure: (bundle) ->
            bundle.transform coverage
                ignore: [
                  'themis_components/**/*.mock.coffee'
                  'themis_components/**/*.spec.coffee'
                ]
                defaultIgnore: true

    coverageReporter:
      type : 'text'
