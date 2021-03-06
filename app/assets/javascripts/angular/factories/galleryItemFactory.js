(function(angular) {

  'use strict';

  /**
   * Gallery Item Factory - Retrieve a gallery item and manage comments and likes
   */
  angular.module('datacultures.factories').factory('galleryItemFactory', function($http) {

    var commentUrl = '/api/v1/comments';

    /**
     * Get the detailed information for a gallery item
     *
     * @param  {String}                 id            The id of the gallery item to retrieve
     * @return {Promise<GalleryItem>}                 Promise returning the retrieved gallery item
     */
    var getGalleryItem = function(id) {
      var url = '/api/v1/gallery/' + id;
      return $http.get(url).then(function(response) {
        var galleryItem = response.data;
        // Convert the `canvas_user_id` property to a number
        // TODO: Improve the API endpoint to ensure the `canvas_user_id`
        // property is returned as a number
        galleryItem.canvas_user_id = parseInt(galleryItem.canvas_user_id, 10);
        return galleryItem;
      });
    };

    /**
     * Add a comment to a gallery item
     *
     * @param  {String}                 id            The id of the gallery item to add a comment to
     * @param  {String}                 comment       The comment to add to the gallery item
     * @return {Promise}                              $http promise
     */
    var addComment = function(id, comment) {
      var data = {
        id: id,
        comment: comment
      };
      return $http.post(commentUrl, data);
    };

    /**
     * Update an existing comment on a gallery item
     *
     * @param  {String}                 comment_id    The id of the comment to update
     * @param  {String}                 comment       The updated comment
     * @return {Promise}                              $http promise
     */
    var updateComment = function(comment_id, comment) {
      var data = {
        comment_id: comment_id,
        comment: comment
      };
      return $http.put(commentUrl, data);
    };

    /**
     * Increment the number of views on a gallery item
     *
     * @param  {String}                 id            The id of the gallery item to increment the views for
     * @return {Promise}                              $http promise
     */
    var incrementViews = function(id) {
      var data = {
        gallery_id: id
      };
      return $http.post('/api/v1/views/', data);
    };

    /**
     * Like or dislike a gallery item
     *
     * @param  {String}                 id            The id of the gallery item to like or dislike
     * @param  {Boolean}                [liked]       `true` when the gallery item should be liked. `false` when it should be disliked. `null` when the existing like or dislike should be removed
     * @return {Promise}                              $http promise
     */
    var like = function(id, liked) {
      var data = {
        id: id,
        liked: liked
      };
      return $http.post('/api/v1/likes', data);
    };

    return {
      getGalleryItem: getGalleryItem,
      addComment: addComment,
      updateComment: updateComment,
      incrementViews: incrementViews,
      like: like
    };

  });

}(window.angular));
