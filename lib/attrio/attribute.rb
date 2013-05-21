# encoding: utf-8

module Attrio
  class Attribute
    attr_reader :object, :name, :type, :options

    def initialize(object, name, type, options)
      @object = object; @name = name; @type = type; @options = options.symbolize_keys   
    end

    def reader_method_name
      @reader_method_name ||= self.accessor_name_from_options(:reader) || self.name
    end

    def writer_method_name
      @writer_method_name ||= self.accessor_name_from_options(:writer) || "#{self.name}="
    end

    def reader_visibility
      @reader_visibility ||= self.accessor_visibility_from_options(:reader) || :public
    end

    def writer_visibility
      @writer_visibility ||= self.accessor_name_from_options(:writer) || :public
    end

    def instance_variable_name
      @instance_variable_name ||= self.options[:instance_variable_name] || "@#{self.name}"
    end

    def default_value
      self.options[:default] || self.options[:default_value]
    end

    def define_writer
      Attrio::Builders::WriterBuilder.define(self.object, self.type,
        self.options.merge({
          :method_name => self.writer_method_name,
          :method_visibility => self.writer_visibility,
          :instance_variable_name => self.instance_variable_name
        })
      )
      self
    end

    def define_reader
      Attrio::Builders::ReaderBuilder.define(self.object, self.type,
        self.options.merge({
          :method_name => self.reader_method_name,
          :method_visibility => self.reader_visibility,
          :instance_variable_name => self.instance_variable_name
        })
      )
      self
    end

  protected

    def accessor_name_from_options(accessor)
      (self.options[accessor.to_sym].is_a?(Hash) && self.options[accessor.to_sym][:name]) || self.options["#{accessor.to_s}_name".to_sym]
    end

    def accessor_visibility_from_options(accessor)
      return self.options[accessor] if self.options[accessor].present? && [:public, :protected, :private].include?(self.options[accessor])          
      (self.options[accessor].is_a?(Hash) && self.options[accessor][:visibility]) || self.options["#{accessor.to_s}_visibility".to_sym]
    end
  end
end