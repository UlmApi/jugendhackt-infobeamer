gl.setup(1920, 1080)

background = resource.load_image("back.jpg")

function node.render()
  util.draw_correct(background, 0, 0, WIDTH, HEIGHT)

  local header = resource.render_child("header")
  header:draw(0,0,1920,200)

  local schedule = resource.render_child("schedule")
  schedule:draw(0,200,1920,970)

end
