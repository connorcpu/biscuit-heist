extends Node2D

var level1 = preload("res://scenes/mainScene.tscn").instantiate()

func _on_play_pressed() -> void:
	#get_tree().get_root().add_child(level1)
	#get_node("/root/Menu").free()
	
	get_tree().change_scene_to_file("res://scenes/mainScene.tscn")
	pass # Replace with function body.

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit(0)
	pass # Replace with function body.
