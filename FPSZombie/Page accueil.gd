extends Control

onready var audio = $Audio

func _ready(): 
	audio.play()

func _input(ev):
	if Input.is_key_pressed(KEY_ENTER):
		audio.stop()
		get_tree().change_scene("res://Terrain_jeux.tscn")
