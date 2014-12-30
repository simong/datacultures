(function(angular) {

  'use strict';

  /**
   * Gallery Factory - Retrieve all gallery items
   */
  angular.module('datacultures.factories').factory('galleryFactory', function($http) {

    /**
     * Get all gallery items
     *
     * @return {Promise<GalleryItem[]>}      Promise returning all gallery items
     */
    var getGalleryItems = function() {
      return $http.get('/api/v1/gallery/index').then(function(response) {
        var galleryItems = response.data.files;
        // Convert the `canvas_user_id`s to numbers
        // TODO: Improve the API endpoint to ensure the `canvas_user_id`
        // property is returned as a number
        for (var i = 0; i < galleryItems.length; i++) {
          var galleryItem = galleryItems[i];
          galleryItem.canvas_user_id = parseInt(galleryItem.canvas_user_id, 10);
        }
        return galleryItems;
      });
    };

    return {
      getGalleryItems: getGalleryItems
    };

  });

}(window.angular));
