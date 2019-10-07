extends Node2D

var tile_size = 24
onready var manager = get_node("/root/Manager")
onready var network = get_node("/root/Network")
onready var camera = get_node("Camera2D")

signal moved_signal

var input_timeout = 0.2
var current_input_timeout = 0

var visible_tiles = 10

func create():
	$Pivot/Sprite/LabelName.text = self.name

var speed = 200
var last_position = Vector2()
var target_position = Vector2()
var movedir = Vector2()

func _physics_process(delta):
	if current_input_timeout < input_timeout:
		current_input_timeout += delta
	position += speed * movedir * delta
	if position.distance_to(last_position) >= tile_size:
		position = target_position
	if position == target_position:
		movedir = Vector2.ZERO
		last_position = position
		target_position += movedir * tile_size

func _input(event):
	if !event.is_pressed():
		return
	
	# Wheel Up Event
	if event.is_action_pressed("zoom_in"):
		_zoom_camera(-1)
	# Wheel Down Event
	elif event.is_action_pressed("zoom_out"):
		_zoom_camera(1)
	
	# If the current input timeout is less than the default, don't do anything
	if current_input_timeout < input_timeout:
		return
		
	current_input_timeout = 0
		
	if event.is_action("Left"):
		try_move(-1,0)
	elif event.is_action("Right"):
		try_move(1,0)
	elif event.is_action("Up"):
		try_move(0,-1)
	elif event.is_action("Down"):
		try_move(0,1)		
	
# Zoom Camera
func _zoom_camera(dir):
	#if camera.zoom <= Vector2(1,1) && dir < 0:
	#	camera.zoom = Vector2(1,1)
	#	return
	#if camera.zoom >= Vector2(5,5) && dir > 0:
	#	camera.zoom = Vector2(5,5)
	#	return
	camera.zoom += Vector2(0.1, 0.1) * dir

func try_move(dx, dy):
	var x = self.position.x + (dx * tile_size)
	var y = self.position.y + (dy * tile_size)	
	if !manager.can_enter_cell(x / tile_size, y / tile_size):
		return

	var command = {"Player": self.name, "Command": "move", "Pos_x": x, "Pos_y": y}
	
	network.client_command(command);

func server_command(command):
	var res = {}
	res = command
	
	if res.Command == "move":
		move_to(Vector2(res.Pos_x, res.Pos_y))

func move_to(target_pos):
	target_position = target_pos
	movedir.x = (target_position.x - self.position.x) / tile_size
	movedir.y = (target_position.y - self.position.y) / tile_size
	emit_signal("moved_signal")
	#return
	#set_process(false)
	#var move_direction = (target_position - position).normalized()
	#$Tween.interpolate_property($Pivot, "position", - move_direction * tile_size, Vector2(), input_timeout, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#position = target_position
	#$Tween.start()
	#yield($Tween, "tween_completed")
	#yield(get_tree().create_timer(input_timeout), "timeout")
	#set_process(true)
	#emit_signal("moved_signal")

func in_visible_area(x, y):
	if x < self.position.x - (visible_tiles * tile_size):
		return false
	elif x > self.position.x + (visible_tiles * tile_size):
		return false
	elif y < self.position.y - (visible_tiles * tile_size):
		return false
	elif y > self.position.y + (visible_tiles * tile_size):
		return false	
	return true	