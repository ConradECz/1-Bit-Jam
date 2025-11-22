extends Node2D

const SPEED = 50

var direction = 1

@onready var ray_cast_down = $RayCastDown 
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite_2d = $AnimatedSprite2D

func _process(_delta):
	
	if is_queued_for_deletion():
		return
	
	if ray_cast_right.is_colliding():
		direction = -1
	elif ray_cast_left.is_colliding():
		direction = 1
	if not ray_cast_down.is_colliding():
		direction *= -1

	position.x += direction * SPEED * _delta
	
	
	if is_instance_valid(animated_sprite_2d):
		if direction == 1:
			animated_sprite_2d.scale.x = 1
		elif direction == -1:
			animated_sprite_2d.scale.x = -1
