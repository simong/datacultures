(function(win, angular) {

  'use strict';

  /**
   * Initialize all of the submodules
   */
  angular.module('datacultures.config', ['ngRoute']);
  angular.module('datacultures.controllers', []);
  angular.module('datacultures.directives', []);
  angular.module('datacultures.factories', []);
  angular.module('datacultures.filters', []);
  angular.module('datacultures.services', ['ng']);

  /**
   * datacultures module
   */
  var datacultures = angular.module('datacultures', [
    'datacultures.config',
    'datacultures.controllers',
    'datacultures.directives',
    'datacultures.factories',
    'datacultures.filters',
    'datacultures.services',
    'ngRoute',
    'ngSanitize',
    'templates'
  ]);

  // Bind datacultures to the window object so it's globally accessible
  win.datacultures = datacultures;

})(window, window.angular);
