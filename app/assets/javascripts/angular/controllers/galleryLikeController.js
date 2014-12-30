(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryLikeController', function(galleryItemFactory, galleryService, $scope) {

    /**
     * Like or dislike a gallery item
     *
     * @param  {Object}         item          The gallery item to like or dislike
     * @param  {Boolean}        liked         `true` if the item should be liked. `false` if the item should be disliked. `null` if the existing like or dislike should be removed
     * @api private
     */
    var like = function(item, liked) {
      galleryItemFactory.like(item.id, liked).success(function() {
        // If we're looking at an individual gallery item, update
        // the like and dislike count on the item
        if ($scope.selectedItemId) {
          updateItemLikes($scope.item, liked);
        }
        // If the gallery item list has already been cached, update
        // the like and dislike count on the corresponding item in the list
        var cachedItem = galleryService.getCachedGalleryItem(item.id);
        if (cachedItem) {
          updateItemLikes(cachedItem, liked);
        }
      });
    };

    /**
     * Update the like and dislike count on a gallery item
     *
     * @param  {Object}         item          The gallery item that's being liked or disliked
     * @param  {Boolean}        liked         `true` if the item was liked. `false` if the item was disliked. `null` if the existing like or dislike was removed
     * @api private
     */
    var updateItemLikes = function(item, liked) {
      // The item was liked. Increase the number of likes and reduce the number
      // of dislikes if the user previously disliked the item
      if (liked === true) {
        item.likes++;
        if (item.liked === false) {
          item.dislikes--;
        }
      // The item was disliked. Increase the number of dislikes and reduce the number
      // of likes if the user previously liked the item
      } else if (liked === false) {
        item.dislikes++;
        if (item.liked === true) {
          item.likes--;
        }
      // The user is unliking or undisliking the item. Decrease the number of likes or
      // dislikes depending on whether the user previously liked or disliked the item
      } else if (liked === null) {
        if (item.liked === true) {
          item.likes--;
        } else if (item.liked === false) {
          item.dislikes--;
        }
      }
      item.liked = liked;
    };

    /**
     * Like a gallery item. If the current user already liked the gallery item,
     * the like will be removed
     *
     * @param  {Object}         item          The gallery item to like
     */
    $scope.like = function(item) {
      // Pass in `null` to remove the like when the user already liked the gallery item
      like(item, item.liked ? null : true);
    };

    /**
     * Dislike a gallery item. If the current user already disliked the gallery item,
     * the dislike will be removed
     *
     * @param  {Object}         item          The gallery item to like
     */
    $scope.dislike = function(item) {
      // Pass in `null` to remove the dislike when the user already disliked the gallery item
      like(item, item.liked === false ? null : false);
    };
  });

})(window.angular);
