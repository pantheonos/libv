local ColorIndex
ColorIndex = require("libcolor").ColorIndex
local isValidColorIndex
isValidColorIndex = require("libv.platform").isValidColorIndex
local Pixel
Pixel = function(bg, fg, char)
  if char == nil then
    char = " "
  end
  expect(1, bg, {
    "ColorIndex"
  }, "Pixel")
  expect(2, fg, {
    "ColorIndex",
    "nil"
  }, "Pixel")
  expect(3, char, {
    "string"
  }, "Pixel")
  if not (isValidColorIndex(bg)) then
    error("Invalid color index " .. tostring(bg.value))
  end
  if fg then
    if not (isValidColorIndex(fg)) then
      error("Invalid foreground color index " .. tostring(bg.value))
    end
  end
  return typeset({
    bg = bg,
    fg = fg,
    char = char
  }, "VPixel")
end
local comparePixels
comparePixels = function(pa, pb)
  if pa.bg.value ~= pb.bg.value then
    return false
  end
  if PLATFORM() == "VANILLA" then
    if pa.fg.value ~= pb.fg.value then
      return false
    end
    if pa.char ~= pb.char then
      return false
    end
  end
  return true
end
return {
  Pixel = Pixel,
  comparePixels = comparePixels
}
