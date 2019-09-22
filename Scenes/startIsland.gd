extends Node2D

onready var network = get_node("/root/Network")

var player = null;

var tile_maps = []

func _ready():
	OS.set_window_size(Vector2(1280,720))
	
	#Get tile maps
	var child
	for child in get_children():
		#if child == typeof(TileMap):
		tile_maps.append(child)
	
	#Create player
	var playerScene = load("res://Scenes/Player.tscn")
	player = playerScene.instance()
	add_child(player)
	network.player_added(player)