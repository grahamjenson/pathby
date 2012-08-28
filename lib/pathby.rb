require File.dirname(__FILE__) +  "/monkeypatchsavage.rb"

module Pathby


  Point = Struct.new(:x,:y)

  Curve = Struct.new(:points)

  Path = Struct.new(:name,:curves)

  Shape = Struct.new(:name, :paths)

  require File.dirname(__FILE__) + "/transformations.rb"

  require File.dirname(__FILE__) + "/visualpath.rb"

  class Savage::Directions::Point
    def top
        return Point.new(self.x,self.y)
    end
  end

  def self.createShape(pathdatamap,name=Time.new.to_i)
    ret = Shape.new(name,[])
    for n, pathdata in pathdatamap do
      path = self.createPath(pathdata,n)
      ret.paths <<  path
    end
    return ret
  end

  def self.createPath(pathdata,name=Time.new.to_i)
    parsedpath = Savage::Parser.parse pathdata
    #puts parsedpath.directions
    parsedpath.toAbsolute
    path = Path.new(name,[])
    for sp in parsedpath.subpaths do
      #get first Move direction point

      np = sp.directions[0].target.top
      curve = Curve.new([np])
      fromp = np
      for d in sp.directions[1..-1] do
        prevcp = curve.points[-2]
        if  Savage::Directions::CubicCurveTo === d && d.control_1 then
            curve.points += [d.control_1.top, d.control_2.top, d.target.top]
        elsif Savage::Directions::CubicCurveTo === d && !d.control_1 then
            curve.points += [prevcp.clone.reflect(fromp), d.control_2.top, d.target.top]
        elsif  Savage::Directions::VerticalTo === d then
            curve.points += [fromp.clone, Point.new(fromp.x,d.target), Point.new(fromp.x,d.target)]
        elsif  Savage::Directions::HorizontalTo === d then
            curve.points += [fromp.clone, Point.new(d.target,fromp.y), Point.new(d.target,fromp.y)]
        elsif Savage::Directions::LineTo === d then
            curve.points += [fromp.clone, d.target.top, d.target.top]
        elsif Savage::Directions::ClosePath === d then
            curve.points += [fromp.clone, np.clone , np.clone]
        else raise "This class #{d.class} is not supported yet"
        end
        fromp = curve.points[-1]
      end
      path.curves << curve
    end
    return path
  end

  class Point
    def allpoints
      return [self]
    end

    def toPathData
      return "#{'%.2f' % x} #{'%.2f' % y}"
    end

  end

  class Curve
    def allpoints
      a = []
      a += points
      return a
    end

    def toPathData
      return "M #{points[0].toPathData} C #{points[1..-1].map(&:toPathData).join(" ")}"
    end

  end

  class Path
    def allpoints
      points = []
      curves.each {|c| points.concat(c.allpoints)}
      return points
    end

    def toPathData
      return "#{curves.map(&:toPathData).join(" ")}"
    end
  end

  class Shape
    def allpoints
      points = []
      paths.each {|path| points.concat(path.allpoints)}
      return points
    end
  end


end



