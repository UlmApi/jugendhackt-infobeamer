gl.setup(1920, 200)

logo = resource.load_image("jh-ulm.png")
font = resource.load_font("OpenSans-Bold.ttf")


local clock = (function()
  local base_time = N.base_time or 0

  local function set(time)
    base_time = tonumber(time) - sys.now()
  end

  util.data_mapper{
    ["clock/midnight"] = function(since_midnight)
        set(since_midnight)
    end;
  }

  local left = 0

  local function get()
    local time = (base_time + sys.now()) % 86400
    return string.format("%d:%02d", math.floor(time / 3600), math.floor(time % 3600 / 60))
  end

  return {
    get = get;
    set = set;
  }
end)()


function node.render()
  --gl.clear(1, 1, 1, 0.25)
  logo:draw(40, 30, 546, 190)
  font:write(1400, 30, clock.get(), 160, 0,0,0,1)
end
