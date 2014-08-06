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
    when('/engagement_index_instructor', {
      templateUrl: 'engagement_index_instructor.html'
    }).
    when('/canvas/embedded/engagement_index_instructor', {
      templateUrl: 'engagement_index_instructor.html'
    }).
    when('/engagement_index_share', {
      templateUrl: 'engagement_index_share.html'
    }).
    when('/canvas/embedded/engagement_index_share', {
      templateUrl: 'engagement_index_share.html'
    }).
    when('/engagement_index_landing_page', {
      templateUrl: 'engagement_index_landing_page.html'
    }).
    when('/canvas/embedded/engagement_index_landing_page', {
      templateUrl: 'engagement_index_landing_page.html'
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
      // controller: 'ErrorController',
      // isPublic: true
    });

  });

})(window.angular);
