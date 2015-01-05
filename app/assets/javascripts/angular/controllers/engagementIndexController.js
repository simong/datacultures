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
      $scope.students = results.students;
      $scope.currStudent = results.current_canvas_user;

      // If the user hasn't yet decided whether to share their engagement
      // points with the entire class, default the setting to `true`
      if (!$scope.currStudent.has_answered_share_question) {
        $scope.currStudent.share = true;
      }

      for (var i = $scope.students.length - 1; i >= 0; i--) {
        // Set the current student to the appropriate student in the engagement index list
        var student = $scope.students[i];
        if (student.id === $scope.currStudent.canvas_user_id) {
          $scope.currStudentItem = student;
          // Highlight the current user
          student.highlight = true;
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
     * shared with the entire class. This function will only be used for the
     * initial save
     */
    $scope.saveEngagementIndexStatus = function() {
      engagementIndexFactory.setEngagementIndexStatus($scope.currStudent.canvas_user_id, $scope.currStudent.share).success(function() {
        $scope.currStudent.has_answered_share_question = true;
        getEngagementIndexList();
      });
    };

    /**
     * Change whether the current student's engagement index should be shared
     * with the entire class. This will be executed every time the corresponding
     * checkbox is changed following the initial save
     */
    $scope.changeEngagementIndexStatus = function() {
      // Only save the new setting straight away when the initial
      // save has already happened
      if ($scope.currStudent.has_answered_share_question) {
        engagementIndexFactory.setEngagementIndexStatus($scope.currStudent.canvas_user_id, $scope.currStudent.share).success(getEngagementIndexList);
      }
    };

    /**
     * Get the detailed information about the current user and load the students
     * in the engagement index
     */
    userService.getMe().then(function(me) {
      $scope.me = me;
      getEngagementIndexList();
    });

  });

})(window.angular);
