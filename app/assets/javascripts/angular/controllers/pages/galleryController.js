(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(assignmentFactory, galleryFactory, galleryService, userInfoFactory, viewFactory, $routeParams, $scope) {

    $scope.selectedItemId = $routeParams.selectedItemId;
    $scope.options = galleryService.options;
    $scope.resetOptions = galleryService.resetOptions;

    /**
     * Refresh the gallery submissions
     */
    $scope.refreshSubmissions = function() {
      return galleryFactory.getSubmissions().success(function(results) {
        $scope.items = results.files;
      });
    };

    /**
     * Increment the number of views for a specific item
     */
    $scope.incrementViews = function(item) {
      viewFactory.increment({
        gallery_id: item.id
      }).success(function() {
        item.views++;
      });
    };

    /**
     * Search for an author's name
     */
    var searchAuthor = function(authorName) {
      $scope.resetOptions();
      galleryService.options.search.author = authorName;
    };

    if ($routeParams.authorName) {
      searchAuthor($routeParams.authorName);
    }

    /**
     * Get the current user & then get the gallery submissions.
     */
    userInfoFactory.me().success(function(data) {
      $scope.currentUser = data;
    }).then($scope.refreshSubmissions);

    /**
     * If we don't have any assignments yet, make sure to fetch them.
     */
    if (!galleryService.options.assignments) {
      assignmentFactory.getAssignments().success(function(data) {
        galleryService.options.assignments = data;
      });
    }

  });

})(window.angular);
