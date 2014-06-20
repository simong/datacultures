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
    when('/leaderboard', {
      templateUrl: 'leaderboard.html'
    }).
    when('/canvas/embedded/leaderboard', {
      templateUrl: 'leaderboard.html'
    }).
    // Redirect to a 404 page
    otherwise({
      templateUrl: '404.html'
      // controller: 'ErrorController',
      // isPublic: true
    });

  });

})(window.angular);
