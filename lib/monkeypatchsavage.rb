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

  def absolute
    return @absolute
  end

  def setAbsolute(ab)
    @absolute = ab
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
      if @control_1
        @control_1.x += fromPoint.x
        @control_1.y += fromPoint.y
      end
    end
    @absolute = true
    return Point.new(@target.x,@target.y)
  end
end

class Savage::Directions::ClosePath
  def toAbsolute(fp)
    return fp
  end
end


class Savage::SubPath
  def toAbsolute(fp)
    raise "Does not start with move command" unless @directions[0].kind_of? Savage::Directions::MoveTo
    @directions.each do |d|
      fp = d.toAbsolute(fp)
    end
    if closed? then
      return @directions[0].target.clone
    else
      return fp
    end
  end
end

class Savage::Path
  def toAbsolute
    raise "Does not start with move command" unless self.directions[0].kind_of? Savage::Directions::MoveTo
    #raise "First move is not absolute" unless self.directions[0].absolute?
    fromp = self.directions[0].target
    self.directions[0].setAbsolute(true)
    for sp in @subpaths do
      fromp = sp.toAbsolute(fromp)
    end
  end
end



