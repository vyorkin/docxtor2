module Docxtor2
  class Package::Document::Paragraph < Package::Document::Element

    def initialize(*args, &block)
      super(*args, &block)
      @params[:space] ||= 'default'
      @params[:spacing] ||= {}
      @params[:indent] ||= {}
      @contents = create_contents(args)
    end

    def render(xml)
      super(xml)
      write_element(:p) do
        write_element(:r) do
          write_contents
        end
      end
    end

    [:align, :style].each do |name|
      define_method(name) do |val|
        @params[name] = val
      end
    end

    [:bold, :italic, :underline].each do |name|
      define_method(name) do
        @params[name] = true
      end
    end

    [:spacing, :indent].each do |name|
      define_method(name) do |attrs|
        @params[name].merge!(attrs)
      end
    end

    def line_break
      @contents << :br
    end

    def preserve_whitespace
      @params[:space] = 'preserve'
    end

    def write(text)
      @contents << text
    end

    protected

    def mappings
      super.merge({
        :p => {
          :style => 'pStyle',
          :align => 'jc',
          :spacing => {
            :name => 'spacing',
            :before => 'before',
            :after => 'after'
          },
          :indent => {
            :name => 'ind',
            :start => 'start',
            :end => 'end',
            :hanging => 'hanging'
          }
        },
        :r => {
          :bold => 'b',
          :italic => 'i',
          :underline => 'u'
        }
      })
    end

    def aliases
      super.merge({
        :b => :bold,
        :i => :italic,
        :u => :underline
      })
    end

    private

    def write_contents
      @contents.each { |c| write_content(c) }
    end

    def write_content(content)
      content == :br ?
        write_line_break :
        write_text(content)
    end

    def write_line_break
      (@xml.w :br)
    end

    def write_text(text)
      @xml.w :t, 'xml:space' => @params[:space] do
        @xml.text! text
      end
    end

    def create_contents(args)
      str = find_argument(args, String)
      str.nil? ? [] : [str]
    end

    alias_method :b, :bold
    alias_method :i, :italic
    alias_method :u, :underline
    alias_method :br, :line_break
    alias_method :w, :write
    alias_method :ind, :indent
  end
end
