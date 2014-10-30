(function(angular) {

  'use strict';

  /**
   * Gallery Factory - Managing submissions, likes, and comments
   */
  angular.module('datacultures.factories').factory('galleryFactory', function($http) {

    var addComment = function(data) {
      var url = '/api/v1/comments';
      return $http.post(url, data);
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
      getSubmissions: getSubmissions
    };

  });

}(window.angular));
