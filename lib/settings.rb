module Settings

  def deep_open_struct(hash_recursive)
    require 'ostruct'
    obj = hash_recursive
    if obj.is_a?(Hash)
      obj.each do |key, val|
        obj[key] = deep_open_struct(val)
      end
      obj = OpenStruct.new(obj)
    elsif obj.is_a?(Array)
      obj = obj.map {|val| deep_open_struct(val)}
    end
    obj
  end

end
