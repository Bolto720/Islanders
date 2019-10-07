extends Node

onready var manager = get_node("/root/Manager")

var connection = null
var peerstream = null

var player
var playerPosX
var playerPosY
var playerName

var networkPlayers = {}
var creatures = {}

func _ready():
	print("Start client TCP")
    # Connect
	connection = StreamPeerTCP.new()
	connection.connect_to_host("127.0.0.1", 8082)
	#connection.connect_to_host("159.65.53.223", 8082)
	peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(connection)

func _process(delta):
	if connection.is_connected_to_host():
		if connection.get_available_bytes() > 0:
			var command = connection.get_var()
			server_command(command)

func server_command(command):
	if command == null:
		return;
	
	if typeof(command) == TYPE_ARRAY:
		for creature in command:
			if !creatures.has(creature.Creature):
				add_creature(creature)
			
			var c = creatures.get(creature.Creature)
			# Check to see if the creature is in the visible area for the player
			if player.in_visible_area(creature.Pos_x, creature.Pos_y):
				c.try_move(creature.Pos_x, creature.Pos_y)
			else:
				c.visible = false
	else:	
		var res = {}
		res = command
	
		if res.Command == "login":
			if res.Result == false:
				get_tree().get_root().get_node("Login/Menu/Result").text = "Unable to login"
				return
			
			playerName = res.Player
			playerPosX = res.Pos_x
			playerPosY = res.Pos_y
			manager.load_scene(res.Island)
		
		elif res.Command == "register":
			if res.Result == false:
				get_tree().get_root().get_node("Login/Menu/Result").text = "Unable to register"
			else:
				get_tree().get_root().get_node("Login/Menu/Result").text = "Registration complete, you can now login"
		elif res.Command == "broadcast" || res.Command == "enter":
			if !networkPlayers.has(res.Player):
				add_network_player(res)
			networkPlayers.get(res.Player).try_move(res.Pos_x, res.Pos_y)
		elif res.Command == "creature":
			if !creatures.has(res.Creature):
				add_creature(res)
			creatures.get(res.Creature).try_move(res.Pos_x, res.Pos_y)
		elif res.Command == "log":
			print(res.Message)
		elif res.Command == "quit":
			remove_network_player(command)
		elif res.Player == player.name:
			player.server_command(command)

func client_command(command):
	peerstream.put_var(command)
	
func player_added(thisPlayer):
	player = thisPlayer
	player.name = playerName
	player.create()
	player.server_command({"Player": player.name, "Command": "move", "Pos_x": playerPosX, "Pos_y": playerPosY})
	
func add_network_player(packetData):
	var networkPlayerScene = load("res://Scenes/NetworkPlayer.tscn")
	var networkPlayer = networkPlayerScene.instance()
	networkPlayer.name = packetData.Player
	networkPlayer.position = Vector2(packetData.Pos_x, packetData.Pos_y)
	networkPlayer.create()
	get_tree().get_root().get_node("Game").add_child(networkPlayer)
	networkPlayers[networkPlayer.name] = networkPlayer
	
func remove_network_player(packetData):
	networkPlayers[packetData.Player].get_parent().remove_child(networkPlayers[packetData.Player])
	networkPlayers.erase(packetData.Player)
	
func add_creature(packetData):
	var creatureScene = load("res://Scenes/Creature1.tscn")
	var creature = creatureScene.instance()
	creature.name = packetData.Creature
	creature.position = Vector2(packetData.Pos_x, packetData.Pos_y)
	creature.create()
	get_tree().get_root().get_node("Game").add_child(creature)
	creatures[creature.name] = creature
	
func remove_creature(packetData):
	creatures[packetData.Creature].get_parent().remove_child(creatures[packetData.Creature])
	creatures.erase(packetData.Creature)