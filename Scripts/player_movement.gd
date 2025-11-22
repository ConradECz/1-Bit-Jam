extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
	
func jump():
	velocity.y = JUMP_VELOCITY
	
func _physics_process(delta):
	
	# FOR THE MEANTIME UNTIL ATTACK IS FIXED
	if Input.is_action_just_pressed("attack"):
		animated_sprite.play("Attack")
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		AudioPlayer.play_sound("res://audio/sfx/jared_jump1.wav")

	# Direction: -1, 0, 1	
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Player
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Animations for Player
	if not animated_sprite.get_animation() == "Attack" or animated_sprite.is_playing() == false: #FOR THE MEANTIME UNTIL ATTACK IS FIXED
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Run")
		else:
			animated_sprite.play("Jump")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
