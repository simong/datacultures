(function(angular) {

  'use strict';

  angular.module('datacultures.services').service('galleryService', function(analyticsService, galleryFactory, utilService, $q) {

    /* FILTERING AND SORTING */

    var sortAndFilter = {};

    // Sort options
    sortAndFilter.options = {};
    sortAndFilter.options.sort = [
      {
        display: 'Date',
        value: 'submitted_at'
      },
      {
        display: 'Views',
        value: 'views'
      },
      {
        display: 'Comments',
        value: 'comment_count'
      },
      {
        display: 'Likes',
        value: 'likes'
      },
      {
        display: 'Dislikes',
        value: 'dislikes'
      }
    ];

    // Type filter options
    sortAndFilter.options.type = [
      {
        display: 'Image',
        emptyMessage: 'image',
        value: 'image'
      },
      {
        display: 'Video',
        emptyMessage: 'video',
        value: 'video'
      },
      {
        display: 'Website URL',
        emptyMessage: 'website URL',
        value: 'url'
      }
    ];

    // Keep track of the selected filter and searching options
    sortAndFilter.selected = {};

    /**
     * Reset the filter and searching options for the gallery
     */
    var resetSortAndFilter = function() {
      sortAndFilter.selected.search = {
        author: ''
      };
      sortAndFilter.selected.assignment = null;
      sortAndFilter.selected.type = null;
      sortAndFilter.selected.sort = sortAndFilter.options.sort[0];
    };

    // Set the filtering and sorting to the default options
    resetSortAndFilter();

    /* GALLERY ITEM CACHING */

    var galleryItems = null;

    /**
     * Get all gallery items. The items will only be retrieved once
     *
     * @return {Promise<GalleryItem[]>}                       Promise returning all gallery items
     */
    var getGalleryItems = function() {
      var deferred = $q.defer();
      // When the gallery items have already been retrieved, we return
      // them from cache
      if (!galleryItems) {
        galleryFactory.getGalleryItems().then(function(items) {
          // Cache the gallery items
          galleryItems = items;
          deferred.resolve(galleryItems);
        });
      } else {
        deferred.resolve(galleryItems);
      }
      return deferred.promise;
    };

    /**
     * Get a gallery item from the cached list of gallery items. If the
     * gallery items have not been cached yet, `null` will be returned
     *
     * @param  {String}                     id                The id of the gallery item to retrieve from the cached gallery items
     * @return {GalleryItem}                                  The requested gallery item from cache or `null` if the gallery items have not been cached or the requested item can not be found
     */
    var getCachedGalleryItem = function(id) {
      if (galleryItems) {
        for (var i = 0; i < galleryItems.length; i++) {
          if (galleryItems[i].id === id) {
            return galleryItems[i];
          }
        }
      }
      return null;
    };

    /* SCROLL POSITION CACHING */

    var scrollPosition = 0;

    /**
     * Cache the current scroll position. The scroll position will be cached
     * when a gallery item is clicked to allow us to return to that same
     * location when going back to the list
     */
    var cacheScrollPosition = function() {
      utilService.getScrollPosition().then(function(currentScrollPosition) {
        scrollPosition = currentScrollPosition;
      });
    };

    /**
     * Reset the cached scroll position
     */
    var resetScrollPosition = function() {
      scrollPosition = 0;
    };

    /**
     * Restore the scroll position to the cached scroll position. This will
     * be used to return to the scroll location in the gallery list when returning
     * from a gallery item
     */
    var restoreScrollPosition = function() {
      utilService.scrollTo(scrollPosition);
    };

    /* ANALYTICS */

    var hasTrackedToolLoad = false;

    /**
     * Track that the Gallery Tool has been loaded. We ensure that this is only tracked
     * once per full LTI lifecycle
     */
    var trackToolLoad = function() {
      if (!hasTrackedToolLoad) {
        hasTrackedToolLoad = true;
        // Track that the gallery tool has been loaded
        analyticsService.track('Load Gallery Tool');
      }
    };

    return {
      sortAndFilter: sortAndFilter,
      resetSortAndFilter: resetSortAndFilter,
      getGalleryItems: getGalleryItems,
      getCachedGalleryItem: getCachedGalleryItem,
      cacheScrollPosition: cacheScrollPosition,
      resetScrollPosition: resetScrollPosition,
      restoreScrollPosition: restoreScrollPosition,
      trackToolLoad: trackToolLoad
    };

  });

}(window.angular));
