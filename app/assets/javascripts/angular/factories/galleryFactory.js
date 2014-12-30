(function(angular) {

  'use strict';

  /**
   * Gallery Factory - Retrieve all gallery items
   */
  angular.module('datacultures.factories').factory('galleryFactory', function($http) {

    /**
     * Get all gallery items
     *
     * @param  {Function}     callback                Standard callback function
     * @param  {Object[]}     callback.galleryItems   The retrieved gallery items
     */
    var getGalleryItems = function(callback) {
      var url = '/api/v1/gallery/index';
      $http.get(url).success(function(galleryItems) {
        // Convert the `canvas_user_id`s to numbers
        // TODO: Improve the API endpoint to ensure the `canvas_user_id`
        // property is returned as a number
        for (var i = 0; i < galleryItems.files.length; i++) {
          var galleryItem = galleryItems.files[i];
          galleryItem.canvas_user_id = parseInt(galleryItem.canvas_user_id, 10);
        }
        return callback(galleryItems);
      });
    };

    return {
      getGalleryItems: getGalleryItems
    };

  });

}(window.angular));
