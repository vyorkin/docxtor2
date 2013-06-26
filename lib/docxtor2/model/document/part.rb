module Docxtor2
  module Model
    class Document::Part
      attr_reader :filepath, :content, :is_dynamic

      def initialize(filepath, content)
        @filepath = filepath.gsub(configus.builder_ext, '')
        @is_dynamic = self.class.is_dynamic?(@filepath)

        @content = content
      end

      private

      def self.is_dynamic?(filename)
        File.extname(filename) == configus.builder_ext
      end
    end
  end
end