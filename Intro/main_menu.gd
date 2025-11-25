extends Node


func _on_start_pressed() -> void:
	AudioPlayer.play_sound("res://audio/sfx/jared_uiclick1.wav")
	get_tree().change_scene_to_file("res://Scenes/tutorial_screen.tscn")

func _on_quit_pressed() -> void:
	AudioPlayer.play_sound("res://audio/sfx/jared_uiclick1.wav")
	get_tree().quit()
