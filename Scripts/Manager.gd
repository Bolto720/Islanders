extends Node

func load_scene(scene):
	get_tree().change_scene("res://Scenes/" + scene + ".tscn")


func can_enter_cell(x,y):
	var game = get_tree().get_root().get_node("Game")
	
	var tile_map
	for tile_map in game.tile_maps:
		var cell =  tile_map.get_cell(x,y)
		print(cell)
		return true