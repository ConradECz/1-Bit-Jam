extends Node2D





@onready var animated_sprite_2d = $boss_sprite

func _process(_delta):
	
	if is_queued_for_deletion():
		return
