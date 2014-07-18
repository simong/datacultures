(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, studentFactory) {

    $scope.shownote = true;
    $scope.showshare = true;
    $scope.showpoints = false;
    $scope.visibility = true;
    $scope.noshowStudents = [];

    studentFactory.getStudents().
      success(function(results) {
        $scope.people = results.students;

        $scope.currStudent = $scope.people[0];

        var len = $scope.people.length;

        //Loop through and remove all students that are not sharing Engagement Index
        for (var i = len-1; i >= 0; i--) {
          if ($scope.people[i].share === 'NO') {
            $scope.people[i].points = '--';
            $scope.people[i].lastupdate = '--';

            $scope.studentToRemove = $scope.people[i];
            $scope.noshowStudents.push($scope.studentToRemove); //push not sharing students to new array

            $scope.people.splice($scope.people.indexOf($scope.studentToRemove), 1);
          }
        }

        // Default Sort
        $scope.predicate = 'points';
    });

    // $scope.shareView = function (currentStudent) {
    //   $scope.people.push(currentStudent);
    //   $scope.showshare = false;
    //   $scope.shownote = false;
    //   $scope.showpoints = true;
    // };


    // $scope.unshareView = function (currentStudent) {
    //   $scope.people.splice($scope.people.indexOf(currentStudent), 1);
    //   $scope.showshare = true;
    //   $scope.shownote = true;
    //   $scope.showpoints = false;
    // };





  });

})(window.angular);
