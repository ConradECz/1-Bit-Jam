extends Node2D

const SPEED = 50

var direction = 1

@onready var ray_cast_down = $RayCastDown 
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_spirte_2d = $AnimatedSprite2D

func _process(_delta):
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1

	position.x += direction * SPEED * _delta
