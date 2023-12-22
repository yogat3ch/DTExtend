module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
      pkg: grunt.file.readJSON('package.json'),
      concat: {
        combine: {
            src: [
                "inst/srcjs/global_fns.js",
                "inst/srcjs/dtextend.js"
            ],
            dest: 'inst/srcjs/combined.js'
        }
      },
      uglify: {
        options: {
          banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        },
        build: {
          src: 'inst/srcjs/combined.js',
          dest: 'inst/srcjs/<%= pkg.name %>.min.js'
        }
      }
    });
  
    grunt.loadNpmTasks('grunt-contrib-concat');
    // Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify');
  
    // Default task(s).
    grunt.registerTask('default', ['uglify']);
  
  };