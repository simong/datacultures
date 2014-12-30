(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('userService', function(userFactory) {

    // Variable that caches the profile information for the current user
    var me = null;

    /**
     * Retrieve the profile information for the current user. This will only be retrieved once
     *
     * @param  {Function}     callback                Standard callback function
     * @param  {Object}       callback.me             Detailed information about the current user
     * @param  {Boolean}      callback.me.isAdmin     Whether the current user is a Datacultures administrator
     */
    var getMe = function(callback) {
      if (!me) {
        userFactory.getMe(function(retrievedMe) {
          me = retrievedMe;
          return callback(me);
        });
      } else {
        return callback(me);
      }
    };

    return {
      getMe: getMe
    };

  });

}(window.angular));
