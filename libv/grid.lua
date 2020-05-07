local Grid
Grid = function(w, h)
  expect(1, w, {
    "number"
  }, "Grid")
  expect(2, h, {
    "number"
  }, "Grid")
  local this = typeset({
    w = w,
    h = h,
    references = { }
  }, "VGrid")
  return this
end
local Reference
Reference = function(grid)
  return function(x, y, d, buffer)
    expect(1, grid, {
      "VGrid"
    }, "Reference")
    expect(2, x, {
      "number"
    }, "Reference")
    expect(3, y, {
      "number"
    }, "Reference")
    expect(4, d, {
      "number"
    }, "Reference")
    expect(5, buffer, {
      "VBuffer"
    }, "Reference")
    if x < 1 then
      error("x must be above 0")
    end
    if y < 1 then
      error("y must be above 0")
    end
    grid.references[tostring(x) .. "," .. tostring(y) .. "," .. tostring(d)] = buffer
  end
end
local fromPoint
fromPoint = function(xyd)
  expect(1, xyd, {
    "string"
  }, "fromPoint")
  local x, y, d = xyd:match("(%d+),(%d+),(%d+)")
  return (tonumber(x)), (tonumber(y)), (tonumber(d))
end
local toPoint
toPoint = function(x, y, d)
  return tostring(x) .. "," .. tostring(y) .. "," .. tostring(d)
end
local toPoint1
toPoint1 = function(xyd)
  return tostring(xyd.x) .. "," .. tostring(xyd.y) .. "," .. tostring(xyd.d)
end
local moveReference
moveReference = function(grid)
  return function(oxyd, xyd)
    expect(1, grid, {
      "VGrid"
    }, "moveReference")
    expect(2, oxyd, {
      "table"
    }, "moveReference")
    expect(3, xyd, {
      "table"
    }, "moveReference")
    if not (grid.references[toPoint1(oxyd)].movable) then
      return false
    end
    if not (grid.references[toPoint1(oxyd)]) then
      return false
    end
    grid.references[toPoint1(xyd)] = grid.references[toPoint1(oxyd)]
    grid.references[toPoint1(oxyd)] = nil
  end
end
local getReference
getReference = function(grid)
  return function(x, y, d)
    expect(1, grid, {
      "VGrid"
    }, "getReference")
    expect(2, x, {
      "number"
    }, "getReference")
    expect(3, y, {
      "number"
    }, "getReference")
    expect(4, d, {
      "number"
    }, "getReference")
    return grid.references[tostring(x) .. "," .. tostring(y) .. "," .. tostring(d)]
  end
end
local getIntersecting
getIntersecting = function(grid)
  return function(x, y)
    expect(1, grid, {
      "VGrid"
    }, "getIntersecting")
    expect(2, x, {
      "number"
    }, "getIntersecting")
    expect(3, y, {
      "number"
    }, "getIntersecting")
    local intersecting = { }
    for point, buf in pairs(grid.references) do
      local _continue_0 = false
      repeat
        local px, py, pd = fromPoint(point)
        if (px > x) or (py > 1) then
          _continue_0 = true
          break
        end
        intersecting[pd] = {
          gx = x,
          gy = y,
          bx = x - px,
          by = y - py,
          buffer = buf
        }
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    return intersecting
  end
end
return {
  Grid = Grid,
  Reference = Reference,
  moveReference = moveReference,
  getReference = getReference,
  fromPoint = fromPoint,
  toPoint = toPoint,
  toPoint1 = toPoint1,
  getIntersecting = getIntersecting
}
