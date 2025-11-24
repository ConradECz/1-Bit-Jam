extends Node2D

@onready var animation_intro = $AnimationPlayer
#var TitleMusic

func _ready():
	animation_intro.play()
	#TitleMusic = AudioPlayer.play_music("res://audio/music/Jared-Title-Theme.ogg")
	get_tree().create_timer(10).timeout.connect(start_main_scene)
	
func start_main_scene():
	get_tree().change_scene_to_file("res://Intro/main_menu.tscn")
