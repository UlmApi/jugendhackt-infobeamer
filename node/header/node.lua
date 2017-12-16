gl.setup(1920, 200)

logo = resource.load_image("jh-ulm.png")

function node.render()
  --gl.clear(1, 1, 1, 0.25)
  logo:draw(40, 30, 546, 190)
end
