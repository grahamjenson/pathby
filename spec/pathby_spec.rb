require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Pathby::Shape" do

  def shouldBeIdentity(opd,print=false)
    rpath = Pathby.cshape(opd)
    image1 = createImageFromPath(opd)
    #puts "#{rpath.toPathData} \ncompared \n #{opd}"
    image2 = createImageFromPath(rpath.toPathData)
    image1.write("tmp/imageshouldbe.jpg") if print
    image2.write("tmp/imageis.jpg") if print
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
    shouldBeIdentity("M100,200 C100,100 250,100 250,200 S400,300 400,200",print=true)
    shouldBeIdentity("M100,200 C100,100 250,100 250,200 s400,300 400,200")
  end

  it "should work for subpaths" do
    shouldBeIdentity("M100,200 C100,100 250,100 250,200M0 50L 100 100"  )
  end

  it  "should work for relative subpaths" do
    shouldBeIdentity("M100,200 C100,100 250,100 250,200m-100 -100L 100 100")
  end

  it "should work for subpaths with close path" do
    shouldBeIdentity("M100,200 C100,100 250,100 250,200zM0 50L 100 100")
  end

  it "should work for relative subpaths with close path" do
    shouldBeIdentity("M100,200 C100,100 250,100 250,200zm-100 -100L 100 100")
  end

  it "should work for real examples" do
    pd = "M500 500 l-0.07 5.844c-0.12 9.414-11.92 24.284-27.03 34.034-11.27 7.28-12.56 6.98-6.81-1.5 5.26-7.75 9.29-20.44 8.1-25.47-0.52-2.18-1.3-1.33-2.35 2.56-2.89 10.69-12.18 21.46-27.44 31.85-8.31 5.66-17.917 12.92-21.371 16.15l-6.281 5.91v-8c0-4.39 0.838-10.21 1.874-12.94 1.037-2.73 1.5-4.97 1.032-4.97-1.601 0-5.475 8.7-7.782 17.41l-2.312 8.68-1.406-9.65c-0.765-5.32-1.568-10.45-1.813-11.44-0.896-3.61-8.736 11.77-12.031 23.63-2.744 9.87-3.029 14.37-1.5 23.62 1.846 11.16 1.813 11.35-1.781 8.1-5.269-4.77-11.165-17.03-13.094-27.32-1.517-8.08-1.578-7.82-0.781 3.22 0.824 11.42 5.55 23.54 13.406 34.31 2.743 3.77 2.495 3.85-9.188 3.41l-12-0.44 9.688 2.78c5.315 1.53 10.359 2.8 11.219 2.85 3.424 0.18-0.845 3.52-5.875 4.59-2.945 0.63-7.968 3.31-11.156 5.97l-5.782 4.84 10.156-3.78c5.593-2.08 12.995-3.79 16.438-3.78l6.25 0.03-9.062 5.28c-10.697 6.26-16.579 13.27-18.282 21.78l-1.25 6.19 8.063-5.34c4.43-2.93 8.482-4.89 9-4.38 1.575 1.58-10.02 16.3-16.844 21.41-3.527 2.64-9.633 5.93-13.563 7.31-9.367 3.3-7.524 5.69 4.376 5.69 5.252 0 9.531 0.72 9.531 1.59 0 0.88-2.982 5.09-6.657 9.38-7.158 8.36-24.21 17.06-30.312 15.47-1.9945-0.51-3.63-0.27-3.63 0.57 0 2.09 7.2536 3.87 15.969 3.91h7.218l-8.687 11.81c-4.781 6.49-8.6875 12.51-8.6875 13.37s-0.5852 3.15-1.3125 5.1c-0.8268 2.21 1.6902 0.84 6.75-3.69 4.451-3.99 8.378-7.25 8.719-7.25s-1.365 5.89-3.782 13.09c-2.416 7.21-4.87 19.15-5.468 26.57l-1.094 13.5 3.719-16.44c3.757-16.7 9.287-32.87 6.937-20.28-3.362 18-3.048 43.34-0.125 57.15h5.594c-0.045-0.82-0.096-1.61-0.156-2.56-0.594-9.35 0.001-16.19 1.781-20.53 2.617-6.39 2.727-6.06 6.344 18.16 0.256 1.71 0.502 3.36 0.718 4.93h89.348c1.81-7.25 4.1-13.37 6.43-16.56 2.67-3.64 3.1-3.47 11.82 4.56 4.97 4.59 9.43 7.92 9.93 7.41 0.51-0.51-0.85-3.83-3.03-7.41-3.07-5.03-3.95-9.77-3.93-21 0-7.97 0.55-17.76 1.21-21.75l1.19-7.25 12.78 0.04c7.04 0.01 14.1 0.92 15.69 2 2.15 1.45 1.54 1.63-2.41 0.71-8.8-2.04-6.14 2.68 2.91 5.16 5.77 1.58 12.2 1.73 21.56 0.47 12.46-1.68 13.69-1.51 18.57 2.59 2.87 2.42 5.78 3.84 6.46 3.16 2.94-2.94 1.13-24.75-2.72-32.69-5.57-11.51-8.93-13.94-8.93-6.47 0 9.19-2.28 9.95-17.13 5.6-10.83-3.18-16.49-3.72-28.97-2.75l-15.5 1.22-4-9.5-4-9.47 14.47-5.38c18.32-6.81 25.31-5.31 36.97 7.94 8.96 10.18 9.96 9.24 3.03-2.88-2.63-4.6-4.09-8.06-3.25-7.71 0.84 0.34 11.46 5.61 23.63 11.71 12.17 6.11 24.75 11.57 27.94 12.16 3.35 0.62 0.92-1.01-5.76-3.87-16.67-7.17-16.58-8.41 0.38-5.63 18.84 3.09 45.59 3.33 58.66 0.53 8.88-1.9 10.53-1.73 15.06 1.63 2.8 2.07 7.13 6.75 9.59 10.37l4.47 6.56-9.31 1.38c-5.13 0.76-13.44 2.63-18.47 4.16-8.8 2.66-9.04 2.62-7.16-0.91 1.08-2.02 2.79-3.66 3.82-3.66 1.02 0 1.87-0.77 1.87-1.72 0-3.34-16.45 1.97-21.75 7.03-5.84 5.59-9.43 15.57-7.81 21.76 0.94 3.6 1.24 3.66 3.37 0.74 2.05-2.79 3.27-2.87 9.72-0.74 7.33 2.41 29.34 1.62 37.06-1.35 3.13-1.2 2.98-1.55-1.28-2.75-2.65-0.75 5.62-0.86 18.38-0.28s23.44 1.25 23.75 1.5c1.78 1.44-4.55 29.12-11.66 51.34h69.16c0.11-0.72 0.22-1.53 0.31-2.09l1.13-6.75 2.59 8.69 0.03 0.15h1.94l-0.28-3.59c-0.51-6.67-1.44-14.48-2.07-17.37-0.85-3.93 0.37-2.84 4.79 4.37 7.47 12.21 7.52 10.61 0.18-5.75-3.18-7.1-5.13-12.56-4.34-12.16 14.79 7.63 29.2 10.73 38.5 8.28l5.44-1.43-7.53-2.69c-4.16-1.48-10.5-4.9-14.07-7.62-9.33-7.12-21.63-24.2-23-31.91l-1.18-6.63 5.31 6.47c6.42 7.83 19.33 19.97 23.75 22.31 1.77 0.94-0.39-2.12-4.78-6.78-12.9-13.69-19.81-24.7-23.94-38.06-2.13-6.89-3.45-12.99-2.91-13.53 2.12-2.11 8.86 6.45 12.47 15.84 4.75 12.34 5.45 5.55 1.13-11.03-4.51-17.31-9.68-25.57-27.63-44.18-17.43-18.08-17.76-19.17-6.62-22.13 2.86-0.76 5.77 0.03 8.22 2.25 4.62 4.19 4.81 8.18 0.59 12.84-3 3.32-2.97 3.54 0.81 3.54 12.53 0 15.53-18.53 5.41-33.44l-4.6-6.78 8.38-3.19c4.6-1.76 9.49-4.6 10.91-6.31 2.28-2.77 1.99-2.98-2.69-1.82-7.45 1.86-28.56 3.94-28.56 2.82 0-0.52 6.15-3.34 13.65-6.28 14.96-5.88 16.55-7.57 4.57-4.88-10.46 2.35-53.41 7.91-54.29 7.03-0.38-0.38 3.99-3.83 9.75-7.65 12.93-8.59 23.9-18.08 26.54-23 1.92-3.61 1.78-3.61-4.22-0.5-9.27 4.79-36.67 8.66-61.54 8.71-30.39 0.06-32.86-3.9-6.68-10.71 14.58-3.8 14.85-3.77 21.81 2.09l5.97 5v-4.85c0-2.9-1.97-6.44-4.91-8.74-5.42-4.27-23.22-8.8-26.53-6.76-1.41 0.88-1.58 0.12-0.53-2.37 2.7-6.39 3.59-25.34 1.25-26.78-1.35-0.84-2.16 0.45-2.16 3.44 0 7.04-11.34 15.89-26.25 20.5-13.4 4.13-44.81 5.28-54.9 2-2.8-0.91 2.16-1.12 11.78-0.5 16.33 1.04 35.31-1.73 37.62-5.47 0.59-0.96-1.21-0.84-4 0.22-6.02 2.29-39.62 2.6-39.62 0.37 0-0.85 4.31-3.11 9.56-5 5.26-1.89 10.71-4.82 12.09-6.53 2.21-2.71 2.03-2.9-1.34-1.5-8.78 3.64-30.8 5.03-60.22 3.84l-31.25-1.25 5.69-8.06c3.12-4.42 6.08-11.48 6.59-15.72l0.94-7.72-3.31 8.69-3.31 8.69-1.53-10.25c-0.85-5.65-2.83-12.613-4.38-15.47l-2.81-5.188zm101.62 202.63c4 0.01 14.55 2.35 20.94 5.22 6.56 2.94 7.01 3.47 2.91 3.5-5.57 0.03-18.67-3.83-24.22-7.13-1.91-1.13-1.45-1.6 0.37-1.59zm83.03 22.78c1.61 0.04 2.61 1.27 3.25 3.72 0.78 2.96-0.16 4.45-3.75 5.81-6.83 2.6-7.8 2.25-3.5-1.22 3.59-2.89 3.52-2.98-1.9-2.12l-5.69 0.9 4.72-3.62c3.06-2.36 5.27-3.51 6.87-3.47z"
    shouldBeIdentity(pd)
  end

  it "should return all points" do
    pd = "M100,200 C100,100 250,100 250,200"
    rpath = Pathby.cshape(pd)
    points = rpath.allpoints
    points.should eq [Pathby::Point.new(100,200),Pathby::Point.new(100,100),Pathby::Point.new(250,100),Pathby::Point.new(250,200)]
  end

  it "should return correct simple bbox" do
    Point = Pathby::Point
    pd = "M100,200 C100,100 250,100 250,200"
    rpath = Pathby.cshape(pd)
    points = rpath.simplebbox
    points.should eq [Point.new(100,100),Point.new(250,200)]
  end

  it "should be translated by -100 -100 if rezerod" do
    Point = Pathby::Point
    pd = "M100,200 C100,100 250,100 250,200"
    rpath = Pathby.cshape(pd)
    rpath.rezero
    points = rpath.simplebbox
    points.should eq [Point.new(0,0),Point.new(150,100)]
  end

  it "should after rezero always min to 0,0" do
    pd = "m500 500 -0.07 5.844c-0.12 9.414-11.92 24.284-27.03 34.034-11.27 7.28-12.56 6.98-6.81-1.5 5.26-7.75 9.29-20.44 8.1-25.47-0.52-2.18-1.3-1.33-2.35 2.56-2.89 10.69-12.18 21.46-27.44 31.85-8.31 5.66-17.917 12.92-21.371 16.15l-6.281 5.91v-8c0-4.39 0.838-10.21 1.874-12.94 1.037-2.73 1.5-4.97 1.032-4.97-1.601 0-5.475 8.7-7.782 17.41l-2.312 8.68-1.406-9.65c-0.765-5.32-1.568-10.45-1.813-11.44-0.896-3.61-8.736 11.77-12.031 23.63-2.744 9.87-3.029 14.37-1.5 23.62 1.846 11.16 1.813 11.35-1.781 8.1-5.269-4.77-11.165-17.03-13.094-27.32-1.517-8.08-1.578-7.82-0.781 3.22 0.824 11.42 5.55 23.54 13.406 34.31 2.743 3.77 2.495 3.85-9.188 3.41l-12-0.44 9.688 2.78c5.315 1.53 10.359 2.8 11.219 2.85 3.424 0.18-0.845 3.52-5.875 4.59-2.945 0.63-7.968 3.31-11.156 5.97l-5.782 4.84 10.156-3.78c5.593-2.08 12.995-3.79 16.438-3.78l6.25 0.03-9.062 5.28c-10.697 6.26-16.579 13.27-18.282 21.78l-1.25 6.19 8.063-5.34c4.43-2.93 8.482-4.89 9-4.38 1.575 1.58-10.02 16.3-16.844 21.41-3.527 2.64-9.633 5.93-13.563 7.31-9.367 3.3-7.524 5.69 4.376 5.69 5.252 0 9.531 0.72 9.531 1.59 0 0.88-2.982 5.09-6.657 9.38-7.158 8.36-24.21 17.06-30.312 15.47-1.9945-0.51-3.63-0.27-3.63 0.57 0 2.09 7.2536 3.87 15.969 3.91h7.218l-8.687 11.81c-4.781 6.49-8.6875 12.51-8.6875 13.37s-0.5852 3.15-1.3125 5.1c-0.8268 2.21 1.6902 0.84 6.75-3.69 4.451-3.99 8.378-7.25 8.719-7.25s-1.365 5.89-3.782 13.09c-2.416 7.21-4.87 19.15-5.468 26.57l-1.094 13.5 3.719-16.44c3.757-16.7 9.287-32.87 6.937-20.28-3.362 18-3.048 43.34-0.125 57.15h5.594c-0.045-0.82-0.096-1.61-0.156-2.56-0.594-9.35 0.001-16.19 1.781-20.53 2.617-6.39 2.727-6.06 6.344 18.16 0.256 1.71 0.502 3.36 0.718 4.93h89.348c1.81-7.25 4.1-13.37 6.43-16.56 2.67-3.64 3.1-3.47 11.82 4.56 4.97 4.59 9.43 7.92 9.93 7.41 0.51-0.51-0.85-3.83-3.03-7.41-3.07-5.03-3.95-9.77-3.93-21 0-7.97 0.55-17.76 1.21-21.75l1.19-7.25 12.78 0.04c7.04 0.01 14.1 0.92 15.69 2 2.15 1.45 1.54 1.63-2.41 0.71-8.8-2.04-6.14 2.68 2.91 5.16 5.77 1.58 12.2 1.73 21.56 0.47 12.46-1.68 13.69-1.51 18.57 2.59 2.87 2.42 5.78 3.84 6.46 3.16 2.94-2.94 1.13-24.75-2.72-32.69-5.57-11.51-8.93-13.94-8.93-6.47 0 9.19-2.28 9.95-17.13 5.6-10.83-3.18-16.49-3.72-28.97-2.75l-15.5 1.22-4-9.5-4-9.47 14.47-5.38c18.32-6.81 25.31-5.31 36.97 7.94 8.96 10.18 9.96 9.24 3.03-2.88-2.63-4.6-4.09-8.06-3.25-7.71 0.84 0.34 11.46 5.61 23.63 11.71 12.17 6.11 24.75 11.57 27.94 12.16 3.35 0.62 0.92-1.01-5.76-3.87-16.67-7.17-16.58-8.41 0.38-5.63 18.84 3.09 45.59 3.33 58.66 0.53 8.88-1.9 10.53-1.73 15.06 1.63 2.8 2.07 7.13 6.75 9.59 10.37l4.47 6.56-9.31 1.38c-5.13 0.76-13.44 2.63-18.47 4.16-8.8 2.66-9.04 2.62-7.16-0.91 1.08-2.02 2.79-3.66 3.82-3.66 1.02 0 1.87-0.77 1.87-1.72 0-3.34-16.45 1.97-21.75 7.03-5.84 5.59-9.43 15.57-7.81 21.76 0.94 3.6 1.24 3.66 3.37 0.74 2.05-2.79 3.27-2.87 9.72-0.74 7.33 2.41 29.34 1.62 37.06-1.35 3.13-1.2 2.98-1.55-1.28-2.75-2.65-0.75 5.62-0.86 18.38-0.28s23.44 1.25 23.75 1.5c1.78 1.44-4.55 29.12-11.66 51.34h69.16c0.11-0.72 0.22-1.53 0.31-2.09l1.13-6.75 2.59 8.69 0.03 0.15h1.94l-0.28-3.59c-0.51-6.67-1.44-14.48-2.07-17.37-0.85-3.93 0.37-2.84 4.79 4.37 7.47 12.21 7.52 10.61 0.18-5.75-3.18-7.1-5.13-12.56-4.34-12.16 14.79 7.63 29.2 10.73 38.5 8.28l5.44-1.43-7.53-2.69c-4.16-1.48-10.5-4.9-14.07-7.62-9.33-7.12-21.63-24.2-23-31.91l-1.18-6.63 5.31 6.47c6.42 7.83 19.33 19.97 23.75 22.31 1.77 0.94-0.39-2.12-4.78-6.78-12.9-13.69-19.81-24.7-23.94-38.06-2.13-6.89-3.45-12.99-2.91-13.53 2.12-2.11 8.86 6.45 12.47 15.84 4.75 12.34 5.45 5.55 1.13-11.03-4.51-17.31-9.68-25.57-27.63-44.18-17.43-18.08-17.76-19.17-6.62-22.13 2.86-0.76 5.77 0.03 8.22 2.25 4.62 4.19 4.81 8.18 0.59 12.84-3 3.32-2.97 3.54 0.81 3.54 12.53 0 15.53-18.53 5.41-33.44l-4.6-6.78 8.38-3.19c4.6-1.76 9.49-4.6 10.91-6.31 2.28-2.77 1.99-2.98-2.69-1.82-7.45 1.86-28.56 3.94-28.56 2.82 0-0.52 6.15-3.34 13.65-6.28 14.96-5.88 16.55-7.57 4.57-4.88-10.46 2.35-53.41 7.91-54.29 7.03-0.38-0.38 3.99-3.83 9.75-7.65 12.93-8.59 23.9-18.08 26.54-23 1.92-3.61 1.78-3.61-4.22-0.5-9.27 4.79-36.67 8.66-61.54 8.71-30.39 0.06-32.86-3.9-6.68-10.71 14.58-3.8 14.85-3.77 21.81 2.09l5.97 5v-4.85c0-2.9-1.97-6.44-4.91-8.74-5.42-4.27-23.22-8.8-26.53-6.76-1.41 0.88-1.58 0.12-0.53-2.37 2.7-6.39 3.59-25.34 1.25-26.78-1.35-0.84-2.16 0.45-2.16 3.44 0 7.04-11.34 15.89-26.25 20.5-13.4 4.13-44.81 5.28-54.9 2-2.8-0.91 2.16-1.12 11.78-0.5 16.33 1.04 35.31-1.73 37.62-5.47 0.59-0.96-1.21-0.84-4 0.22-6.02 2.29-39.62 2.6-39.62 0.37 0-0.85 4.31-3.11 9.56-5 5.26-1.89 10.71-4.82 12.09-6.53 2.21-2.71 2.03-2.9-1.34-1.5-8.78 3.64-30.8 5.03-60.22 3.84l-31.25-1.25 5.69-8.06c3.12-4.42 6.08-11.48 6.59-15.72l0.94-7.72-3.31 8.69-3.31 8.69-1.53-10.25c-0.85-5.65-2.83-12.613-4.38-15.47l-2.81-5.188zm101.62 202.63c4 0.01 14.55 2.35 20.94 5.22 6.56 2.94 7.01 3.47 2.91 3.5-5.57 0.03-18.67-3.83-24.22-7.13-1.91-1.13-1.45-1.6 0.37-1.59zm83.03 22.78c1.61 0.04 2.61 1.27 3.25 3.72 0.78 2.96-0.16 4.45-3.75 5.81-6.83 2.6-7.8 2.25-3.5-1.22 3.59-2.89 3.52-2.98-1.9-2.12l-5.69 0.9 4.72-3.62c3.06-2.36 5.27-3.51 6.87-3.47z"
    rpath = Pathby.cshape(pd)
    rpath.rezero
    points = rpath.simplebbox
    points[0].should eq Point.new(0,0)
  end
end

describe "Pathby::Shape" do
  it "should return nice json" do
    puts Pathby.convert2JSON(:face, :hair => "M0 50C0 0 100 0 100 50", :glasses => "M100,200 C100,100 250,100 250,200 S400,300 400,200 M 100,100").inspect
  end
end



def casteljau(points,t)

  poiredpoints = points[0..-2].zip points[1..-1]
  midpoints = poiredpoints.map{|p1,p2| [(p1[0]+p2[0])*t,(p1[1]+p2[1])*t]}
end

