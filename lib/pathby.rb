require File.dirname(__FILE__) +  "/monkeypatchsavage.rb"


module Pathby

  Point = Struct.new(:x,:y)

  Path = Struct.new(:curves)

  Shape = Struct.new(:paths)

  require File.dirname(__FILE__) + "/transformations.rb"

  class Point
    include Transformations

    def allpoints
      return [self]
    end

    def toPathData
      return "#{'%.2f' % x} #{'%.2f' % y}"
    end

    def applytransform(m)
      v = Matrix[[self.x],[self.y],[1]]
      v = m*v
      self.x = v[0,0]
      self.y = v[1,0]
      return self
    end

  end

  module Pathy
    include Transformations

    def allpoints
      return self.curves.flatten(1)
    end

    def toPathData
      stra = []
      self.curves.each do |curve|
       stra << " M #{curve[0].toPathData} C #{curve[1..-1].map(&:toPathData).join(" ")}"
     end
      return "#{stra.join(" ")}"
    end
  end

  class Path
    include Pathy
  end

  module Shapy
    include Transformations

      def allpoints
        points = []
        paths.each {|path| points.concat(path.allpoints)}
        return points
      end
  end

  class Shape
    include Shapy

  end


  class Savage::Directions::Point
    def top
        return Point.new(self.x,self.y)
    end
  end

  def self.createShape(pathdatalist)
    ret = Shape.new([])
    pathdatalist.each do |pathdata|
      path = self.createPath(pathdata)
      ret.paths <<  path
    end
    return ret
  end

  def self.createCurves(pathdata)
        parsedpath = Savage::Parser.parse pathdata
    curves = []
    #puts parsedpath.directions
    parsedpath.toAbsolute
    for sp in parsedpath.subpaths do
      #get first Move direction point

      np = sp.directions[0].target.top
      curve = [np]
      fromp = np
      for d in sp.directions[1..-1] do
        prevcp = curve[-2]
        if  Savage::Directions::CubicCurveTo === d && d.control_1 then
            curve += [d.control_1.top, d.control_2.top, d.target.top]
        elsif Savage::Directions::CubicCurveTo === d && !d.control_1 then
            curve += [prevcp.clone.reflect(fromp), d.control_2.top, d.target.top]
        elsif  Savage::Directions::VerticalTo === d then
            curve += [fromp.clone, Point.new(fromp.x,d.target), Point.new(fromp.x,d.target)]
        elsif  Savage::Directions::HorizontalTo === d then
            curve += [fromp.clone, Point.new(d.target,fromp.y), Point.new(d.target,fromp.y)]
        elsif Savage::Directions::LineTo === d then
            curve += [fromp.clone, d.target.top, d.target.top]
        elsif Savage::Directions::ClosePath === d then
            curve += [fromp.clone, np.clone , np.clone]
        else raise "This class #{d.class} is not supported yet"
        end
        fromp = curve[-1]
      end
      curves << curve
    end
    return curves
  end

  def self.createPath(pathdata,path=Path.new([]))
    path.curves = createCurves(pathdata)
    return path
  end


end



