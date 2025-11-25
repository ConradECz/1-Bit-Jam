extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


const TOTAL_DAMAGE_FRAMES = 5 
var current_damage_frame: int = 0
var is_damaged: bool = false
var max_health: int = 5 
var current_health: int = max_health
@export var next_level_scene: PackedScene

func _ready():
	
	animated_sprite.play("Damaged")
	animated_sprite.frame = current_damage_frame
	
	
	if not is_in_group("enemy"):
		print("WARNING: Enemy Area2D is not in the 'enemy' group!")


func die_from_player(_player_node):
	if is_damaged:
		return 

	current_health -= 1

	if current_health <= 0:
		next_level()
	else:
		_advance_damage_frame()

func _advance_damage_frame():

	if current_damage_frame < TOTAL_DAMAGE_FRAMES - 1:
		current_damage_frame += 1
		animated_sprite.frame = current_damage_frame
		print(name, " advanced to frame: ", current_damage_frame)
	
	
	is_damaged = true
	var invulnerability_timer = get_tree().create_timer(0.2) 
	invulnerability_timer.timeout.connect(_on_invulnerability_timeout)

func _on_invulnerability_timeout():
	is_damaged = false

func _destroy_enemy():

	print(name, " has been destroyed!")

	queue_free() 
	
func next_level():
	AudioPlayer.stop_all_music(0.5)
	if next_level_scene:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_packed(next_level_scene)
		queue_free()
	else:
		queue_free()
	
