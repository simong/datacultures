(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('assignmentService', function(assignmentFactory, $q) {

    var assignments = null;

    /**
     * Get all assignments in the current course. The items will only be retrieved once
     *
     * @return {Promise<Assignment[]>}            Promise returning all assignments in the current course
     */
    var getAssignments = function() {
      var deferred = $q.defer();
      // When the assignments have already been retreived, we return
      // them from cache
      if (!assignments) {
        assignmentFactory.getAssignments().success(function(data) {
          // Cache the list of assignments
          assignments = data;
          deferred.resolve(assignments);
        });
      } else {
        deferred.resolve(assignments);
      }
      return deferred.promise;
    };

    return {
      getAssignments: getAssignments
    };

  });

}(window.angular));
