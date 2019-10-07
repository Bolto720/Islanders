extends Node

onready var player = get_node("/root/Manager").player

func _ready():
	player.connect("moved_signal", self, "_update_location")
	
func _update_location():
	$Location.text = "Location: " + str(player.position.x / 24) + ", " + str(player.position.y / 24)


func _on_VSlider_value_changed(value):
	player._zoom_camera(value)
