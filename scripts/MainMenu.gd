extends Node2D

var level1 = preload("res://scenes/mainScene.tscn").instantiate()
var play = false

@onready var animator = get_node("CanvasLayer/CanvasModulate/AnimationPlayer")

func _on_play_pressed() -> void:
	play = true
	animator.play_backwards("fade")

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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(play):
		get_tree().change_scene_to_file("res://scenes/mainScene.tscn")
