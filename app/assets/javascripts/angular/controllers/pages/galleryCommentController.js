(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryCommentController', function(galleryFactory, $scope) {

    var resetForm = function() {
      $scope.comment.input = '';
    };

    var refresh = function() {
      $scope.refreshSubmissions();
      galleryFactory.getGalleryItem({
        id: $scope.item.id
      }).success(function(data) {
        $scope.item.comments = data.comments;
      });
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

    $scope.$watch('item.id', function(newValue) {
      if (!newValue) {
        return;
      }
      refresh();
    });

  });

})(window.angular);
