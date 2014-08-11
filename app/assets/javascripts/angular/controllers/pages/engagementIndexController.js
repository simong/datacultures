(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, $location, $anchorScroll, studentFactory) {

    // Define variables for carot symbol flip for sorting
    $scope.showcaretStudent = false;
    $scope.showcaretSection = false;
    $scope.showcaretPoints = false;
    $scope.showcaretLastPoint = false;
    $scope.showcaretPercentile = false;
    $scope.showcaretShare = false;

    // Define variables that deal with filling the EI
    $scope.showshare = true;
    $scope.showpoints = false;
    $scope.visibility = true;
    $scope.showStudents = [];
    $scope.noshowStudents = [];
    $scope.studentPoints = [];
    $scope.studentPercentile = 0;

    $scope.gotoBottom = function() {
      $anchorScroll();
    };

    // Get students
    studentFactory.getStudents().
      success(function(results) {
        $scope.people = results.students;
        $scope.currStudent = results.current_canvas_user;

        // Set the location.hash to the id of the element you wish to scroll to.
        if ($location.path() === '/engagement_index_instructor') {
          $location.hash = false;
        } else {
          $location.hash($scope.currStudent.id);
        }

        // Loop through and remove all students that are not sharing score
        for (var i = $scope.people.length - 1; i >= 0; i--) {

          // Set current student to appropriate student in people array
          if ($scope.people[i].id === $scope.currStudent.canvas_user_id){
            $scope.currStudent = $scope.people[i];
          }

          // Handle case where student IS sharing
          if ($scope.people[i].share === true) {
            $scope.showStudents.push($scope.people[i]); // push shared student to showStudents array
            $scope.studentPoints.push($scope.people[i].points); // push shared student points to array
          }

          // Handle case where student IS NOT sharing
          else if ($scope.people[i].share === false) {
            $scope.people[i].share = 'NO';

              if ($location.path() === '/engagement_index_instructor') {
                $scope.studentPoints.push($scope.people[i].points);
                continue;
              } else {
                $scope.studentToRemove = $scope.people[i];
                $scope.noshowStudents.push($scope.studentToRemove);
                $scope.studentPoints.push($scope.studentToRemove.points);
                $scope.people[i].highlight = !!($scope.people[i] === $scope.currStudent);
                continue;
              }
          }

          // Handle row highlighting (only get here if student is sharing)
          $scope.people[i].highlight = !!($scope.people[i] === $scope.currStudent);

          // If get here, means that the student chose to share EI score
          $scope.people[i].share = 'YES';
        }

        // Calculate percentile, then store it for each student
        $scope.studentPoints.sort();
        $scope.studentPoints.reverse();
        $scope.highestPointTotal = $scope.studentPoints[0];

        for (var k = 0; k < $scope.studentPoints.length; k++) {
          $scope.studentPercentile = ($scope.people[k].points / $scope.highestPointTotal) * 100;
          $scope.people[k].studentPercentile = Math.round($scope.studentPercentile) + '%';
        }

        // Default Sort
        if ($location.path() === '/engagement_index') {
          $scope.predicate = 'name';
          $scope.predicateUnshare = 'section';
        } else {
          $scope.predicate = 'points';
          $scope.predicateUnshare = 'section';
        }
      });

  });

})(window.angular);
