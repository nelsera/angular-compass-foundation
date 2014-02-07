module.exports = function (grunt) {
  
  var mountFolder = function (connect, dir) {
    return connect["static"](require("path").resolve(dir));
  };
  
  require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks);
  
  var appDir      = "app",
      imgDir      = appDir + "/images",
      jsDir       = appDir + "/scripts",
      cssDir      = appDir + "/styles",
      sassDir     = appDir + "/sass",
      fontsDir    = appDir + "/fonts",
      bowerDir    = appDir + "/bower_components";
  
  grunt.initConfig({
    clean: {
      server: cssDir + "{,*/}*.css"
    },
    watch: {
      gruntfile: {
        files: ["Gruntfile.js"]
      },
      compass: {
        files: [sassDir + "{,*/}*.{scss,sass}"],
        tasks: ["compass"]
      },
      livereload: {
        files: [appDir + "{,*/}*.html", cssDir + "{,*/}*.css", jsDir + "{,*/}*.js", imgDir + "{,*/}*.{png,jpg,jpeg}", fontsDir + "{,*/}*.*"],
        tasks: ["livereload"]
      }
    },
    connect: {
      livereload: {
        options: {
          port: 9000,
          hostname: "localhost",
          middleware: function(connect) {
            return [require("grunt-contrib-livereload/lib/utils").livereloadSnippet, mountFolder(connect, appDir)];
          }
        }
      }
    },
    open: {
      server: {
        url: "http://localhost:<%= connect.livereload.options.port %>"
      }
    },
    compass: {
      options: {
        sassDir: sassDir
      },
      server: {
        options: {
          cssDir: cssDir,
          imagesDir: imgDir,
          specify: [sassDir + "/main.scss"],
          javascriptsDir: jsDir,
          fontsDir: fontsDir,
          importPath: bowerDir,
          relativeAssets: true,
          debugInfo: false,
          noLineComments: true
        }
      }
    }
  });
  
  grunt.renameTask("regarde", "watch");
  grunt.registerTask("server", ["clean:server", "compass:server", "livereload-start", "connect:livereload", "open", "watch"]);
  
  return grunt.registerTask("build", ["clean:server", "compass:server", "livereload-start", "connect:livereload", "watch"]);
};
