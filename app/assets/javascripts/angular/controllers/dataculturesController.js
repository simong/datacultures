(function(window, angular) {
  'use strict';

  /**
   * Datacultures main controller
   */
  angular.module('datacultures.controllers').controller('DataculturesController', function($rootScope, apiService) {

    // Expose the API service
    $rootScope.api = apiService;

    $rootScope.$on('$routeChangeSuccess', function() {
      apiService.user.handleRouteChange();
    });

  });

})(window, window.angular);
