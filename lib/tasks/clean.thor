class Clean < Thor

  require 'thor/rails'
  include Thor::Rails

  desc "vimeo", "Repopulate Vimeo thumbnail URLs"
  def vimeo
    PopulateVimeoThumbnailUrlsWorker.perform_async(:all)
  end

  desc 'db', 'Clear out the database'
  def db
    table_names = %w<activities assignments attachments comments generic_urls media_urls students views>
    table_names.each do |table_name|
      ActiveRecord::Base.connection_pool.with_connection do |db_connection|
        db_connection.execute('TRUNCATE ' + table_name + ';')
        db_connection.execute('ALTER SEQUENCE '  + table_name + '_id_seq RESTART WITH 1;')
      end
    end
  end

end
