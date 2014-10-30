(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryCommentController', function(galleryFactory, $scope) {

    var resetForm = function() {
      $scope.comment.input = '';
    };

    var updateSuccesful = function() {
      $scope.refreshSubmissions();
      resetForm();
    };

    $scope.addComment = function() {
      galleryFactory.addComment({
        id: $scope.currentItem.id,
        comment: $scope.comment.input
      }).success(updateSuccesful);
    };

  });

})(window.angular);
