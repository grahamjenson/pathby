require 'matrix'
module Transformations
    def gRotateMatrix(radian)
      return Matrix[[Math.cos(radian) , Math.sin(radian),0],
                    [-Math.sin(radian) , Math.cos(radian),0],
                    [0,0,1]]
    end
    
    def gTranslateMatrix(dx,dy)
      return Matrix[[1 , 0 ,dx],
                    [0 , 1 ,dy],
                    [0 , 0 ,1]]
    end
    
    def gScaleMatrix(sx,sy)
      return Matrix[[sx , 0 ,0],
                    [0 , sy ,0],
                    [0 , 0 ,1]]
    end
    
    def gReflectMatrix(about = Point.new(0,0))
      #rotate by 180 about 
      #translate to make rotation point 0
      t = gTranslateMatrix(-about.x , -about.y)
      r = gRotateMatrix(Math::PI)
      return t.inv * (r * t)
    end
end

module Pathby
  class Point
    include Transformations
    
    def reflect(about)
      transform(gReflectMatrix(about))
    end
    
    def transform(m)
      v = Matrix[[self.x],[self.y],[1]]
      v = m*v
      self.x = v[0,0]
      self.y = v[1,0]
      return self
    end
    
  end
end