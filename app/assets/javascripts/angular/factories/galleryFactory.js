(function(angular) {

  'use strict';

  /**
   * Gallery Factory - Managing submissions, likes, and comments
   */
  angular.module('datacultures.factories').factory('galleryFactory', function($http) {

    var commentUrl = '/api/v1/comments';

    var addComment = function(data) {
      return $http.post(commentUrl, data);
    };

    var updateComment = function(data) {
      return $http.put(commentUrl, data);
    };

    var like = function(data) {
      var url = '/api/v1/likes';
      return $http.post(url, data);
    };

    var getSubmissions = function() {
      // var url = '/dummy/json/gallerySubmissions.json';
      var url = '/api/v1/gallery/index';
      return $http.get(url);
    };

    return {
      addComment: addComment,
      like: like,
      getSubmissions: getSubmissions,
      updateComment: updateComment
    };

  });

}(window.angular));
