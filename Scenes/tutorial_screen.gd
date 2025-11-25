extends Node2D

func _ready():
	get_tree().create_timer(10).timeout.connect(start_main_scene)
	
func start_main_scene():
	get_tree().change_scene_to_file("res://Intro/main_menu.tscn")


func _on_start_pressed() -> void:
	AudioPlayer.play_sound("res://audio/sfx/jared_uiclick1.wav")
	get_tree().change_scene_to_file("res://Scenes/world_1_1.tscn")
