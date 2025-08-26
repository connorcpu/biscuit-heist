extends Sprite2D

var routineIndx = 0
var alert = 0
var lerp = 0
var prevRot = 0
var speed = 20

func fixLabel():
	var label = get_node("Label")
	var guard = get_node(".")
	
	label.set_rotation(-guard.get_rotation())

func _process(delta: float) -> void:
	
	fixLabel()
	
	#var routine = [Vector2(10, 10), Vector2(510, 10), Vector2(240, 330),Vector2(510, 510), Vector2(10, 510)]
	var routine = [Vector2(1713, 942), Vector2(1837, 947)]
	var guard = get_node(".")
	
	var pos = guard.get_global_position()
	var rot = guard.get_rotation() - (PI/2)
	
	var dir = Vector2(routine[routineIndx].x - pos.x, routine[routineIndx].y - pos.y)
	var targetDir = (Vector2.from_angle(dir.angle()) * 100 * delta)
	var targetAngle = targetDir.angle()
	
	if(rot < 0):
		rot = (2 * PI) + rot
	if(rot > (2 * PI)):
		rot = rot % (2 * PI)
		
	if(targetAngle < 0):
		targetAngle = (2 * PI) + targetAngle
	if(targetAngle > (2 * PI)):
		targetAngle = targetAngle % (2 * PI)
		
	if(abs(rot - targetAngle) < 0.1):
		guard.set_global_position(guard.get_global_position() + targetDir * delta * speed)
		guard.set_rotation(dir.angle() + (PI/2))
		lerp = 0
		prevRot = guard.get_rotation() - (PI/2)
	else:
		guard.set_rotation(lerp_angle(prevRot, targetDir.angle(), lerp) + (PI/2))
		lerp += delta

	#print("target: %f" % targetDir.angle())
	##print("real target: %f" % targetAngle)
	#print("rotation: %f" % rot)
	#print("length: %f" % dir.length())
	#print("lerp: %f" % lerp)
	
	if(dir.length() < 5.0):
		routineIndx += 1
		if routineIndx >= routine.size():
			routineIndx = 0

func _on_guard_view_area_body_entered(body: Node2D) -> void:
	
	if(body != get_node("../player")):
		return
		
	if(alert >= 1):
		gameOver()
		return
	
	var label = get_node("Label")
	label.show()
	alert = 1
	
	await get_tree().create_timer(0.5).timeout
	
	if(alert >= 1):
		gameOver()
		return
		
	await get_tree().create_timer(4.5).timeout
	
	alert = 0
	label.hide()

func _on_guard_view_area_body_exited(body: Node2D) -> void:
	if(alert >= 1):
		alert = 0
	pass # Replace with function body.

func gameOver():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
