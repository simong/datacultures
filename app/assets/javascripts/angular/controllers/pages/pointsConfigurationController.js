// create the module and points it pointssystemApp

(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('PointsConfigurationController', function($http, $scope) {
    $http.get('/dummy/json/activities.json').success(function(activities) {
      angular.extend($scope, activities);
    });

    $scope.removedTable = false;
    $scope.pointTotalArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    $scope.removedActivitiesList = [];
    var master = {};
    $scope.status = 'uneditable';

    $scope.save = function() {
      $scope.status = 'uneditable';
      for (var i = 0; i < $scope.pointTotalArray.length; i++) {
        if ($scope.pointTotalArray[i] === '' || $scope.pointTotalArray[i] === null) {
          $scope.activities[i].points = 0;
        } else {
          $scope.activities[i].points = $scope.pointTotalArray[i];
        }
      }
    };

    $scope.cancel = function() {
      $scope.status = 'uneditable';
    };

    $scope.edit = function() {
      $scope.status = 'editable';
    };

    $scope.deleteActivity = function(activity) {
      master = angular.copy(activity);
      $scope.removedTable = true;

      $scope.pointTotalArray.splice($scope.activities.indexOf(activity), 1); // remove from totalpoints array
      $scope.activities.splice($scope.activities.indexOf(activity), 1); // remove from JSON object

      $scope.removedActivitiesList.push(activity); // push onto removed activities list
    };

    $scope.update = function(activity) {
      master = angular.copy(activity);
      $scope.insertBack(activity, master);
      $scope.removedActivitiesList.splice($scope.removedActivitiesList.indexOf(activity), 1);
    };

    $scope.insertBack = function(activity, masterTask) {
      for (var i = 0; i<$scope.pointTotalArray.length; i++) {
        if (activity.id < $scope.activities[i].id) {
          $scope.pointTotalArray.splice(i, 0, masterTask.points);
          $scope.activities.splice(i, 0, masterTask);
          return;
        }
      }
      $scope.pointTotalArray.push(activity.points);
      $scope.activities.push(activity);
    };

  });

})(window.angular);
