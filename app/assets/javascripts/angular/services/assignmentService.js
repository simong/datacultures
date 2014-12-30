(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('assignmentService', function(assignmentFactory) {

    var assignments = null;

    /**
     * Get all assignments in the current course. The items will only be retrieved once
     *
     * @param  {Function}       callback          Standard callback function
     * @param  {Assignment[]}   callback.items    The retrieved assignments
     */
    var getAssignments = function(callback) {
      // When the assignments have already been retreived, we return
      // them from cache
      if (!assignments) {
        assignmentFactory.getAssignments().success(function(data) {
          // Cache the list of assignments
          assignments = data;
          return callback(assignments);
        });
      } else {
        return callback(assignments);
      }
    };


    return {
      getAssignments: getAssignments
    };

  });

}(window.angular));
