Gem::Specification.new do |s|
  s.name        = 'pathby'
  s.version     = '0.0.2'
  s.date        = '2012-08-12'
  s.summary     = "Pathby simplifies the interaction with SVG paths by converting all paths to a series of Bezier curves."
  s.description = "Pathby is the a gem to simplify interaction and transoformation of SVG paths"
  s.authors     = ["Graham Jenson"]
  s.email       = 'grahamjenson@maori.geek.nz'
  s.files       = ["lib/transformations.rb",
                  "lib/measurements.rb",
                  "lib/monkeypatchsavage.rb",
                  "lib/pathby.rb",
                  ]

  s.homepage    = 'https://github.com/grahamjenson/pathby'
end