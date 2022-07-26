class Base
  def initialize(resource)
    load_data_from resource
  end

  def load_data_from(resource)
    raw_data = File.read "./data/#{resource}.json"  

    Oj.load(raw_data).each do |method, value|
      self.instance_variable_set(:"@#{method}", value) if self.methods.include?(method.to_sym)
    end
  end

  class << self
    def inherited(subclass)
      attrs = attributes_for subclass
      subclass.class_exec do
        attr_reader(*attrs)
      end
      super
    end

    private

    def attributes_for(klass)
      @methods ||= Oj.load File.read('./methods.json')
      @methods[klass.to_s.downcase]
    end
  end
end