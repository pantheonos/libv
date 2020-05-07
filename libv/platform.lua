local VANILLA_isValidColorIndex = memoize(function(idx)
  expect(1, idx, {
    "ColorIndex"
  }, "VANILLA_isValidColorIndex")
  return not idx.gfx
end)
local LGFX_isValidColorIndex = VANILLA_isValidColorIndex
local GFX_isValidColorIndex = memoize(function(idx)
  expect(1, idx, {
    "ColorIndex"
  }, "GFX_isValidColorIndex")
  return idx.gfx
end)
local isValidColorIndex
isValidColorIndex = function(idx)
  local _exp_0 = PLATFORM()
  if "VANILLA" == _exp_0 then
    return VANILLA_isValidColorIndex(idx)
  elseif "LGFX" == _exp_0 then
    return LGFX_isValidColorIndex(idx)
  elseif "GFX" == _exp_0 then
    return GFX_isValidColorIndex(idx)
  end
end
local VANILLA_setPixel
VANILLA_setPixel = function(x, y, pixel)
  expect(1, x, {
    "number"
  }, "VANILLA_setPixel")
  expect(2, y, {
    "number"
  }, "VANILLA_setPixel")
  expect(3, pixel, {
    "VPixel"
  }, "VANILLA_setPixel")
  if not (VANILLA_isValidColorIndex(pixel.bg)) then
    error("Invalid color index " .. tostring(pixel.bg.value))
  end
  term.setCursorPos(x, y)
  term.setBackgroundColor(pixel.bg.value)
  term.setTextColor((pixel.fg.value or term.getTextColor()))
  return term.write((pixel.char or " "))
end
local LGFX_setPixel
LGFX_setPixel = function(x, y, pixel)
  expect(1, x, {
    "number"
  }, "LGFX_setPixel")
  expect(2, y, {
    "number"
  }, "LGFX_setPixel")
  expect(3, pixel, {
    "VPixel"
  }, "LGFX_setPixel")
  if not (LGFX_isValidColorIndex(pixel.bg)) then
    error("Invalid color index " .. tostring(pixel.bg.value))
  end
  return term.setPixel(x, y, pixel.bg.value)
end
local GFX_setPixel
GFX_setPixel = function(x, y, pixel)
  expect(1, x, {
    "number"
  }, "GFX_setPixel")
  expect(2, y, {
    "number"
  }, "GFX_setPixel")
  expect(3, pixel, {
    "VPixel"
  }, "GFX_setPixel")
  kprint("GFX_setPixel was called")
  if not (GFX_isValidColorIndex(pixel.bg)) then
    error("Invalid color index " .. tostring(pixel.bg.value))
  end
  return term.setPixel(x, y, pixel.bg.value)
end
local setPixel
setPixel = function(x, y, pixel)
  local _exp_0 = PLATFORM()
  if "VANILLA" == _exp_0 then
    return VANILLA_setPixel(x, y, pixel)
  elseif "LGFX" == _exp_0 then
    return LGFX_setPixel(x, y, pixel)
  elseif "GFX" == _exp_0 then
    return GFX_setPixel(x, y, pixel)
  end
end
local VANILLA_drawPixels
VANILLA_drawPixels = function(sx, sy, pixels)
  expect(1, sx, {
    "number"
  }, "VANILLA_drawPixels")
  expect(2, sy, {
    "number"
  }, "VANILLA_drawPixels")
  expect(3, pixels, {
    "table"
  }, "VANILLA_drawPixels")
  for y, line in ipairs(pixels) do
    for x, pixel in ipairs(line) do
      VANILLA_setPixel((x + sx), (y + sy), pixel)
    end
  end
end
local LGFX_drawPixels
LGFX_drawPixels = function(sx, sy, pixels)
  expect(1, sx, {
    "number"
  }, "LGFX_drawPixels")
  expect(2, sy, {
    "number"
  }, "LGFX_drawPixels")
  expect(3, pixels, {
    "table"
  }, "LGFX_drawPixels")
  local final = { }
  for y, line in ipairs(pixels) do
    final[y] = { }
    for x, pixel in ipairs(line) do
      if not (LGFX_isValidColorIndex(pixel.bg)) then
        error("Invalid color index " .. tostring(pixel.bg.value))
      end
      final[y][x] = pixel.bg.value
    end
  end
  return term.drawPixels(sx, sy, final)
end
local GFX_drawPixels
GFX_drawPixels = function(sx, sy, pixels)
  local PIXEL_CACHE = { }
  expect(1, sx, {
    "number"
  }, "GFX_drawPixels")
  expect(2, sy, {
    "number"
  }, "GFX_drawPixels")
  expect(3, pixels, {
    "table"
  }, "GFX_drawPixels")
  local final = { }
  for y, line in ipairs(pixels) do
    final[y] = { }
    for x, pixel in ipairs(line) do
      kprint("-> " .. tostring(x) .. "," .. tostring(y) .. ": {" .. tostring(pixel.bg.value) .. ", " .. tostring(pixel.fg.value) .. ", '" .. tostring(pixel.char) .. "'}")
      do
        local val = PIXEL_CACHE[pixel]
        if val then
          final[y][x] = val
        else
          if not (GFX_isValidColorIndex(pixel.bg)) then
            error("Invalid color index " .. tostring(pixel.bg.value))
          end
          PIXEL_CACHE[pixel] = pixel.bg.value
          final[y][x] = pixel.bg.value
        end
      end
    end
  end
  knewlog("drawPixels", inspect(final))
  return term.drawPixels(sx, sy, final)
end
local drawPixels
drawPixels = function(sx, sy, pixels)
  local _exp_0 = PLATFORM()
  if "VANILLA" == _exp_0 then
    return VANILLA_drawPixels(sx, sy, pixels)
  elseif "LGFX" == _exp_0 then
    return LGFX_drawPixels(sx, sy, pixels)
  elseif "GFX" == _exp_0 then
    return GFX_drawPixels(sx, sy, pixels)
  end
end
local getScreenSize
getScreenSize = function()
  local w, h = term.getSize()
  local _exp_0 = PLATFORM()
  if "VANILLA" == _exp_0 then
    return w, h
  else
    return w * 6, h * 9
  end
end
return {
  PLATFORM = PLATFORM,
  VANILLA_isValidColorIndex = VANILLA_isValidColorIndex,
  LGFX_isValidColorIndex = LGFX_isValidColorIndex,
  GFX_isValidColorIndex = GFX_isValidColorIndex,
  isValidColorIndex = isValidColorIndex,
  VANILLA_setPixel = VANILLA_setPixel,
  LGFX_setPixel = LGFX_setPixel,
  GFX_setPixel = GFX_setPixel,
  setPixel = setPixel,
  VANILLA_drawPixels = VANILLA_drawPixels,
  LGFX_drawPixels = LGFX_drawPixels,
  GFX_drawPixels = GFX_drawPixels,
  drawPixels = drawPixels,
  getScreenSize = getScreenSize
}
