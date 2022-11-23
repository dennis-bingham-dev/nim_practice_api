# Package

version       = "0.1.0"
author        = "Dennis Bingham"
description   = "A test for a web server"
license       = "MIT"
srcDir        = "src"
bin           = @["api_practice"]


# Dependencies

requires "nim >= 1.6.8", "jester", "norm"
