module Dhalang
  # Allows consumers of this library to take screenshots with Puppeteer. 
  class Screenshot
    PUPPETEER_SCRIPT_PATH = File.expand_path('../js/screenshot-generator.js', __FILE__).freeze
    private_constant :PUPPETEER_SCRIPT_PATH
    
    # Captures a full JPEG screenshot of the webpage under the given url.
    #
    # @param  [String] url        The url to take a screenshot of.
    #
    # @return [String] the screenshot that was taken as binary.
    def self.get_from_url_as_jpeg(url)
      get(url, "jpeg")
    end

    # Captures a full PNG screenshot of the webpage under the given url.
    #
    # @param  [String] url        The url to take a screenshot of.
    #
    # @return [String] The screenshot that was taken as binary.
    def self.get_from_url_as_png(url)
      get(url, "png")
    end
    
    # Groups and executes the logic for taking a screenhot of a webpage.
    #
    # @param  [String] url        The url to take a screenshot of.
    # @param  [String] image_type The image type to use for storing the screenshot.
    #
    # @return [String] The screenshot that was taken as binary.
    private_class_method def self.get(url, image_type)
      UrlUtils.validate(url)
      temp_file = FileUtils.create_temp_file(image_type)
      begin
        Puppeteer.visit(url, PUPPETEER_SCRIPT_PATH, temp_file.path, image_type)
        binary_image_content = FileUtils.read_binary(temp_file.path)
      ensure
        FileUtils.delete(temp_file)
      end
      return binary_image_content
    end
  end
end
