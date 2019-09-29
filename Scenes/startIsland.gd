extends Node2D

onready var network = get_node("/root/Network")

var player = null;

var tile_map = []
const tiles = {
	'water': 0,
	'sand': 1,
	'grass': 2,
	'rock': 3
	}

func _ready():
	OS.set_window_size(Vector2(1280,720))
	
	_load_tile_map()	
	_create_player()	
	
func _load_tile_map():
	var x = 0
	var map_file = File.new()
	map_file.open("res://Art/TileMaps/island1.json", File.READ)
	while not map_file.eof_reached():
		var current_line = parse_json(map_file.get_line())
		if current_line == null:
			continue
		
		var y = 0
		tile_map.append([])
		tile_map[x] = []
		for value in current_line:
			tile_map[x].append([])
			var tile_index = _get_tile_index(value)
			$TileMap.set_cellv(Vector2(x, y), tile_index)
			tile_map[x][y] = tile_index
			y = y + 1
		x = x + 1		
	map_file.close()
	$TileMap.update_bitmask_region()

func _get_tile_index(value):
	if value == 0:
		return tiles.water
	elif value == 1:
		return tiles.sand
	elif value == 2:
		return tiles.grass
	else:
		return tiles.rock
		
func _create_player():
	var playerScene = load("res://Scenes/Player.tscn")
	player = playerScene.instance()
	add_child(player)
	network.player_added(player)