
(function(angular) {

  'use strict';

  /**
   * User Factory - Retrieve information about the current user
   */
  angular.module('datacultures.factories').factory('userFactory', function($http) {

    /**
     * Retrieve the profile information for the current user
     *
     * @param  {Function}     callback                Standard callback function
     * @param  {Object}       callback.me             Detailed information about the current user
     * @param  {Boolean}      callback.me.isAdmin     Whether the current user is a Datacultures administrator
     */
    var getMe = function(callback) {
      $http.get('/api/v1/user_info/me').success(function(me) {
        // Determine whether the current user is a Datacultures administrator.
        // Currently, only Lecturers and Course Designers will be administrators
        if (me.canvas_roles.indexOf('Instructor') !== -1 ||
            me.canvas_roles.indexOf('ContentDeveloper') !== -1) {
          me.isAdmin = true;
        }
        return callback(me);
      });
    };

    return {
      getMe: getMe
    };

  });

}(window.angular));
