(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexLandingPageController', function($scope, $http, studentFactory) {

    $scope.choice = false;

    $scope.redirectPage = function () {
      if ($scope.choice === true){
        $scope.shareDataPass();
        return ('/engagement_index_share');
      } else if ($scope.choice === false) {
        $scope.shareDataPass();
        return ('/engagement_index');
      }
    };

    $scope.shareDataPass = function () {
      studentFactory.getStudents().
        success(function(results) {

        var currentStudentID = results.current_canvas_user_id;

        studentFactory.postStudentStatus(currentStudentID, $scope.choice).
        success(function() {
          window.alert('Successfully passed data to backend');
        }).
        error(function() {
          window.alert('Check your internet connection, status was not pushed');
        });
      });
    };






  });

})(window.angular);
