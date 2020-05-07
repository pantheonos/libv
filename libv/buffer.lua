local Buffer
Buffer = function(self)
  self.visible = self.visible or true
  self.movable = self.movable or true
  self.resizable = self.resizable or true
  self.writable = self.writable or true
  expect(0, self, {
    "table"
  }, "Buffer")
  expect(1, self.w, {
    "number"
  }, "Buffer")
  expect(2, self.h, {
    "number"
  }, "Buffer")
  expect(4, self.visible, {
    "boolean"
  }, "Buffer")
  expect(5, self.movable, {
    "boolean"
  }, "Buffer")
  expect(6, self.resizable, {
    "boolean"
  }, "Buffer")
  expect(7, self.writable, {
    "boolean"
  }, "Buffer")
  if self.w < 1 then
    error("Width must be above 0")
  end
  if self.h < 1 then
    error("Height must be above 0")
  end
  self.buffer = { }
  return typeset(self, "VBuffer")
end
local resize
resize = function(self)
  return function(w, h)
    expect(1, self, {
      "VBuffer"
    }, "resize")
    expect(2, w, {
      "number"
    }, "resize")
    expect(3, h, {
      "number"
    }, "resize")
    if w < 1 then
      error("Width must be above 0")
    end
    if h < 1 then
      error("Height must be above 0")
    end
    if not (self.resizable) then
      return false
    end
    self.w, self.h = w, h
    return true
  end
end
local setPixel
setPixel = function(self)
  return function(x, y, pixel)
    expect(1, self, {
      "VBuffer"
    }, "setPixel")
    expect(2, x, {
      "number"
    }, "setPixel")
    expect(3, y, {
      "number"
    }, "setPixel")
    expect(4, pixel, {
      "VPixel"
    }, "setPixel")
    if not (self.writable) then
      return false
    end
    if (x > self.w) or (y > self.h) then
      return false
    end
    if not (self.buffer[x]) then
      self.buffer[x] = { }
    end
    self.buffer[x][y] = pixel
    return true
  end
end
local unsetPixel
unsetPixel = function(self)
  return function(x, y)
    expect(1, self, {
      "VBuffer"
    }, "unsetPixel")
    expect(2, x, {
      "number"
    }, "unsetPixel")
    expect(3, y, {
      "number"
    }, "unsetPixel")
    if not (self.writable) then
      return false
    end
    if (x > self.w) or (y > self.h) then
      return false
    end
    if self.buffer[x] and self.buffer[x][y] then
      self.buffer[x][y] = nil
      if 0 == table.getn(self.buffer[x]) then
        self.buffer[x] = nil
      end
    end
    return true
  end
end
local drawPixels
drawPixels = function(self)
  return function(sx, sy, pixels)
    expect(1, self, {
      "VBuffer"
    }, "drawPixels")
    expect(2, sx, {
      "number"
    }, "drawPixels")
    expect(3, sy, {
      "number"
    }, "drawPixels")
    expect(4, pixels, {
      "table"
    }, "drawPixels")
    if not (self.writable) then
      return false
    end
    if (sx > self.w) or (sy > self.h) then
      return false
    end
    for x, row in npairs(pixels) do
      for y, pixel in npairs(row) do
        setPixel(self, x, y, pixel)
      end
    end
  end
end
return {
  Buffer = Buffer,
  resize = resize,
  setPixel = setPixel,
  unsetPixel = unsetPixel,
  drawPixels = drawPixels
}
