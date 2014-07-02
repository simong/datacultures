(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexController', function($scope, studentFactory) {

    studentFactory.getStudents().
      success(function(results) {
        $scope.people = results.students;

        $scope.$watch('searchQuery', function(oldValue, newValue) {
          $scope.selectStudent();
        });
        $scope.$watch('visibilityQuery', function(oldValue, newValue) {
          $scope.visibilitySearch();
        });
      });

    $scope.predicate = 'position'; // Default Sort

    $scope.returnRank = function(value) {
      var counter = 0;
      return counter;
    };

    // Updating Points
    $scope.searchQuery = '';
    $scope.searchIndex = '';
    $scope.searchResult = '';

    $scope.selectStudent = function() {
      for (var i = 0; i <= $scope.people.length; i++) {
        var isStudent = $scope.people[i];
        if (isStudent && $scope.people[i].name === $scope.searchQuery) {
          if ($scope.people[i].visibility === false) {
            $scope.searchResult = '';
            return;
          }
          $scope.searchIndex = i;
          $scope.searchResult = 'Student Found: ' + $scope.people[i].name;
          return;
        } else {
          $scope.searchResult = '';
        }
      }
    };

    $scope.add = function() {
      var i = 0;
      var isStudent = $scope.people[i];
      if (!isStudent || $scope.people[i].visibility === false) {
        $scope.searchResult = 'No Student Record';
      } else {
        $scope.people[$scope.searchIndex].points += parseInt($scope.numPoints, 10);
      }
    };

    $scope.subtract = function(value) {
      var i = 0;
      var isStudent = $scope.people[i];
      if (!isStudent || $scope.people[i].visibility === false) {
        $scope.searchResult = 'No Student Record';
      } else {
        $scope.people[$scope.searchIndex].points += -parseInt($scope.numPoints, 10);
      }
    };

    // Student Visibility
    $scope.visibilityQuery = '';
    $scope.visibilityIndex = '';
    $scope.visibilityResult = '';

    $scope.visibilitySearch = function() {
      for (var i = 0; i <= $scope.people.length; i++) {
        var isStudent = $scope.people[i];
        if (isStudent && $scope.people[i].name === $scope.visibilityQuery) {
          $scope.visibilityIndex = i;
          $scope.visibilityResult = 'Student Found: ' + $scope.people[i].name;
          return;
        } else {
          $scope.visibilityIndex = -1;
          $scope.visibilityResult = ' ';
        }
      }
    };

    $scope.optOut = function() {
      var i = 0;
      if (!$scope.people[i]) {
        $scope.visibilityResult = 'No Student Record';
      } else {
        $scope.people[i].visibility = false;
        $scope.visibilityResult = 'Student Removed From Database';
      }
    };

    $scope.optIn = function() {
      var i = 0;
      if (!$scope.people[i]) {
        $scope.visibilityResult = 'No Student Record';
      } else if ($scope.people[i].visibility === true) {
        $scope.visibilityResult = 'Student Already In Database';
      } else {
        $scope.people[i].visibility = true;
        $scope.visibilityResult = 'Student Added To Database';
      }
    };

  });

}(window.angular));
