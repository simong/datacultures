(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryCommentController', function(galleryItemFactory, galleryService, utilService, $scope) {

    /**
     * Add a new comment to the current gallery item
     */
    $scope.addComment = function() {
      // TODO: Improve the REST API to return the created comment to allow
      // us to dynamically add the comment to the item without refetching
      galleryItemFactory.addComment($scope.item.id, $scope.newComment).success(function() {
        // Reset the entered comment
        $scope.newComment = null;
        // If the list of gallery items has already been cached, increase
        // the total comment count
        var cachedItem = galleryService.getCachedGalleryItem($scope.item.id);
        if (cachedItem) {
          cachedItem.comment_count++;
        }
        // Reload the current item to update the comments
        $scope.getCurrentItem();
      });
    };

    /**
     * Edit a comment
     *
     * @param  {Object}       comment         The comment to edit
     */
    $scope.editComment = function(comment) {
      comment.editMode = true;
      // Cache the existing comment. This will be used to revert to
      // when the cancel button is clicked
      comment.originalComment = comment.comment;
      // Resize the iFrame Datacultures is running in
      utilService.resizeIFrame();
    };

    /**
     * Cancel editing a comment and revert back to the original comment
     *
     * @param  {Object}       comment         The comment to cancel editing for
     */
    $scope.cancelEditComment = function(comment) {
      // Revert back to the original comment
      comment.comment = comment.originalComment;
      comment.editMode = false;
      // Resize the iFrame Datacultures is running in
      utilService.resizeIFrame();
    };

    /**
     * Update an existing comment
     *
     * @param  {Object}       comment         The comment to update
     */
    $scope.updateComment = function(comment) {
      // TODO: Improve the REST API to return the updated comment to allow
      // us to dynamically update the comment without refetching
      galleryItemFactory.updateComment(comment.comment_id, comment.comment).success($scope.getCurrentItem);
    };

  });

})(window.angular);
