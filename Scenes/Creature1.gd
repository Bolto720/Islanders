extends Sprite

var TILE_SIZE = 24

func create():
	self.visible = false
	get_node("LabelName").text = self.name

func try_move(x, y):
	self.visible = true
	self.position = Vector2(x, y)