(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(assignmentFactory, galleryFactory, galleryService, userInfoFactory, viewFactory, $routeParams, $scope) {

    $scope.selectedItemId = $routeParams.selectedItemId;

    $scope.options = galleryService.options;

    $scope.resetOptions = function() {
      galleryService.resetOptions();
      galleryService.setDefaultSort();
    };

    $scope.refreshSubmissions = function() {
      return galleryFactory.getSubmissions().success(function(results) {
        $scope.items = results.files;
      });
    };

    $scope.incrementViews = function(item) {
      viewFactory.increment({
        gallery_id: item.id
      }).success(function() {
        item.views++;
      });
    };

    var searchAuthor = function(authorName) {
      $scope.resetOptions();
      galleryService.options.search.author = authorName;
    };

    if ($routeParams.authorName) {
      searchAuthor($routeParams.authorName);
    }

    userInfoFactory.me().success(function(data) {
      $scope.currentUser = data;
    }).then($scope.refreshSubmissions);

    if (!galleryService.options.assignments) {
      assignmentFactory.getAssignments().success(function(data) {
        galleryService.options.assignments = data;
      });
    }

  });

})(window.angular);
