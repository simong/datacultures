(function(angular) {
  'use strict';

  /**
   * Check whether a URL is an external URL
   * @see http://stackoverflow.com/questions/6238351/fastest-way-to-detect-external-urls
   *
   * @param  {String}       url           The URL to check for being an external URL
   * @return {Boolean}                    Whether the provided URL is external
   * @api private
   */
  var isExternalURL = function(url) {
    // Relative URLs are never external. However, we ensure that the second character
    // is not a `/` to account for protocol relative URLs (e.g. `//www.google.com`)
    if (url[0] === '/' && url[1] !== '/') {
      return false;
    }
    return extractDomain(location.href) !== extractDomain(url);
  };

  /**
   * Extract the domain from a URL
   *
   * @param  {String}       url         The URL to extract the domain from
   * @api private
   */
  var extractDomain = function(url) {
    return url.replace('http://','').replace('https://','').split('/')[0];
  };

  /**
   * Ensure that external links are always opened in a new window. To improve accessibility,
   * a screenreader message is added to each external link
   */
  angular.module('datacultures.directives').directive('a', function() {
    return {
      restrict: 'E',
      priority: 200, // This needs to run after ngHref has changed
      link: function(scope, element, attr) {

        /**
         * For external links, ensure that the link is always opened in a new window
         * and add a screenreader message
         *
         * @param  {String}       url         The URL to to process
         * @api private
         */
        var updateAnchorTag = function(url) {
          // Only process external URLs. To prevent anchors from being processed multiple times,
          // a `dc-outbound-link` class is added to processed anchors
          if (url && isExternalURL(url) && !element[0].querySelector('.dc-outbound-link')) {
            var screenReadMessage = document.createElement('span');
            // Ensure that the screenreader message is only visible to screenreaders
            screenReadMessage.className = 'sr-only';
            screenReadMessage.innerHTML = '(opens in new window)';
            element.append(screenReadMessage);
            element.addClass('dc-outbound-link');
            // Ensure that the link is opened in a new window
            attr.$set('target', '_blank');
          }
        };

        attr.$observe('href', updateAnchorTag);
      }
    };
  });
})(window.angular);
