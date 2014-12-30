(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function(engagementIndexFactory, userService, utilService, $scope) {

    // Default sort
    $scope.sortBy = 'points';
    $scope.reverse = false;

    /**
     * Get the students in the engagement index and their engagement
     * index points
     */
    var getEngagementIndexList = function() {
      engagementIndexFactory.getEngagementIndexList().success(parseEngagementIndexList);
    };

    /**
     * Prepare the list of students in the engagement index for rendering
     */
    var parseEngagementIndexList = function(results) {
      $scope.people = results.students;
      $scope.currStudent = results.current_canvas_user;

      for (var i = $scope.people.length - 1; i >= 0; i--) {
        // Set current student to appropriate student in engagement index list
        if ($scope.people[i].id === $scope.currStudent.canvas_user_id) {
          $scope.currStudentItem = $scope.people[i];
          // Highlight the current user
          $scope.people[i].highlight = true;
        }
      }

      // Resize the BasicLTI iFrame
      utilService.resizeIFrame();
    };

    /**
     * Change the sorting field and/or sorting direction when one of the
     * engagement list headers is clicked
     *
     * @param  {String}     sortBy            The name of the field to sort by
     */
    $scope.changeEngagementIndexSort = function(sortBy) {
      $scope.sortBy = sortBy;
      $scope.reverse = !$scope.reverse;
    };

    /**
     * Store whether the current student's engagement index points should be
     * shared with the entire class
     */
    $scope.setEngagementIndexStatus = function() {
      engagementIndexFactory.setEngagementIndexStatus($scope.currStudent.canvas_user_id, $scope.currStudent.share).success(function() {
        $scope.currStudent.has_answered_share_question = true;
        getEngagementIndexList();
      });
    };

    // Expose the iFrame resize function to allow the window to resized
    // when the sharing option is changed
    $scope.resizeIFrame =  utilService.resizeIFrame;

    /**
     * Get the detailed information about the current user and load the students
     * in the engagement index
     */
    userService.getMe(function(me) {
      $scope.me = me;
      getEngagementIndexList();
    });

  });

})(window.angular);
