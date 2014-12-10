(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, studentFactory) {

    // Define variables for carot symbol flip for sorting
    $scope.showcaretStudent = false;
    $scope.showcaretPoints = false;
    $scope.showcaretLastPoint = false;
    $scope.showcaretPercentile = false;
    $scope.showcaretShare = false;

    $scope.user = {
      choice: true
    };

    var getStudents = function() {
      studentFactory.getStudents().success(parseStudents);
    };

    $scope.shareDataPass = function() {
      studentFactory.postStudentStatus($scope.currStudent.canvas_user_id, $scope.user.choice).success(function() {
        $scope.currStudent.share = $scope.user.choice;
        $scope.currStudent.has_answered_share_question = true;
        getStudents();
      });
    };

    var parseStudents = function(results) {
      $scope.people = results.students;
      $scope.currStudent = results.current_canvas_user;

      if (results.current_canvas_user.has_answered_share_question) {
        $scope.user.choice = results.current_canvas_user.share;
      }

      // Loop through and remove all students that are not sharing score
      for (var i = $scope.people.length - 1; i >= 0; i--) {

        // Set current student to appropriate student in people array
        if ($scope.people[i].id === $scope.currStudent.canvas_user_id) {
          $scope.currStudentItem = $scope.people[i];
        }

        // Handle row highlighting (only get here if student is sharing)
        if ($scope.people[i] === $scope.currStudentItem && !$scope.api.user.me.roles.instructor) {
          $scope.people[i].highlight = true;
        }
      }

      // Default Sort
      $scope.predicate = 'points';
    };

    var userWatch = $scope.$watch('api.user.me.canvas_user_id', function(canvasUserId) {
      if (canvasUserId) {

        // Get students
        getStudents();

        // Make sure to cancel the watch
        userWatch();
      }
    });

  });

})(window.angular);
