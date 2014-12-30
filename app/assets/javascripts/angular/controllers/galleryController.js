(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(assignmentService, galleryService, galleryItemFactory, userService, utilService, $routeParams, $scope) {

    $scope.selectedItemId = $routeParams.selectedItemId;
    $scope.sortAndFilter = galleryService.sortAndFilter;

    /**
     * Reset the sort and filtering options to the default values. This will
     * also ensure that the page is scrolled to the top when showing the items
     */
    $scope.resetSortAndFilter = function() {
      // Reset the cached scroll position to ensure the page is scrolled to the top
      galleryService.resetScrollPosition();
      // Reset the selected sorting and filtering options to the default values
      galleryService.resetSortAndFilter();
    };

    /**
     * Cache the current scroll position and increment the number of views
     * on the clicked gallery item
     */
    $scope.handleGalleryItemClick = function(item) {
      // Cache the current scroll position
      galleryService.cacheScrollPosition();

      // Increment the number of views
      galleryItemFactory.incrementViews(item.id).success(function() {
        item.views++;
      });
    };

    // Expose the iFrame resize function to allow the window to resize
    // when any of the filtering and sorting options change
    $scope.resizeIFrame =  utilService.resizeIFrame;

    /**
     * Filter the results by author if the author filter is present in the
     * current page URL
     */
    if ($routeParams.authorName) {
      // Ensure that all sorting and filtering options are back at their default values
      $scope.resetSortAndFilter();
      // Filter by the author name
      $scope.sortAndFilter.selected.search.author = $routeParams.authorName;
    }

    /**
     * Get the detailed information about the current user and load the gallery
     * items. We only do this when no specific item has been selected
     */
    if (!$scope.selectedItemId) {
      userService.getMe(function(me) {
        $scope.me = me;
        // Get the assignments for the current course
        assignmentService.getAssignments(function(assignments) {
          $scope.assignments = assignments;
          // Get the gallery items
          galleryService.getGalleryItems(function(items) {
            $scope.items = items;
            // Resize the iFrame Datacultures is running in
            utilService.resizeIFrame();
            // Restore the scroll position to the position the list
            // was in previously
            galleryService.restoreScrollPosition();
          });
        });
      });
    }

  });

})(window.angular);

