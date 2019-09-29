extends Node

func load_scene(scene):
	get_tree().change_scene("res://Scenes/" + scene + ".tscn")

func can_enter_cell(x,y):
	var game = get_tree().get_root().get_node("Game")
	if game.tile_map[x][y] == 0:
		return false
	elif game.tile_map[x][y] == 3:
		return false
	return true