/**
 * Set the analytics configuration
 */
(function(angular) {

  'use strict';

  angular.module('datacultures.config').config(function($analyticsProvider) {

    // Disable automatic page view tracking
    $analyticsProvider.virtualPageviews(false);

  });
})(window.angular);
