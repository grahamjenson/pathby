$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'pathby'

require 'savage'
require 'RMagick'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end



def createImageFromPath(path,height=1000,width=1000)
    canvas = Magick::Image.new(width,height)
    gc = Magick::Draw.new
    gc.stroke("black")
    gc.fill("white")
    gc.stroke_width(4)
    gc.path(path)
    gc.draw(canvas)
    return canvas
end

