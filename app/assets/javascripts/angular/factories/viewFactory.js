(function(angular) {

  'use strict';

  /**
   * View Factory
   * @param {Object} $http The $http service from Angular
   */
  angular.module('datacultures.factories').factory('viewFactory', function($http) {

    var increment = function(data) {
      var url = '/api/v1/views/';
      return $http.post(url, data);
    };

    return {
      increment: increment
    };

  });

}(window.angular));
