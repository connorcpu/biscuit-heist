extends Area2D

@onready var player = get_node("../player")

var inside = false

func _on_body_entered(body: Node2D) -> void:
	if(body != player):
		return
	
	inside = true
	get_node("AnimationPlayer").play_backwards("Fade")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name != "Fade" or !inside):
		return
	
	get_tree().change_scene_to_file("res://scenes/winScene.tscn")
