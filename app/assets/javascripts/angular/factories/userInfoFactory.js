
(function(angular) {

  'use strict';

  /**
   * User Info Factory
   * @param {Object} httpService The http service
   */
  angular.module('datacultures.factories').factory('userInfoFactory', function(httpService) {

    var url = '/api/v1/user_info/me';

    var me = function(options) {
      return httpService.request(options, url);
    };

    return {
      me: me
    };

  });

}(window.angular));
