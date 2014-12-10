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
    // Redirect to a 404 page
    otherwise({
      templateUrl: '404.html'
    });

  });

})(window.angular);
