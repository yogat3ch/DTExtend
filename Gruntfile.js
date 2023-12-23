module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
      pkg: grunt.file.readJSON('package.json'),
      
      watch: {
        scripts: {
          files: ['inst/srcjs/global_fns.js', 'inst/srcjs/dtextend.js'],
          tasks: ['default'],
          options: {
            spawn: false,
          },
        },
      },
      concat: {
        combine: {
            src: [
                "inst/srcjs/global_fns.js",
                "inst/srcjs/dtextend.js"
            ],
            dest: 'inst/srcjs/combined.js',
            options: {
                banner:  '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %> */\n',
              }
        }
      },
      uglify: {
        options: {
            compress: {
                drop_debugger: false
              },  
            banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %> */\n',
            mangle: {
              keep_fargs: true
            }
        },
        build: {
          src: 'inst/srcjs/combined.js',
          dest: 'inst/srcjs/<%= pkg.name %>.min.js'
        }
      }
    });
  
    // npm install grunt --save-dev
    // npm install grunt-contrib-watch --save-dev
    grunt.loadNpmTasks('grunt-contrib-watch');
    // npm install grunt-contrib-jshint --save-dev
    grunt.loadNpmTasks('grunt-contrib-jshint');
    // npm install grunt-contrib-concat --save-dev
    grunt.loadNpmTasks('grunt-contrib-concat');
    // npm install grunt-contrib-uglify --save-dev
    // Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify');
  
    // Default task(s).
    grunt.registerTask('default', ['concat','uglify']);
  
  };