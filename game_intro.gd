extends Node2D

@onready var animation_intro = $AnimationPlayer


func _ready():
	animation_intro.play()
	AudioPlayer.play_music("res://audio/music/Jared-Intro-Jingles.ogg", -5, 0)
	get_tree().create_timer(10).timeout.connect(start_main_scene)
	
func start_main_scene():
	get_tree().change_scene_to_file("res://Intro/main_menu.tscn")
