// create the module and points it pointssystemApp

(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('PointsConfigurationController', function($http, $scope) {

    $http.get('/api/v1/points_configuration').success(function(activities) {
      angular.extend($scope, activities);

      $scope.pointTotalArray = [];

      // Sort $scope.activities by id (so when push to pointTotalArray, the activities match up with the points)
      $scope.activities.sort(function(obj1, obj2) {
        return obj1.id - obj2.id;
      });

      // Fill the points configuration table activities with their respective points (regardless of active or inactive)
      for (var i = 0; i < $scope.activities.length; i++) {
        $scope.pointTotalArray.push($scope.activities[i].points);
      }
    });

    $scope.removedTable = false;
    $scope.removedActivitiesList = [];
    var master = {};
    $scope.status = 'uneditable';
    $scope.showAction = false;

    $scope.save = function() {
      $scope.status = 'uneditable';
      $scope.showAction = false;
      for (var i = 0; i < $scope.pointTotalArray.length; i++) {
        if ($scope.pointTotalArray[i] === '' || $scope.pointTotalArray[i] === null) {
          $scope.activities[i].points = 0;
        } else {
          $scope.activities[i].points = $scope.pointTotalArray[i];
        }
      }
      $http.put('/api/v1/points_configuration/update', $scope.activities).
        success(function() {}).
        error(function() {
          window.alert('The Data did not send. Check your internet connection');
        });
    };

    $scope.cancel = function() {
      $scope.status = 'uneditable';
      $scope.showAction = false;
    };

    $scope.edit = function() {
      $scope.status = 'editable';
      $scope.showAction = true;
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
