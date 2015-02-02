(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryCommentController', function(analyticsService, galleryItemFactory, galleryService, utilService, $rootScope, $scope) {

    /**
     * Reload the current gallery item
     *
     * @api private
     */
    var reloadGalleryItem = function() {
      $rootScope.$broadcast('datacultures.gallery.reloadGalleryItem');
    };

    /**
     * Add a new comment to the current gallery item
     */
    $scope.addComment = function() {
      // TODO: Improve the REST API to return the created comment to allow
      // us to dynamically add the comment to the item without refetching
      galleryItemFactory.addComment($scope.item.id, $scope.newComment.comment).success(function() {
        // Track that a new gallery item comment has been added
        var trackingData = angular.extend(analyticsService.getGalleryItemTrackingProperties($scope.item), {
          commentLength: $scope.newComment.comment.length
        });
        analyticsService.track('New Gallery Item Comment', trackingData);
        // Reset the entered comment
        $scope.newComment = null;
        // If the list of gallery items has already been cached, increase
        // the total comment count
        var cachedItem = galleryService.getCachedGalleryItem($scope.item.id);
        if (cachedItem) {
          cachedItem.comment_count++;
        }
        // Reload the current item to update the comments
        reloadGalleryItem();
      });
    };

    /**
     * Edit a comment
     *
     * @param  {Comment}       comment         The comment to edit
     */
    $scope.editComment = function(comment) {
      comment.editMode = true;
      // Cache the existing comment. This will be used to revert to
      // when the cancel button is clicked
      comment.originalComment = comment.comment;
      // Track that a gallery item comment is being edited
      var trackingData = angular.extend(analyticsService.getGalleryItemTrackingProperties($scope.item), {
        commentId: comment.comment_id,
        commentCreatedAt: comment.created_at,
        commentLength: comment.comment.length
      });
      analyticsService.track('Edit Gallery Item Comment', trackingData);
      // Resize the iFrame Datacultures is running in
      utilService.resizeIFrame();
    };

    /**
     * Cancel editing a comment and revert back to the original comment
     *
     * @param  {Comment}       comment         The comment to cancel editing for
     */
    $scope.cancelEditComment = function(comment) {
      // Track that a gallery item comment edit has been cancelled
      var trackingData = angular.extend(analyticsService.getGalleryItemTrackingProperties($scope.item), {
        commentId: comment.comment_id,
        commentCreatedAt: comment.created_at,
        commentLength: comment.originalComment.length,
        newCommentLength: comment.comment.length
      });
      analyticsService.track('Cancel Edit Gallery Item Comment', trackingData);
      // Revert back to the original comment
      comment.comment = comment.originalComment;
      comment.editMode = false;
      // Resize the iFrame Datacultures is running in
      utilService.resizeIFrame();
    };

    /**
     * Update an existing comment
     *
     * @param  {Comment}       comment         The comment to update
     */
    $scope.updateComment = function(comment) {
      // Track that a gallery item comment update has been saved
      var trackingData = angular.extend(analyticsService.getGalleryItemTrackingProperties($scope.item), {
        commentId: comment.comment_id,
        commentCreatedAt: comment.created_at,
        commentLength: comment.originalComment.length,
        newCommentLength: comment.comment.length
      });
      analyticsService.track('Save Edit Gallery Item Comment', trackingData);
      // TODO: Improve the REST API to return the updated comment to allow
      // us to dynamically update the comment without refetching
      galleryItemFactory.updateComment(comment.comment_id, comment.comment).success(reloadGalleryItem);
    };

  });

})(window.angular);
