(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryItemController', function(galleryFactory, userInfoFactory, $rootScope, $scope) {

    var constructVideoUrl = function(item) {
      if (item.youtube_id) {
        return '//www.youtube.com/embed/' + item.youtube_id + '?rel=0&hd=1';
      } else if (item.vimeo_id) {
        return '//player.vimeo.com/video/' + item.vimeo_id;
      }
    };

    var getCurrentItem = function() {
      for (var i = 0; i < $scope.items.length; i++) {
        var item = $scope.items[i];
        if (item.id === $scope.selectedItemId) {
          return item;
        }
      }
    };

    $scope.$watch('items', function(newValues) {
      if (!newValues || !$scope.items) {
        return;
      }
      var currentItem = getCurrentItem();
      if (currentItem && currentItem.type === 'video') {
        currentItem.videoUrl = constructVideoUrl(currentItem);
      }
      $scope.item = currentItem;
      $rootScope.$broadcast('dataculturesGalleryGetComments');
    });

  });

})(window.angular);
