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
        var filteredGalleryItems = [];
        for (var i = 0; i < galleryItems.length; i++) {
          var galleryItem = galleryItems[i];
          // Convert the `canvas_user_id`s to numbers
          // TODO: Improve the API endpoint to ensure the `canvas_user_id`
          // property is returned as a number
          galleryItem.canvas_user_id = parseInt(galleryItem.canvas_user_id, 10);
          // Filter out the non-image image submissions. As non-image image submissions
          // have already been submitted in production, the easiest solution is to the
          // filtering here
          // TODO: Remove this front-end filter once the submission processing is
          // more solid
          if (galleryItem.type !== 'image' || galleryItem.content_type.indexOf('image/') === 0) {
            filteredGalleryItems.push(galleryItem);
          }
        }
        return filteredGalleryItems;
      });
    };

    return {
      getGalleryItems: getGalleryItems
    };

  });

}(window.angular));
