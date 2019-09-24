extends Node

onready var manager = get_node("/root/Manager")

var connection = null
var peerstream = null

var player
var playerPosX
var playerPosY
var playerName

var networkPlayers = {}

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
	var res = {}
	res = command
	
	if res.Command == "login":
		if res.Result == false:
			get_tree().get_root().get_node("Login/Result").text = "Unable to login"
			return
			
		playerName = res.Player
		playerPosX = res.Pos_x
		playerPosY = res.Pos_y
		manager.load_scene(res.Island)
		
	elif res.Command == "register":
		if res.Result == false:
			get_tree().get_root().get_node("Login/Result").text = "Unable to register"
		else:
			get_tree().get_root().get_node("Login/Result").text = "Registration complete, you can now login"	
	elif res.Command == "broadcast" || res.Command == "enter":
		if !networkPlayers.has(res.Player):
			add_network_player(res)
			player.server_command({"Player": player._name, "Command": "move", "Pos_x": player.position.x, "Pos_y": player.position.y})
		networkPlayers.get(res.Player).try_move(res.Pos_x, res.Pos_y)
	elif res.Command == "quit":
		remove_network_player(command)
	elif res.Player == player._name:
		player.server_command(command)

func client_command(command):
	peerstream.put_var(command)
	
func player_added(thisPlayer):
	player = thisPlayer
	player._name = playerName
	player.create()
	player.server_command({"Player": player._name, "Command": "move", "Pos_x": playerPosX, "Pos_y": playerPosY})
	
func add_network_player(packetData):
	var networkPlayerScene = load("res://Scenes/NetworkPlayer.tscn")
	var networkPlayer = networkPlayerScene.instance()
	networkPlayer.name = packetData.Player
	networkPlayer._name = packetData.Player
	networkPlayer.position = Vector2(packetData.Pos_x, packetData.Pos_y)
	networkPlayer.create()
	get_tree().get_root().get_node("Game").add_child(networkPlayer)
	networkPlayers[networkPlayer._name] = networkPlayer
	
func remove_network_player(packetData):
	networkPlayers[packetData.Player].get_parent().remove_child(networkPlayers[packetData.Player])
	networkPlayers.erase(packetData.Player)