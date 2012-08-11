require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Pathby::Shape" do

  def shouldBeIdentity(opd)
    rpath = Pathby.cshape(opd)
    image1 = createImageFromPath(opd)
    image2 = createImageFromPath(rpath.toPathData)
    image1.write("1.jpg")
    image2.write("2.jpg")
    image1.difference(image2)[1].should be_within(0.0001).of(0)
  end
  
  it "should be same curve path data in and path data out" do
    shouldBeIdentity("M0 50c0 -50 100 -50 100 0")
    shouldBeIdentity("M0 50C0 0 100 0 100 50")
  end
  
  it "should be same shape with vertical paths" do
    shouldBeIdentity("M0 50V 0")
    shouldBeIdentity("M0 50v -50")
  end

  it "should be same shape with horizontal paths" do
    shouldBeIdentity("M0 50H 100")
    shouldBeIdentity("M50 50h 50")
  end
  
  it "should be same shape with Line paths" do
    shouldBeIdentity("M0 50L 100 100")
    shouldBeIdentity("M0 50l 50 50")
  end
  
  it "should be same shape with Line paths" do
    shouldBeIdentity("M0 50L 100 100")
    shouldBeIdentity("M0 50l 50 50")
  end  
  
  it "should be same shape with shorthand curve paths" do
    shouldBeIdentity("M100,200 C100,100 250,100 250,200 S400,300 400,200")
  end

end




def casteljau(points,t)
  
  poiredpoints = points[0..-2].zip points[1..-1]
  midpoints = poiredpoints.map{|p1,p2| [(p1[0]+p2[0])*t,(p1[1]+p2[1])*t]}
end
 
