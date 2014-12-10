(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('apiService', function(
    httpService,
    userService) {

    // API
    var api = {
      http: httpService,
      user: userService
    };

    return api;

  });

}(window.angular));
