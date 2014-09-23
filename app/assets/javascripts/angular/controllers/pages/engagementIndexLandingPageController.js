(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexLandingPageController', function($scope, $http, $rootScope, studentFactory) {

    $scope.choice = false;

    studentFactory.getStudents().
      success(function(results) {
        $scope.currStudent = results.current_canvas_user;
        $scope.currStudentID = $scope.currStudent.canvas_user_id;
      });

    $scope.redirectPage = function() {
      if ($scope.choice === true) {
        return ('/engagement_index_share');
      } else if ($scope.choice === false) {
        return ('/engagement_index');
      }
    };

    $scope.shareDataPass = function() {
      studentFactory.postStudentStatus($scope.currStudentID, $scope.choice).
        success(function() {
        }).
        error(function() {
          console.log('Check your internet connection, status was not pushed');
        });
    };
  });

})(window.angular);
