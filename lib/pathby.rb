require "monkeypatchsavage.rb"


module Pathby


  Point = Struct.new(:x,:y)
  
  #P1 is intended to be a reference
  Curve = Struct.new(:p1,:cp1,:cp2,:p2)
  
  Path = Struct.new(:p1,:curves)
  
  Shape = Struct.new(:subpaths)
  
  require "transformations.rb"
    
  class Savage::Directions::Point
    def top
        return Point.new(self.x,self.y)
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
        prev = np.curves[-1]
        if  Savage::Directions::CubicCurveTo === d && d.control_1 then 
            np.curves << Curve.new(fromp, d.control_1.top, d.control_2.top, d.target.top)
        elsif Savage::Directions::CubicCurveTo === d && !d.control_1 then
            np.curves << Curve.new(fromp, prev.cp2.clone.reflect(fromp), d.control_2.top, d.target.top)
        elsif  Savage::Directions::VerticalTo === d then
            np.curves << Curve.new(fromp, fromp.clone, Point.new(fromp.x,d.target), Point.new(fromp.x,d.target))
        elsif  Savage::Directions::HorizontalTo === d then
            np.curves << Curve.new(fromp, fromp.clone, Point.new(d.target,fromp.y), Point.new(d.target,fromp.y))
        elsif Savage::Directions::LineTo === d then
            np.curves << Curve.new(fromp, fromp.clone, d.target.top, d.target.top)
        elsif Savage::Directions::ClosePath === d then
            np.curves << Curve.new(fromp, fromp.clone, np.p1.clone , np.p1)
        else raise "This class #{d.class} is not supported yet"
        end
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
