##Gets called when require "pathby" is executed
###Modifications to the SAVAGE library for SVG path parsing
require 'savage'

Point = Savage::Directions::Point

class Savage::Directions::PointTarget
  def toAbsolute(fromPoint) #change target and control points, and return new target point
    if not @absolute
      @target.x += fromPoint.x
      @target.y += fromPoint.y
    end
    @absolute = true
    return Point.new(@target.x,@target.y)
  end
end

class Savage::Directions::HorizontalTo
  def toAbsolute(fromPoint)
    if not @absolute
      @target += fromPoint.x
    end
    @absolute = true
    return Point.new(@target,fromPoint.y)
  end
end

class Savage::Directions::VerticalTo
  def toAbsolute(fromPoint)
    if not @absolute
      @target += fromPoint.y
    end
    @absolute = true
    return Point.new(fromPoint.x,@target)
  end
end

class Savage::Directions::QuadraticCurveTo
  def toAbsolute(fromPoint)
    if not @absolute
      @target.x += fromPoint.x
      @target.y += fromPoint.y
      @control.x += fromPoint.x
      @control.y += fromPoint.y
    end
    @absolute = true
    return Point.new(@target.x,@target.y)
  end
end
 
class Savage::Directions::CubicCurveTo
  def toAbsolute(fromPoint)
    if not @absolute
      @target.x += fromPoint.x
      @target.y += fromPoint.y
      @control.x += fromPoint.x
      @control.y += fromPoint.y
      @control_1.x += fromPoint.x
      @control_1.y += fromPoint.y
    end
    @absolute = true
    return Point.new(@target.x,@target.y)
  end
end

class Savage::Path
  def toAbsolute
    directions = self.directions
    raise "Does not start with move command" unless Savage::Directions::MoveTo === directions[0]
    p = directions[0].target
    directions[1..-1].each do |d|
      p = d.toAbsolute(p)
    end
  end
end