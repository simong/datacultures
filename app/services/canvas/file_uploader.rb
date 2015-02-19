class Canvas::FileUploader

  require 'uri'

  include CanvasRelativeUrlHelper

  def upload(request_object, course, assignment_id, path, content_type)
    # There are four steps when uploading a file to Canvas

    #  1.  Notify Canvas that you are uploading a file with a POST to the file creation endpoint.
    #      This POST will include the file name and file size, along with information about what context the file is being created in.
    #  2.  Upload the file using the information returned in the first POST request.
    #  3.  On successful upload, the API will respond with a redirect.
    #      This redirect needs to be followed to complete the upload, or the file may not appear.
    #  4.  Hide the file


    # Step 1: Telling Canvas about the file upload and getting a token
    url = course_files_url(course: course)
    data = {
      "name"                  => File.basename(path),
      "filesize"              => File.size(path),
      "content_type"          => content_type,
      "parent_folder_path"    => sprintf('/_thumbnails/%d/%d/%d/%d/%d', assignment_id,  Time.now.year,  Time.now.month, Time.now.day, Time.now.hour.to_s),
      "on_duplicate"          => 'overwrite'              # Overwrite any existing files
    }
    response = request_object.request.post(url, data)
    if response.status != 200
      Rails.logger.error('Unable to request file upload')
      Rails.logger.error(response.body);
      raise "Unable to request file upload"
    end
    upload_url = response.body['upload_url']
    upload_uri = URI(upload_url)
    base_upload_url = upload_uri.scheme + '://' + upload_uri.host + ":" + upload_uri.port.to_s
    upload_params = response.body['upload_params']
    upload_params['file'] = Faraday::UploadIO.new(path, content_type)


    # Step 2: Upload the file data to the URL given in the previous response
    # We can't re-use request_object, as this might be going into Amazon S3
    # and we need the multi part middleware
    conn = Faraday.new(base_upload_url) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
    response = conn.post(upload_uri.path, upload_params)
    # Note: There's a discrepancy between the Canvas file upload API (302) and the
    # Amazon AWS S3 API (303) that is used in production
    if !(response.status == 302 or response.status == 303)
      Rails.logger.error('Unable to upload file')
      Rails.logger.error(response.body);
      raise "Unable to upload file"
    end
    confirm_url = response.headers['location']


    # Step 3: Confirm the upload's success
    response = request_object.request.post(confirm_url)
    if response.status != 200
      Rails.logger.error('Unable to confirm file')
      Rails.logger.error(response.body);
      raise "Unable to confirm file"
    end
    file_id = response.body['id']
    file_url = response.body['url']


    # Step 4: Hide the file from regular users (they can still download it though)
    response = request_object.request.put('/api/v1/files/' + file_id.to_s, {'hidden' => 'true'})
    if response.status != 200
      Rails.logger.error('Unable to hide file')
      Rails.logger.error(response.body);
      raise "Unable to hide file"
    end
    return file_url
  end
end
