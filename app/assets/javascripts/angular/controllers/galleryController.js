(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryController', function(analyticsService, assignmentService, galleryService, galleryItemFactory, userService, utilService, $routeParams, $scope) {

    $scope.selectedItemId = $routeParams.selectedItemId;
    $scope.sortAndFilter = galleryService.sortAndFilter;

    /**
     * Reset the sort and filtering options to the default values. This will
     * also ensure that the page is scrolled to the top when showing the items
     *
     * @api private
     */
    var resetSortAndFilter = function() {
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

    /**
     * Handle changes in the selected sort and filter options by pushing an analytics
     * statement containing the filter and sort options and resizing the BasicLTI
     * iFrame
     *
     * @param  {String}     type        The sort/filter type that has been changed. One of assignment, type, sort, search
     */
    $scope.handleSortAndFilter = function(type) {
      // Track that the gallery sort and/or filter has been changed
      var trackingData = {
        type: type,
        assignment: $scope.sortAndFilter.selected.assignment ? $scope.sortAndFilter.selected.assignment.canvas_assignment_id : null,
        dataType: $scope.sortAndFilter.selected.type ? $scope.sortAndFilter.selected.type.value : null,
        sort: $scope.sortAndFilter.selected.sort.value,
        search: $scope.sortAndFilter.selected.search.author || null
      };
      var trackingTitle = null;
      if (type === 'assignment' || type === 'type') {
        trackingTitle = 'Filter Gallery List';
      } else if (type === 'sort') {
        trackingTitle = 'Sort Gallery List';
      } else if (type === 'search') {
        trackingTitle = 'Search Gallery List';
      }
      analyticsService.track(trackingTitle, trackingData);
      // Resize the iFrame Datacultures is running in
      utilService.resizeIFrame();
    };

    /**
     * Filter the results by author if the author filter is present in the
     * current page URL
     */
    if ($routeParams.authorName) {
      // Ensure that all sorting and filtering options are back at their default values
      resetSortAndFilter();
      // Filter by the author name
      $scope.sortAndFilter.selected.search.author = $routeParams.authorName;
    }

    /**
     * Get the detailed information about the current user and load the gallery
     * items. We only do this when no specific item has been selected
     */
    if (!$scope.selectedItemId) {
      userService.getMe()
        .then(function(me) {
          $scope.me = me;
          // Get the assignments for the current course
          return assignmentService.getAssignments();
        })
        .then(function(assignments) {
          $scope.assignments = assignments;
          // Get the gallery items
          return galleryService.getGalleryItems();
        })
        .then(function(items) {
          $scope.items = items;
          // Track that the gallery tool has been loaded
          galleryService.trackToolLoad();
          // Track that the gallery list has been loaded
          analyticsService.track('Load Gallery List');
          // Resize the iFrame Datacultures is running in
          utilService.resizeIFrame();
          // Restore the scroll position to the position the list
          // was in previously
          galleryService.restoreScrollPosition();
        });
    }

  });

})(window.angular);
