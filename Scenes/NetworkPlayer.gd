extends Node2D

var tile_size = 24

var speed = 50
var last_position = Vector2()
var target_position = Vector2()
var movedir = Vector2()

func create():
	self.visible = false
	get_node("LabelName").text = name
	
func _physics_process(delta):
	position += speed * movedir * delta
	if position.distance_to(last_position) >= tile_size:
		position = target_position
	if position == target_position:
		movedir = Vector2.ZERO
		last_position = position
		target_position += movedir * tile_size

func try_move(x, y):
	self.visible = true
	move_to(Vector2(x, y))
	
func move_to(target_pos):
	target_position = target_pos
	movedir.x = (target_position.x - self.position.x) / tile_size
	movedir.y = (target_position.y - self.position.y) / tile_size