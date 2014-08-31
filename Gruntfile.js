'use strict';

module.exports = function (grunt) {
    require('load-grunt-tasks')(grunt);

    var config = {
        src: 'priv',
        dist: 'public'
    };
    grunt.initConfig({
        config: config,
        watch: {
            gruntfile: {
                files: ['Gruntfile.js']
            },

            sass: {
                files: ['priv/assets/home.scss'],
                tasks: ['sass:server']
            }
        },

        // Compiles Sass to CSS and generates necessary files if requested
        sass: {
            server: {
                files: [{
                    expand: true,
                    cwd: 'priv/assets',
                    src: ['*.scss'],
                    dest: 'public/styles',
                    ext: '.css'
                }]
            }
        }
    });

    grunt.registerTask('serve', function (target) {
        grunt.task.run([
            'watch'
        ]);
    });
    grunt.registerTask('default', ['serve']);
};
