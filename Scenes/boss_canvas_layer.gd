extends CanvasLayer

const CAMERA_PATH = "../Player/Camera2D" 

@onready var camera_2d: Camera2D = get_node_or_null(CAMERA_PATH) 

func _ready():
	if camera_2d == null:
		print("ERROR")

func _process(_delta):
	if is_instance_valid(camera_2d): 
		scale = camera_2d.zoom
