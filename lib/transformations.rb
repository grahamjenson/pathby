require 'matrix'


module Pathby

  module Transformations
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
      
      def self.gReflectMatrix(about = Point.new(0,0))
        #rotate by 180 about 
        #translate to make rotation point 0
        t = gTranslateMatrix(-about.x , -about.y)
        r = gRotateMatrix(Math::PI)
        return t.inv * (r * t)
      end
  end

  class Point
    def reflect(about)
      transform(Transformations.gReflectMatrix(about))
    end
    
    def transform(m)
      v = Matrix[[self.x],[self.y],[1]]
      v = m*v
      self.x = v[0,0]
      self.y = v[1,0]
      return self
    end
    
  end
  
  class Curve
    def transform(m)
      cp1.transform(m)
      cp2.transform(m)
      p2.transform(m)
      return self
    end
  end
  
  class Path
   def transform(m)
     p1.transform(m)
     curves.each {|c| c.transform(m)}
     return self
   end
   
  end
  
  class Shape
    def transform(m)
      subpaths.each {|p| p.transform(m)}
      return self
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
      m = Transformations.gTranslateMatrix(-min.x,-min.y)
      transform(m)
      return self
    end
  end
end