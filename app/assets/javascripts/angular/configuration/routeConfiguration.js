/**
 * Configure the routes for DataCultures
 */
(function(angular) {

  'use strict';

  // Set the configuration
  angular.module('datacultures.config').config(function($routeProvider) {
    // List all the routes
    $routeProvider.when('/', {
      templateUrl: 'splash.html'
      // controller: 'SplashController',
      // isPublic: true
    }).
    when('/engagement_index', {
      templateUrl: 'engagement_index.html'
    }).
    when('/canvas/embedded/engagement_index', {
      templateUrl: 'engagement_index.html'
    }).
    when('/canvas/embedded/gallery', {
      templateUrl: 'gallery.html'
    }).
    when('/points_configuration', {
      templateUrl: 'points_configuration.html'
    }).
    when('/canvas/embedded/points_configuration', {
      templateUrl: 'points_configuration.html'
    }).
    when('/gallery', {
      templateUrl: 'gallery.html'
    }).
    when('/image:imageID', {
      templateUrl: 'load_image.html'
    }).
    when('/video:imageID', {
      templateUrl: 'load_video.html'
    }).
    // Redirect to a 404 page
    otherwise({
      templateUrl: '404.html'
      // controller: 'ErrorController',
      // isPublic: true
    });

  });

})(window.angular);
