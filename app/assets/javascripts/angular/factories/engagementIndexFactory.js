(function(angular) {

  'use strict';

  /**
   * Roster Factory - get data from the roster API
   * @param {Object} $http The $http service from Angular
   */
  angular.module('datacultures.factories').factory('studentFactory', function($http) {

    var getStudents = function() {
      var url = '/api/v1/engagement_index/data';
      return $http.get(url);
    };

    return {
      getStudents: getStudents
    };

  });

}(window.angular));
