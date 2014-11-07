(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, $location, $anchorScroll, studentFactory) {

    // Define variables for carot symbol flip for sorting
    $scope.showcaretStudent = false;
    $scope.showcaretPoints = false;
    $scope.showcaretLastPoint = false;
    $scope.showcaretPercentile = false;
    $scope.showcaretShare = false;

    // Define variables that deal with filling the EI
    $scope.showStudents = [];
    $scope.studentPercentile = 0;

    $scope.user = {
      choice: true
    };

    $scope.shareDataPass = function() {
      studentFactory.postStudentStatus($scope.currStudentID, $scope.user.choice).success(function() {
        $scope.currStudent.share = $scope.user.choice;
        $scope.currStudent.has_answered_share_question = true;
      });
    };

    var parseStudents = function(results) {
      $scope.people = results.students;
      $scope.currStudent = results.current_canvas_user;
      $scope.currStudentID = $scope.currStudent.canvas_user_id;

      // Set the location.hash to the id of the element I want to scroll to
      // if ($location.path() === '/engagement_index_instructor') {
      //   $location.hash = false;
      // } else {
      //   $location.hash($scope.currStudent.id);
      // }

      // Loop through and remove all students that are not sharing score
      for (var i = $scope.people.length - 1; i >= 0; i--) {

        // Set current student to appropriate student in people array
        if ($scope.people[i].id === $scope.currStudent.canvas_user_id) {
          $scope.currStudentItem = $scope.people[i];
        }

        // Handle case where student IS sharing
        if ($scope.people[i].share === true || $scope.api.user.me.roles.instructor) {
          // If get here, means that the student chose to share EI score
          $scope.showStudents.push($scope.people[i]); // push shared student to showStudents array
        }

        // Handle row highlighting (only get here if student is sharing)
        if ($scope.people[i] === $scope.currStudentItem && !$scope.api.user.me.roles.instructor) {
          $scope.people[i].highlight = true;
        }
      }

      // Percentile calculation (based on formula below)
      for (var k = 0; k < $scope.people.length; k++) {
        var index = 0;
        $scope.scoreFreq = 1;
        $scope.scoreCount = 0;
        $scope.thisStudent = $scope.people[k];

        // Linear 'search' through array of students to find the score frequency and total count of scores less than current student's
        while (index < $scope.people.length) {

          // Always start at index 0; skip over itself
          if ($scope.thisStudent.id === $scope.people[index].id) {
            index++;
            continue;
          }
          // If score matches, update this student's score frequency
          if ($scope.thisStudent.points === $scope.people[index].points) {
            $scope.scoreFreq++;

          // If score is less, update this student's score count (total number of scores that are less than his/hers)
          } else if ($scope.people[index].points < $scope.thisStudent.points) {
            $scope.scoreCount++;
          }
          index++;
        }

        // Calculate the percentile with rounding
        $scope.studentPercentile = (($scope.scoreCount + (0.5 * $scope.scoreFreq)) / $scope.people.length) * 100;
        $scope.people[k].studentPercentile = Math.round($scope.studentPercentile) + '%';
      }

      // Default Sort
      $scope.predicate = 'points';
    };

    var userWatch = $scope.$watch('api.user.me.canvas_user_id', function(canvasUserId) {
      if (canvasUserId) {

        // Get students
        studentFactory.getStudents().success(parseStudents);

        // Make sure to cancel the watch
        userWatch();
      }
    });

  });

})(window.angular);
