extends Node2D

var level1 = preload("res://scenes/mainScene.tscn").instantiate()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainScene.tscn")

func _on_options_pressed() -> void:
	get_node("CanvasLayer/titleMenu").hide()
	get_node("CanvasLayer/optionsMenu").show()

func _on_quit_pressed() -> void:
	get_tree().quit(0)

func _on_back_pressed() -> void:
	get_node("CanvasLayer/titleMenu").show()
	get_node("CanvasLayer/story").hide()
	get_node("CanvasLayer/optionsMenu").hide()


func _on_story_pressed() -> void:
	get_node("CanvasLayer/titleMenu").hide()
	get_node("CanvasLayer/story").show()
