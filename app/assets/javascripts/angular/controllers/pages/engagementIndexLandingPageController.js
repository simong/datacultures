(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexLandingPageController', function($scope) {

    $scope.choice = false;

    $scope.redirectPage = function () {
      if ($scope.choice === true){
        return ('/engagement_index_share');
      } else if ($scope.choice === false) {
        return ('/engagement_index');
      }
    };
  });

})(window.angular);
