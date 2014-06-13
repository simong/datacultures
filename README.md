datacultures
============

The Data Cultures running in Canvas

development
===========

    $ bundle install
    $ sudo gem install zeus

    In your development environment, in one shell, start zeus:

    $ zeus start

    In another table, start guard:

    $ guard


    Now, from other windows (or an edit tool such as RubyMine), change either a spec or the code it is covering, and it will be run in the guard window.