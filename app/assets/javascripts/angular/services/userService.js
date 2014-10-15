(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('userService', function(userInfoFactory) {

    var me = {};

    var defineRoles = function() {
      var roles = {};
      if (me && me.canvas_roles) {
        roles.instructor = (me.canvas_roles.indexOf('Instructor') !== -1);
      }
      me.roles = roles;
    };

    var handleUserLoaded = function(data) {
      angular.extend(me, data);
      defineRoles();
    };

    var fetch = function(options) {
      userInfoFactory.me(options).success(handleUserLoaded);
    };

    var handleRouteChange = function() {
      fetch();
    };

    // Expose methods
    return {
      handleRouteChange: handleRouteChange,
      me: me
    };

  });

}(window.angular));
