(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, studentFactory) {

    $scope.shownote = true;
    $scope.showshare = true;
    $scope.showpoints = false;
    $scope.visibility = true;
    $scope.noshowStudents = []; //array that stores all students who are not sharing their score

    studentFactory.getStudents().
      success(function(results) {
        $scope.people = results.students;

        $scope.currStudent = $scope.people[0]; //simulating the first student in json file is the current user

        //Loop through and remove all students that are not sharing Engagement Index
        for (var i = $scope.people.length-1; i >= 0; i--) {
          if ($scope.people[i].share === 'NO') {
            $scope.people[i].points = '--';
            $scope.people[i].lastupdate = '--';
            $scope.studentToRemove = $scope.people[i];
            $scope.noshowStudents.push($scope.studentToRemove); //push not sharing students to new array
            $scope.people.splice($scope.people.indexOf($scope.studentToRemove), 1); //remove not sharing student
          }
        }

        // Default Sort
        $scope.predicate = 'points';
    });
  });

})(window.angular);
