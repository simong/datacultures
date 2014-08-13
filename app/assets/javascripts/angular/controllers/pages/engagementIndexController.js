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
        if ($location.path() === '/engagement_index_share') {
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
        // Percentile Rank:
        // ((Count of all scores less than score of interest) + 0.5(frequency of scores of interest) / # people in array) * 100
        // ($scopeCount + 0.5($scope.scoreFreq) / $scope.studentPoints.length ) * 100

        // Array: [8,8,8,8,7,7,6,6,5,4,3,3,2,1,1,1,0,-1,-1,-1]
        // First iteration: 8
        // scoreFreq should = 4
        // scoreCount should = 16


        // Thought process here...
        // $scope.showStudents = includes all the students who decided to share score
        // $scope.noshowStudents = includes all the students who decided to NOT share score
        // $scope.studentPoints = includes all the points of ALL the students
        // $scope.people = includes ALL of the students
        //
        // If I want to calculate the percentile rank, I want to cover for ALL students
        // This means I would have to loop through $scope.people, access each of their points
        for (var k = 0; k < $scope.people.length; k++) {
          var index = 0;
          $scope.scoreFreq = 1;
          $scope.scoreCount = 0;

          $scope.thisStudent = $scope.people[k];
          $scope.compareStudent = $scope.people[index];

          while (index < $scope.people.length) {
            if ($scope.thisStudent.id === $scope.people[index].id) {
              index++;
              continue;
            }
            if ($scope.thisStudent.points === $scope.people[index].points) {
              $scope.scoreFreq++;
            } else if ($scope.people[index].points < $scope.thisStudent.points) {
              $scope.scoreCount++;
            }
            index++;
          }
          $scope.studentPercentile = (($scope.scoreCount + (0.5 * $scope.scoreFreq)) / $scope.people.length) * 100;
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
