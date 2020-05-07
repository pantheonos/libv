local setPixel, drawPixels
do
  local _obj_0 = require("libv.platform")
  setPixel, drawPixels = _obj_0.setPixel, _obj_0.drawPixels
end
local comparePixels, Pixel
do
  local _obj_0 = require("libv.pixel")
  comparePixels, Pixel = _obj_0.comparePixels, _obj_0.Pixel
end
local getScreenSize
getScreenSize = require("libv.platform").getScreenSize
local ColorIndex
ColorIndex = require("libcolor").ColorIndex
local BASE_PIXEL = Pixel((ColorIndex(0)), (ColorIndex(15)), " ")
local RENDER_CACHE = { }
local RENDER_BIAS = 25
local countDiffPixels
countDiffPixels = function(scra, scrb)
  expect(1, scra, {
    "VScreen"
  }, "countDiffPixels")
  expect(2, scrb, {
    "VScreen"
  }, "countDiffPixels")
  if scra.region.w ~= scrb.region.w then
    error("The two regions are not the same width")
  end
  if scra.region.h ~= scrb.region.h then
    error("The two regions are not the same height")
  end
  local count = 0
  local list = { }
  for x = 1, scra.region.w do
    for y = 1, scra.region.h do
      if not (comparePixels(scra.screen[x][y], scrb.screen[x][y])) then
        count = count + 1
        list[count] = {
          x,
          y
        }
      end
    end
  end
  return list, count
end
local diffScreens
diffScreens = function(scra, scrb)
  expect(1, scra, {
    "VScreen"
  }, "diffScreens")
  expect(2, scrb, {
    "VScreen"
  }, "diffScreens")
  if scra.region.w ~= scrb.region.w then
    error("The two regions are not the same width")
  end
  if scra.region.h ~= scrb.region.h then
    error("The two regions are not the same height")
  end
  local x1, y1, b1
  for x = 1, scra.region.w do
    for y = 1, scra.region.h do
      if not (comparePixels(scra.screen[x][y], scrb.screen[x][y])) then
        x1, y1 = x, y
        b1 = true
        break
      end
    end
    if b1 then
      break
    end
  end
  local x2, y2, b2
  for x = scra.region.w, 1, -1 do
    for y = scra.region.h, 1, -1 do
      if not (comparePixels(scra.screen[x][y], scrb.screen[x][y])) then
        x2, y2 = x, y
        b2 = true
        break
      end
    end
    if b2 then
      break
    end
  end
  local drw, drh = x2 - x1, y2 - y1
  local drarea = drw * drh
  return x1, y1, x2, y2, drarea
end
local render
render = function(scr, bias)
  if bias == nil then
    bias = RENDER_BIAS
  end
  expect(1, scr, {
    "VScreen"
  }, "render")
  RENDER_CACHE[scr.id] = { }
  for x = 1, scr.region.w do
    RENDER_CACHE[scr.id][x] = { }
    for y = 1, scr.region.h do
      RENDER_CACHE[scr.id][x][y] = BASE_PIXEL
    end
  end
  if not (RENDER_CACHE[scr.id]) then
    drawPixels(scr.region.x, scr.region.y, scr.screen)
    return true
  end
  local x1, y1, x2, y2, drarea = diffScreens(scr, RENDER_CACHE[scr.id])
  local iplist, ipcount = countDiffPixels(scr, RENDER_CACHE[scr.id])
  if (drarea - bias) < ipcount then
    echo("using dirty rectangle method (" .. tostring(drarea - bias) .. " < " .. tostring(ipcount) .. ")")
    local newscr = { }
    for x = 1, (x2 - x1) do
      newscr[x] = { }
      for y = 1, (y2 - y1) do
        newscr[x][y] = scr.screen[x1 + x - 1][y1 + y - 1]
      end
    end
    drawPixels(x1, y1, newscr)
    return true
  else
    echo("setting individual pixels (" .. tostring(drarea - bias) .. " > " .. tostring(ipcount) .. ")")
    for _des_0 in pairs(iplist) do
      local x, y
      x, y = _des_0[1], _des_0[2]
      setPixel(x, y, scr.screen[x][y])
    end
  end
  RENDER_CACHE[scr.id] = scr
end
return {
  countDiffPixels = countDiffPixels,
  diffScreens = diffScreens,
  render = render
}
