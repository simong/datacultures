(function(angular) {
  'use strict';

  angular.module('datacultures.controllers').controller('GalleryCommentController', function(galleryFactory, $scope) {

    var resetForm = function() {
      $scope.comment.input = '';
    };

    var addingSuccessful = function() {
      $scope.refreshSubmissions();
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
      }).success($scope.refreshSubmissions);
    };

    $scope.addComment = function() {
      galleryFactory.addComment({
        id: $scope.item.id,
        comment: $scope.comment.input
      }).success(addingSuccessful);
    };

  });

})(window.angular);
