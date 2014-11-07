(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(assignmentsFactory, galleryFactory, userInfoFactory, $scope, $routeParams) {

    $scope.itemId = $routeParams.itemId;

    $scope.refreshSubmissions = function() {
      return galleryFactory.getSubmissions().success(function(results) {
        $scope.items = results.files;
      });
    };

    userInfoFactory.me().success(function(data) {
      $scope.currentUser = data;
    }).then($scope.refreshSubmissions);

    assignmentsFactory.getAssignments().success(function(data) {
      $scope.assignments = data;
    });

    // FILTER

    $scope.typeOptions = [
      {
        display: 'Image',
        value: 'image'
      },
      {
        display: 'Video',
        value: 'video'
      }
    ];

    // Sorting
    $scope.sortOptions = [
      {
        display: 'Date',
        type: 'date'
      },
      {
        display: 'Comments',
        type: 'comments.length'
      },
      {
        display: 'Likes',
        type: 'likes'
      },
      {
        display: 'Dislikes',
        type: 'dislikes'
      }
    ];

    // Default should be the first one (date)
    $scope.sortOption = $scope.sortOptions[0];

  });

})(window.angular);
