
(function(angular) {

  'use strict';

  /**
   * Assignment Factory - Retrieve all assignments in the current course
   */
  angular.module('datacultures.factories').factory('assignmentFactory', function($http) {

    /**
     * Get all assignments in the current course
     *
     * @return {Promise<Assignment[]>}      $http promise returning all assignments in the current course
     */
    var getAssignments = function() {
      return $http.get('/api/v1/assignments');
    };

    return {
      getAssignments: getAssignments
    };

  });

}(window.angular));
