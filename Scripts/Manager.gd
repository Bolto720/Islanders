extends Node

onready var network = get_node("/root/Network")

signal player_updated
var player = null;

func load_scene(scene):
	get_tree().change_scene("res://Scenes/" + scene + ".tscn")
	_create_player()
	
func _create_player():
	var playerScene = load("res://Scenes/Player.tscn")
	player = playerScene.instance()
	add_child(player)
	network.player_added(player)
	player.connect("moved_signal", self, "_player_updated")
	
func _player_updated():
	emit_signal("player_updated")

func can_enter_cell(x,y):
	var game = get_tree().get_root().get_node("Game")
	if game.tile_map[x][y] == 1:
		return false
	elif game.tile_map[x][y] == 6:
		return false
	return true