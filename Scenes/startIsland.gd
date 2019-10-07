extends Node2D

onready var manager = get_node("/root/Manager")

var tile_size = 24
var tile_map = []
const tiles = {
	'deep_water': 0,
	'water': 1,
	'shallow_water': 2,
	'sand': 3,
	'light_grass': 4,
	'grass': 5,
	'rock': 6
	}
	
var object_map = []
	
var time_of_day = 12.00
	
func _physics_process(delta):
	time_of_day += 0.001
	if time_of_day >= 24:
		time_of_day = 0.00
	if time_of_day > 19.00:
		$Light2D.energy -= 0.001
	elif time_of_day > 3.00 && $Light2D.energy < 0.8:
		$Light2D.energy += 0.001	

func _ready():
	OS.set_window_size(Vector2(1280,720))	
	_load_tile_map()
	_load_object_map()
	manager.connect("player_updated", self, "_player_updated")
	
func _player_updated():
	_load_area()
	
func _load_object_map():
	var x = 0
	var map_file = File.new()
	map_file.open("res://Art/TileMaps/object_tilemap.tres", File.READ)
	while not map_file.eof_reached():
		var current_line = parse_json(map_file.get_line())
		if current_line == null:
			continue
		
		var y = 0
		object_map.append([])
		object_map[x] = []
		for value in current_line:
			object_map[x].append([])
			var tile_index = value
			object_map[x][y] = tile_index
			y = y + 1
		x = x + 1		
	map_file.close()
	
func _load_tile_map():
	var x = 0
	var map_file = File.new()
	map_file.open("res://Art/TileMaps/island_tilemap.tres", File.READ)
	while not map_file.eof_reached():
		var current_line = parse_json(map_file.get_line())
		if current_line == null:
			continue
		
		var y = 0
		tile_map.append([])
		tile_map[x] = []
		for value in current_line:
			tile_map[x].append([])
			var tile_index = value #_get_tile_index(value)			
			tile_map[x][y] = tile_index
			y = y + 1
		x = x + 1		
	map_file.close()	

func _get_tile_index(value):
	if value == 0:
		return tiles.deep_water
	elif value == 1:
		return tiles.water
	elif value == 2:
		return tiles.shallow_water
	elif value == 3:
		return tiles.sand
	elif value == 4:
		return tiles.light_grass
	elif value == 5:
		return tiles.grass
	else:
		return tiles.rock
		
func _load_area():
	var player = manager.player
	var visible_area = player.visible_tiles * 2
	
	var x_original = (player.position.x / tile_size) - player.visible_tiles
	var y_original = (player.position.y / tile_size) - player.visible_tiles
	
	var x_start = x_original
	for x in visible_area:
		var y_start = y_original
		for y in visible_area:
			$TerrainMap.set_cellv(Vector2(x_start, y_start), tile_map[x_start][y_start])
			if object_map[x_start][y_start] >= 0:
				$ObjectMap.set_cellv(Vector2(x_start, y_start), object_map[x_start][y_start])
			y_start += 1
		x_start += 1
	$TerrainMap.update_bitmask_region(Vector2(x_original, y_original), Vector2(x_original + visible_area, y_original + visible_area))
	$ObjectMap.update_bitmask_region(Vector2(x_original, y_original), Vector2(x_original + visible_area, y_original + visible_area))