(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryItemController', function(galleryItemFactory, userService, utilService, $rootScope, $scope) {

    // Variable that will keep track of the currently selected gallery item
    $scope.item = null;

    /**
     * Get the current gallery item and render it
     *
     * @param  {String}       [callback]                Standard callback function
     * @param  {Object}       [callback.currentItem]    The current gallery item
     * @api private
     */
    $scope.getCurrentItem = function(callback) {
      galleryItemFactory.getGalleryItem($scope.selectedItemId, function(item) {
        if (item.type === 'video') {
          item.videoUrl = constructVideoUrl(item);
        }
        $scope.item = item;
        // Resize the iFrame Datacultures is running in
        utilService.resizeIFrame();
        if (callback) {
          return callback(item);
        }
      });
    };

    /**
     * Construct the preview URL for a video submission
     *
     * @param {GalleryItem}   item                      The id of the gallery item to generate a preview for
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
     * Get the detailed information about the current user and load the selected
     * item. We only do this when an item has been selected
     */
    if ($scope.selectedItemId) {
      userService.getMe(function(me) {
        $scope.me = me;
        // Get the current gallery item and scroll to the top of
        // the page, as the current scroll position could be somewhere
        // deep in the gallery list
        $scope.getCurrentItem(utilService.scrollToTop);
      });
    }

  });

})(window.angular);
