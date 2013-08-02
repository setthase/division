module.exports = (grunt) ->

  # Project configuration
  grunt.initConfig
    clean: ["lib/"]
    # Compile source files
    coffee :
      compile:
        files: [
          expand: true
          cwd: "./src"
          src: ["**/*.coffee"]
          dest: "./lib"
          ext: ".js"
        ]

  # Register tasks
  grunt.registerTask 'compile', ['coffee:compile']
  grunt.registerTask 'default', ['clean', 'compile']

  # Load dependencies
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
