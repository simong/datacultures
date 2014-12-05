(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryCommentController', function(galleryFactory, $scope) {

    var resetForm = function() {
      $scope.comment.input = '';
    };

    var getGalleryItem = function() {
      galleryFactory.getGalleryItem({
        id: $scope.item.id
      }).success(function(data) {
        $scope.item.comments = data.comments;
      });
    };

    var refresh = function() {
      $scope.refreshSubmissions().then(getGalleryItem);
    };

    var addingSuccessful = function() {
      refresh();
      resetForm();
    };

    $scope.enterEditMode = function(comment) {
      comment.editMode = true;
      $scope.editComment = angular.copy(comment);
    };

    $scope.updateComment = function(comment) {
      galleryFactory.updateComment({
        comment: comment.comment,
        comment_id: comment.comment_id
      }).success(refresh);
    };

    $scope.addComment = function() {
      galleryFactory.addComment({
        id: $scope.item.id,
        comment: $scope.comment.input
      }).success(addingSuccessful);
    };

    $scope.$on('dataculturesGalleryGetComments', getGalleryItem);

  });

})(window.angular);
