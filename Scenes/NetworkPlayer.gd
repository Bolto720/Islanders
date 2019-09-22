extends Sprite

var _name;
var TILE_SIZE = 24

func create():	
	get_node("LabelName").text = _name
	
func try_move(x, y):
	self.position = Vector2(x, y)