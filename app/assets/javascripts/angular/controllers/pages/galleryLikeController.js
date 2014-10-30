(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryLikeController', function(galleryFactory, $scope) {

    var like = function(item, liked) {
      galleryFactory.like({
        id: item.id,
        liked: liked
      }).success(function() {
        if (item.liked === true && liked === null) {
          item.likes--;
        } else if (item.liked === false && liked === null) {
          item.dislikes--;
        } else if (item.liked === false && liked === true) {
          item.dislikes--;
          item.likes++;
        } else if (item.liked === true && liked === false) {
          item.dislikes++;
          item.likes--;
        } else {
          if (liked === true) {
            item.likes++;
          } else {
            item.dislikes++;
          }
        }
        item.liked = liked;
      });
    };

    $scope.like = function(item) {
      like(item, item.liked ? null : true);
    };

    $scope.dislike = function(item) {
      like(item, item.liked === false ? null : false);
    };
  });

})(window.angular);
