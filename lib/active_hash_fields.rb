module ActiveHashFields

  class HashAsObject

    attr_reader :hash

    def initialize(hash, defaults={})
      hash ||= {}
      defaults.stringify_keys!; hash.stringify_keys!
      @hash = defaults.merge(hash)
      @hash.each { |k,v| @hash[k] = self.class.convert_to_boolean(v) }
      @hash.delete_if { |k,v| defaults[k].nil? }
    end

    def method_missing(name, *args, &blk)
      name = name.to_s
      if @hash
        if @hash.has_key?(name)
          return @hash[name]
        elsif name.match(/=$/)
          k = name.sub(/=$/, "")
          if @hash.has_key?(k)
            @hash[k] = self.class.convert_to_boolean(args[0])
          end
        end
      else
        return @hash.send(name, *args, &blk)
      end
      nil
    end

    def self.convert_to_boolean(v)
      if (v == "1" || v == "true" || v == true)
        true
      elsif v == "0" || v == "false" || v == false
        false
      else
        v
      end
    end


  end

  module ClassMethods

    def hash_field_as_object(field_name, defaults={})
      self.class_eval do
        
        serialize field_name

        after_initialize "initialize_empty_hash_for_#{field_name}", field_name
        before_validation "write_hash_to_#{field_name}"

        define_method field_name do
          @hash_as_object_attrs[field_name] ||= HashAsObject.new(read_attribute(field_name), defaults)
        end

        define_method "#{field_name}=" do |hash|
          send("initialize_empty_hash_for_#{field_name}")
          @hash_as_object_attrs[field_name] = HashAsObject.new(hash, defaults)
          @hash_as_object_attrs
        end

        define_method "write_hash_to_#{field_name}" do
          write_attribute field_name, @hash_as_object_attrs[field_name].hash
        end

        define_method "initialize_empty_hash_for_#{field_name}" do
          @hash_as_object_attrs ||= {}
          #write_attribute(field_name, defaults) if read_attribute(field_name).nil?
        end

      end
    end

  end

  module ActiveRecordExtension
    def active_hash_fields(field_name, defaults={})
      self.extend ActiveHashFields::ClassMethods
      hash_field_as_object(field_name, defaults)
    end
  end

end

ActiveRecord::Base.extend ActiveHashFields::ActiveRecordExtension
