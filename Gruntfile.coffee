module.exports = (grunt) ->
 
  lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
 
  mountFolder = (connect, dir) ->
    connect.static(require("path").resolve(dir))
 
  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks)
 
  # config paths
  appDir     = "app"
 
  imgDir     = "#{appDir}/images"
  jsDir      = "#{appDir}/scripts"
  cssDir     = "#{appDir}/styles"
  sassDir    = "#{appDir}/sass"
  fontsDir   = "#{appDir}/fonts"
  bowerDir   = "#{jsDir}/vendors"
 
  grunt.initConfig
    clean:
      server: "#{cssDir}{,*/}*.css"
 
    watch:
      compass:
        files: ["#{sassDir}{,*/}*.{scss,sass}"]
        tasks: ["compass"]
 
      livereload:
        files: [
          "#{appDir}{,*/}*.html"
          "#{cssDir}{,*/}*.css"
          "#{jsDir}{,*/}*.js"
          "#{imgDir}{,*/}*.{png,jpg,jpeg}"
          "#{fontsDir}{,*/}*.*"
        ]
        tasks: ["livereload"]
 
    connect:
      livereload:
        options:
          port: 9000
          # Change this to '0.0.0.0' to access the server from outside.
          hostname: "localhost"
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder(connect, appDir)
            ]
 
    open:
      server:
        url: "http://localhost:<%= connect.livereload.options.port %>"
 
    compass:
      options:
        sassDir: sassDir
 
      server:
        options:
          cssDir: cssDir
          imagesDir: imgDir
          javascriptsDir: jsDir
          fontsDir: fontsDir
          importPath: bowerDir
          relativeAssets: true
          debugInfo: false,
          noLineComments: true
 
  grunt.renameTask "regarde", "watch"
 
  grunt.registerTask "server", [
    "clean:server"
    "compass:server"
    "livereload-start"
    "connect:livereload"
    "open"
    "watch"
  ]
 
  grunt.registerTask "build", [
    "clean:server"
    "compass:server"
    "livereload-start"
    "connect:livereload"
    "watch"
  ]
