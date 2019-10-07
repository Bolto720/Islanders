extends Control

onready var player = get_node("/root/Manager").player

func _on_ButtonUp_pressed():
	player.try_move(0,-1)
	

func _on_ButtonDown_pressed():
	player.try_move(0,1)


func _on_ButtonLeft_pressed():
	player.try_move(-1,0)


func _on_ButtonRight_pressed():
	player.try_move(1,0)