extends Node2D

# Member variables
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	set_process(true)
