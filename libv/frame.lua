local getIntersecting
getIntersecting = require("libv.grid").getIntersecting
local Pixel
Pixel = require("libv.pixel").Pixel
local getScreenSize
getScreenSize = require("libv.platform").getScreenSize
local ColorIndex
ColorIndex = require("libcolor").ColorIndex
local BASE_PIXEL = Pixel((ColorIndex(0)), (ColorIndex(15)), " ")
local FRAME_ID = 0
local Frame
Frame = function(w, h)
  expect(1, w, {
    "number"
  }, "Frame")
  expect(2, h, {
    "number"
  }, "Frame")
  local nw, nh = getScreenSize()
  if (w > nw) or (h > nh) then
    error("Frame is larger than the screen")
  end
  local id = FRAME_ID
  FRAME_ID = FRAME_ID + 1
  return typeset({
    w = w,
    h = h,
    id = id
  }, "VFrame")
end
local capture
capture = function(frame)
  return function(grid)
    return function(x, y)
      expect(1, frame, {
        "VFrame"
      }, "capture")
      expect(2, grid, {
        "VGrid"
      }, "capture")
      expect(3, x, {
        "number"
      }, "capture")
      expect(4, y, {
        "number"
      }, "capture")
      local gi = getIntersecting(grid)
      local region = { }
      local nw, nh = getScreenSize()
      local w
      if (x + frame.w) > nw then
        w = nw - x
      else
        w = frame.w
      end
      local h
      if (y + frame.h) > nh then
        h = nh - y
      else
        h = frame.h
      end
      for px = 1, w do
        local rx = px + x
        region[px] = { }
        for py = 1, h do
          local ry = py + y
          local ied = gi(rx, ry)
          if #ied == 0 then
            region[px][py] = {
              { }
            }
          else
            region[px][py] = ied
          end
          return typeset({
            x = x,
            y = y,
            w = w,
            h = h,
            region = region,
            frame = frame
          }, "VRegion")
        end
      end
    end
  end
end
local lkey
lkey = function(t)
  if not ("table" == typeof(t)) then
    return nil
  end
  local largest = 0
  for n, v in npairs(t) do
    if n > largest then
      largest = n
    end
  end
  return largest
end
local pixelFor
pixelFor = function(int)
  if int.buffer[int.bx] and int.buffer[int.bx][int.by] then
    return int.buffer[int.bx][int.by]
  else
    return nil
  end
end
local merge
merge = function(region)
  expect(1, region, {
    "VRegion"
  }, "merge")
  local screen = {
    id = region.frame.id
  }
  local reg = region.region
  for x = 1, region.w do
    screen[x] = { }
    for y = 1, region.h do
      if reg[x] and reg[x][y] then
        screen[x][y] = pixelFor(reg[x][y][(lkey(reg[x][y])) or 1])
      else
        screen[x][y] = BASE_PIXEL
      end
    end
  end
  return typeset({
    region = region,
    screen = screen
  }, "VScreen")
end
return {
  BASE_PIXEL = BASE_PIXEL,
  Frame = Frame,
  capture = capture,
  merge = merge
}
