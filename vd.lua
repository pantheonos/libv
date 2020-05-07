local config = loadConfig("vd")
local libv = {
  grid = require("libv.grid"),
  frame = require("libv.frame"),
  buffer = require("libv.buffer"),
  render = require("libv.render"),
  platform = require("libv.platform")
}
local echo = kdprint("vd")
echo("starting server")
local Grid
Grid = libv.grid.Grid
local GRID
local _exp_0 = config.gridSize
if "screen" == _exp_0 then
  GRID = Grid(libv.platform.getScreenSize())
else
  GRID = Grid(config.gridSize[1], config.gridSize[2])
end
local Frame
Frame = libv.frame.Frame
local FRAME
local _exp_1 = config.frameSize
if "screen" == _exp_1 then
  FRAME = Frame(libv.platform.getScreenSize())
else
  FRAME = Frame(config.frameSize[1], config.frameSize[2])
end
local Reference
Reference = libv.grid.Reference
local newBuffer = Reference(GRID)
local capture
capture = libv.frame.capture
local newCapture = ((capture(FRAME))(GRID))
vrh = {
  GRID = GRID,
  FRAME = FRAME
}
local Buffer
Buffer = libv.buffer.Buffer
vrh.Window = function(def)
  expect(1, def.x, {
    "number"
  }, "vrh.Window")
  expect(2, def.y, {
    "number"
  }, "vrh.Window")
  expect(3, def.d, {
    "number"
  }, "vrh.Window")
  local x, y, d = def.x, def.y, def.d
  def.x, def.y, def.d = nil, nil, nil
  local window = Buffer(def)
  newBuffer(x, y, d, window)
  return window
end
vrh.render = function()
  local screen = libv.frame.merge(newCapture(1, 1))
  return libv.render.render(screen)
end
return PA_BREAK()
