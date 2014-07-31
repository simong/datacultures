(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexLandingPageController', function($scope) {

    $scope.score = 'yes'; //sets default radio button to select the 'yes' option

    $scope.redirectPage = function () {
      if ($scope.score === 'yes'){
        $scope.score = '/engagement_index_share';
        return($scope.score);
      } else if ($scope.score === 'no'){
        $scope.score = '/engagement_index';
        return($scope.score);
      }
    };
  });

})(window.angular);
