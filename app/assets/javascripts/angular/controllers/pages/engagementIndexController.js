(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, studentFactory, $location) {

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
    $scope.noshowStudents = []; // array storing students who are not sharing their score
    $scope.studentPoints = [];
    $scope.studentPercentile = 0;

    // Call getStudents() from EI factory to get students
    studentFactory.getStudents().
      success(function(results) {
        $scope.people = results.students; // get from ruby controller
        $scope.currentStudentID = results.current_canvas_user_id; // get from ruby controller
        $scope.currStudent = $scope.people[$scope.currentStudentID];
        $scope.shareStatus = $scope.currStudent.share;

        alert($scope.currStudent.id);

        // For unshare view
        if ($location.path() === '/engagement_index') {
          $scope.currStudent.share = 'NO';
        }

        // Loop through and remove all students that are not sharing Engagement Index
        for (var i = $scope.people.length-1; i >= 0; i--) {
        // for (var i=0; i <$scope.people.length; i++) {
          if ($scope.people[i].share === true) {
            // $scope.people[i].share = 'YES';
            $scope.showStudents.push($scope.people[i]); //push shared student to showStudents array
            $scope.studentPoints.push($scope.people[i].points); //push shared student points to array
          }

          if ($scope.people[i].share === false) {
            $scope.people[i].share = 'NO';
              if ($location.path() === '/engagement_index_instructor') {
                continue;
              } else {
                $scope.studentToRemove = $scope.people[i]; // store "to be removed" into variable
                $scope.noshowStudents.push($scope.studentToRemove); // push not sharing students to new array
                $scope.studentPoints.push($scope.studentToRemove.points);
                // $scope.people.splice($scope.people.indexOf($scope.studentToRemove), 1); // remove not sharing student
                continue;
              }
          }

          // Handle row highlighting
          if ($scope.people[i] === $scope.currStudent) {
            $scope.people[i].highlight = true;
          } else {
            $scope.people[i].highlight = false;
          }

          $scope.people[i].share = 'YES'; // if get here, means that the student chose to share EI score
        }

        // Calculate percentile, then store it for each student
        $scope.studentPoints.sort();
        $scope.studentPoints.reverse();
        $scope.highestPointTotal = $scope.studentPoints[0];

        for (var k=0; k<$scope.studentPoints.length; k++) {
          $scope.studentPercentile = ($scope.people[k].points/$scope.highestPointTotal)*100;
          $scope.people[k].studentPercentile = Math.round($scope.studentPercentile) + '%';
        }

        // Send current student's share status to database
        studentFactory.postStudentStatus($scope.currentStudentID, $scope.shareStatus).
          success(function() {}).
          error(function() {
            window.alert('Check your internet connection, status was not pushed');
          });



        // Default Sort
        $scope.predicate = 'points';
        $scope.predicateUnshare = 'section';


      });

  });

})(window.angular);
