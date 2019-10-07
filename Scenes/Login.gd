extends Control

onready var network = get_node("/root/Network")
onready var resultLabel = $Menu/Result

func _ready():
	pass

func _on_Button_pressed():
	var user = get_node("Menu/Login/Input/InputUser").text
	var password = get_node("Menu/Login/Input/InputPassword").text
	
	if user.length() <= 0 || password.length() <= 0:
		resultLabel.text = "Username and/or password are incorrect"
		return
	
	var command = {"Player": user, "Command": "login", "Password": password}
	
	network.client_command(command)

func _on_ButtonRegister_pressed():
	var user = get_node("Menu/Login/Input/InputUser").text
	var password = get_node("Menu/Login/Input/InputPassword").text
	
	if user.length() <= 0 || password.length() <= 0:
		resultLabel.text = "Username and/or password are incorrect"
		return
	
	var command = {"Player": user, "Command": "register", "Password": password}
	
	network.client_command(command)
