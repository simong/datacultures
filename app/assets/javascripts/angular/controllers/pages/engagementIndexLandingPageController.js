(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('EngagementIndexLandingPageController', function($scope) {

    $scope.score = 'yes'; //sets default radio button to select the 'yes' option

    $scope.redirectPage = function () {
      if ($scope.score === 'yes'){
        return '/engagement_index_share';
      } else if ($scope.score === 'no'){
        return('/engagement_index');
      }
    };
  });

})(window.angular);
