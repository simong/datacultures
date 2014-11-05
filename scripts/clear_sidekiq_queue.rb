#!/usr/bin/env ruby
require 'sidekiq/api'
Sidekiq::Queue.all.map{|sq|  sq.clear }
