require "monkeypatchsavage.rb"

module Pathby


  Point = Struct.new(:x,:y)
  
  Curve = Struct.new(:cp1,:cp2,:p2)
  
  Path = Struct.new(:p1,:curves)
  
  Shape = Struct.new(:subpaths)
  
  class Point
    def reflect(about = Point.new(0,0))
      puts "#{self} , #{about}"
      self.x = 2*about.x - x
      self.y = 2*about.y - y
      puts "#{self}"
      return self
    end
  end 
  
 class Savage::Directions::Point
    def top
        return Point.new(self.x,self.y)
    end 
  end
  
  def self.convertSavageToPathBy(d,fromp,prev)
    if  Savage::Directions::CubicCurveTo === d && d.control_1 then 
        return Curve.new(d.control_1.top, d.control_2.top, d.target.top)
    elsif Savage::Directions::CubicCurveTo === d && !d.control_1 then
        return Curve.new(prev.cp2.clone.reflect(fromp), d.control_2.top, d.target.top)
    elsif  Savage::Directions::VerticalTo === d then
        return Curve.new(fromp.clone, Point.new(fromp.x,d.target), Point.new(fromp.x,d.target))
    elsif  Savage::Directions::HorizontalTo === d then
        return Curve.new(fromp.clone, Point.new(d.target,fromp.y), Point.new(d.target,fromp.y))
    elsif Savage::Directions::LineTo === d then
        return Curve.new(fromp.clone, d.target.top, d.target.top)
    else raise "This class #{d.class} is not supported yet"
     end
  end
  
  def self.cshape(pathdata)
    parsedpath = Savage::Parser.parse pathdata
    parsedpath.toAbsolute
    shape = Shape.new([])
    for sp in parsedpath.subpaths do
      #get first Move direction point
      np = Path.new(sp.directions[0].target.top,[])
      fromp = np.p1
      for d in sp.directions[1..-1] do
        np.curves << self.convertSavageToPathBy(d,fromp,np.curves[-1])
        fromp = np.curves[-1].p2
      end
      shape.subpaths << np
    end
    return shape
  end
  
  class Point
    def toPathData
      return "#{x} #{y}"
    end
  end
  
  class Curve
    def toPathData
      return "#{cp1.toPathData} #{cp2.toPathData} #{p2.toPathData}"
    end
  end
  
  class Path
    def toPathData
      return "M#{p1.toPathData} C#{curves.map(&:toPathData).join(" ")}"
    end
  end
  
  class Shape
    def toPathData
      return "#{subpaths.map(&:toPathData).join(" ")}"
    end
  end
  
end
