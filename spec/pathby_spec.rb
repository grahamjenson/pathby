require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require "./benderpaths"
require "test/unit"
require 'savage'
require 'RMagick'



def createImageFromPath(path,height=100,width=100)
    canvas = Magick::Image.new(width,height)
    gc = Magick::Draw.new
    gc.stroke("black")
    gc.fill("white")
    gc.stroke_width(4)
    gc.path(path)
    gc.draw(canvas)
    return canvas
end

def casteljau(points)
  
  poiredpoints = points[0..-2].zip points[1..-1]
  midpoints = poiredpoints.map{|p1,p2| [(p1[0]+p2[0])/2,(p1[1]+p2[1])/2]}
end

class TestBenderPaser < Test::Unit::TestCase

  def nottest_bisection()
      a = [[0,50],[0,0],[100,100],[100,50]]
      b = casteljau(a)
      c = casteljau(b)
      d = casteljau(c)
      puts b.to_s
      puts c.to_s
      puts d.to_s
  end
  
  def nottest_segment()
    img = createImageFromPath("M0 50 C0 0 100 100 100 50")
    img.write("line.bmp")
    
    #Casteljau algorithm half each set of points. The first half of new points is the new curve
    #Awesome, just need to make it pretier http://www.tsplines.com/resources/class_notes/Bezier_curves.pdf
    img = createImageFromPath("M0 50 C0 0 
    0 25 25 37 50 50
    75 62 100 75 100 50")
    img.write("line2.bmp")
    # canvas.difference using this method to calculate difference, test identity i.e. bisection
  end
  
  def test_simple
    path = 
    a =  Savage::Parser.parse "m0 50c 0 0 50 50"     
    puts a.methods.sort 
  end
 
end
describe "Pathby" do
  it "fails" do
    fail "hey buddy, you should probably rename this file and start specing for real"
  end
end
