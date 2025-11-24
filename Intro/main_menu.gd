extends Node


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")


func _on_quit_pressed() -> void:
	pass # Replace with function body.
