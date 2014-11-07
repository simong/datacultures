(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryViewController', function(viewFactory, $scope) {

    var increment = function(item) {
      viewFactory.increment({
        gallery_id: item.id
      }).success(function() {
        item.views++;
      });
    };

    $scope.$watch('item', function(item) {
      if (item) {
        increment(item);
      }
    });

  });

})(window.angular);
