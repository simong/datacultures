(function(angular) {

  'use strict';

  /**
   * Gallery Factory - Managing submissions, likes, and comments
   */
  angular.module('datacultures.factories').factory('galleryFactory', function($http) {

    var createComment = function(data) {
      var url = '/api/v1/comments/new';
      return $http.post(url, data);
    };

    var getComments = function(itemId) {
      var url = '/api/v1/comments/' + itemId;
      return $http.get(url);
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
      createComment: createComment,
      like: like,
      getComments: getComments,
      getSubmissions: getSubmissions
    };

  });

}(window.angular));
