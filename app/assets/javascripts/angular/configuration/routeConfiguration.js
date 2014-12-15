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
    when('/canvas/embedded/engagement_index', {
      templateUrl: 'engagement_index.html'
    }).
    when('/canvas/embedded/gallery', {
      templateUrl: 'gallery.html'
    }).
    when('/canvas/embedded/gallery/item/:selectedItemId', {
      templateUrl: 'gallery.html'
    }).
    when('/canvas/embedded/gallery/author/:authorName', {
      templateUrl: 'gallery.html'
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
