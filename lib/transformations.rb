require 'matrix'


module GTransMat
  def self.gRotateMatrix(radian)
    return Matrix[[Math.cos(radian) , Math.sin(radian),0],
                  [-Math.sin(radian) , Math.cos(radian),0],
                  [0,0,1]]
  end
  
  def self.gTranslateMatrix(dx,dy)
    return Matrix[[1 , 0 ,dx],
                  [0 , 1 ,dy],
                  [0 , 0 ,1]]
  end
  
  def self.gScaleMatrix(sx,sy)
    return Matrix[[sx , 0 ,0],
                  [0 , sy ,0],
                  [0 , 0 ,1]]
  end

  def self.gCenterAtMatrix(tranmatrix,about)
      t = GTransMat.gTranslateMatrix(-about.x , -about.y)
      return t.inv * (tranmatrix * t)
  end
  
end
  
module Pathby
  module Transformations
    def transform(m)
      case self
      when Point
        applytransform(m)
      else
        allpoints.each do |p|
          p.applytransform(m)  
      end
      
      end
    end
    
    def reflect(about = Point.new(0,0))
      #rotate by 180 about 
      #translate to make rotation point 0
      r = GTransMat.gRotateMatrix(Math::PI)
      if about
        r = GTransMat.gCenterAtMatrix(r,about)
      end
      transform(r)
    end
    
    def simplebbox
      points = allpoints
      
      maxx = points.max{|a,b| a.x <=> b.x}.x
      minx = points.min{|a,b| a.x <=> b.x}.x
      maxy = points.max{|a,b| a.y <=> b.y}.y
      miny = points.min{|a,b| a.y <=> b.y}.y
      puts "min  (#{minx},#{miny}) max (#{maxx},#{maxy})"
      return [Point.new(minx,miny),Point.new(maxx,maxy)]
    end
    
    def rezero
      min,max = simplebbox
      m = GTransMat.gTranslateMatrix(-min.x,-min.y)
      transform(m)
      return self
    end
    
  end 


  class Point
    include Transformations
       
    def applytransform(m)
      v = Matrix[[self.x],[self.y],[1]]
      v = m*v
      self.x = v[0,0]
      self.y = v[1,0]
      return self
    end
    
  end
  
  class Curve
    include Transformations
  end
  
  class Path
   include Transformations
  end
  
  class Shape
    include Transformations
  end
end