extends Sprite

var TILE_SIZE = 24
onready var manager = get_node("/root/Manager")
onready var network = get_node("/root/Network")
onready var camera = get_node("Camera2D")

var _name

func create():
	get_node("LabelName").text = _name
	
	#Create ui elements
	#var interfaceScene = load("res://Scenes/UI/Interface.tscn")
	#var interface = interfaceScene.instance()
	#get_node("Camera2D").add_child(interface)

func _input(event):
	if !event.is_pressed():
		return

	if event.is_action("Left"):
		try_move(-1,0)
	elif event.is_action("Right"):
		try_move(1,0)
	elif event.is_action("Up"):
		try_move(0,-1)
	elif event.is_action("Down"):
		try_move(0,1)
		
	# Wheel Up Event
	if event.is_action_pressed("zoom_in"):
		_zoom_camera(-1)
	# Wheel Down Event
	elif event.is_action_pressed("zoom_out"):
		_zoom_camera(1)

# Zoom Camera
func _zoom_camera(dir):
	if camera.zoom <= Vector2(1,1) && dir < 0:
		camera.zoom = Vector2(1,1)
		return
	if camera.zoom >= Vector2(5,5) && dir > 0:
		camera.zoom = Vector2(5,5)
		return
		
	camera.zoom += Vector2(0.1, 0.1) * dir


func try_move(dx, dy):
	var x = self.position.x + (dx * TILE_SIZE)
	var y = self.position.y + (dy * TILE_SIZE)
	
	if !manager.can_enter_cell(x,y):
		return

	var command = {"Player": _name, "Command": "move", "Pos_x": x, "Pos_y": y}
	
	network.client_command(command);
	
func server_command(command):
	var res = {}
	res = command
	
	if res.Command == "move":
		self.position = Vector2(res.Pos_x, res.Pos_y)