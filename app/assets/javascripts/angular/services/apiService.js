(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('apiService', function(
    httpService,
    userService,
    utilService) {

    // API
    var api = {
      http: httpService,
      user: userService,
      util: utilService
    };

    return api;

  });

}(window.angular));
