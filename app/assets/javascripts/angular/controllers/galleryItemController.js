(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryItemController', function(analyticsService, galleryItemFactory, userService, utilService, $scope) {

    // Variable that will keep track of the currently selected gallery item
    $scope.item = null;

    /**
     * Get the current gallery item and render it
     *
     * @return {Promise}                                Standard promise
     * @api private
     */
    var loadCurrentItem = function() {
      return galleryItemFactory.getGalleryItem($scope.selectedItemId).then(function(item) {
        if (item.type === 'video') {
          item.videoUrl = constructVideoUrl(item);
        }
        $scope.item = item;
      });
    };

    // Listen for external requests to reload the current gallery item
    $scope.$on('datacultures.gallery.reloadGalleryItem', loadCurrentItem);

    /**
     * Construct the preview URL for a video submission
     *
     * @param  {GalleryItem}              item          The id of the gallery item to generate a preview for
     * @api private
     */
    var constructVideoUrl = function(item) {
      if (item.youtube_id) {
        return '//www.youtube.com/embed/' + item.youtube_id + '?rel=0&hd=1';
      } else if (item.vimeo_id) {
        return '//player.vimeo.com/video/' + item.vimeo_id;
      }
    };

    /**
     * Track that the link for an external URL submission has been clicked
     */
    $scope.trackOpenLink = function() {
      analyticsService.track('Open Gallery Item Link', analyticsService.getGalleryItemTrackingProperties($scope.item));
    };

    /**
     * Get the detailed information about the current user and load the selected
     * item. We only do this when an item has been selected
     */
    if ($scope.selectedItemId) {
      userService.getMe()
        .then(function(me) {
          $scope.me = me;
          // Get the current gallery item
          return loadCurrentItem();
        })
        .then(function() {
          // Track that a gallery item has been loaded
          analyticsService.track('Load Gallery Item', analyticsService.getGalleryItemTrackingProperties($scope.item));
        })
        // Scroll to the top of the page, as the current scroll position could be somewhere
        // deep in the gallery list
        .then(utilService.scrollToTop);
    }

  });

})(window.angular);
