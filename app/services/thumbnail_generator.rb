class ThumbnailGenerator
  require 'open-uri'
  require 'set'
  require 'tempfile'
  require 'graphicsmagick'

  @@types = Set.new [
    'application/dicom', 'application/tga', 'application/x-font-ttf', 'application/x-tga', 'application/x-targa',
    'image/bmp', 'image/gif', 'image/jpeg', 'image/jpg', 'image/png', 'image/targa', 'image/tga', 'image/tiff',
    'image/vnd.adobe.photoshop', 'image/x-cmu-raster', 'image/x-gnuplot', 'image/x-icon', 'image/x-targa',
    'image/x-tga', 'image/x-xbitmap', 'image/x-xpixmap', 'image/x-xwindowdump', 'image/xcf'
  ]

  def initialize(request_object, course)
    @request_object = request_object
    @course = course
  end

  # Check if the thumbnail generator can handle a given content type
  def can_process(type)
    return @@types.include?(type)
  end

  # Download the image at `url` and resize it. The image will be rescaled to
  # the largest dimension so the original ratio is retained.
  # The options are:
  #  - width: The desired width of the thumbnail, defaults to 210px
  #  - height: The desired height of the thumbnail, defaults to 210px
  #  - gravity: How the image should be cropped, defaults to 'center'. Options are: NorthWest, North, NorthEast, West, Center, East, SouthWest, South, or SouthEast
  #  - quality: The desired quality of the thumbnail (as a percentage), defaults to 85
  def generate(url, options={})
    # Allow to user to specify overrides
    options = {width: 210, height: 210, quality: 85, gravity: 'center'}.merge(options)

    # Open up a temp file
    temp_file = Tempfile.new(['thumbnail_', '.jpg'], Rails.root.join('tmp'), :encoding => "binary")
    temp_file.open()

    # Download the remote file to the temporary file
    open(url, "rb") do |read_file|
        temp_file.write(read_file.read)
    end

    # Resize the downloaded image so it fits in a the specified container (assume 210x210)
    # Execute the equivalent of:
    #   gm mogrify -size 210x210 -thumbnail 210x210\^ -gravity center -extent 210x210 -quality 85 thumbnail_123.jpg
    size = options[:width].to_s + 'x' + options[:height].to_s
    frame = size + '^'
    img = GraphicsMagick::Image.new(temp_file)
    img.size(size).thumbnail(frame).gravity(options[:gravity]).extent(size).quality(options[:quality])
    img.write!

    # Return the temp_file
    return temp_file
  end

  # Download the image at `url`, resize it and upload it to the specified course in Canvas
  def generate_and_upload(assignment_id, url, content_type='image/jpeg', options={})
    # Generate a thumbnail
    temp_file = generate(url, options)

    # Upload it to Canvas
    uploader = Canvas::FileUploader.new
    url = uploader.upload(@request_object, @course, assignment_id, temp_file.path, content_type)

    # Delete the temp file
    temp_file.delete

    # Return the url to the file in Canvas
    return url
  end
end
