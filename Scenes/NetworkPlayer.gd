extends Sprite

func create():	
	get_node("LabelName").text = name
	
func try_move(x, y):
	self.position = Vector2(x, y)