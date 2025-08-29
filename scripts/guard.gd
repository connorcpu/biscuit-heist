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
	
	checkPlayerLight()
	fixLabel()
	#doRaycast()
	
	#var routine = [Vector2(10, 10), Vector2(510, 10), Vector2(240, 330),Vector2(510, 510), Vector2(10, 510)]
	var routine = [Vector2(1713, 742), Vector2(1837, 747)]
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
	#print("real target: %f" % targetAngle)
	#print("rotation: %f" % rot)
	#print("length: %f" % dir.length())
	#print("lerp: %f" % lerp)
	
	if(dir.length() < 5.0):
		routineIndx += 1
		if routineIndx >= routine.size():
			routineIndx = 0

func checkPlayerLight():
	await RenderingServer.frame_post_draw
	var lighthingColour = get_node("../player/animator").get_color_difference()
	var rawBrightness = lighthingColour.get_luminance()
	#const expectedMin = -0.165
	#const expectedMax = -0.05
	var brightness = clampf((rawBrightness + 0.165) * 8.7, 0.0, 1.0)
	var viewArea = get_node("guardViewArea")
	var viewAreaIndicator = get_node("Polygon2D")
	
	var scaleVect = Vector2(0.5 + (brightness/2), 0.5 + (brightness/2))
	viewArea.scale = scaleVect
	viewAreaIndicator.scale = scaleVect * 2

func doRaycast():
	var angleDelta = (PI/5)
	var FOV = (PI * 2) / 5
	var i = 0 
	#while(i < FOV/angleDelta):
	while(i < 2):
		var ray = castRay(((get_node(".").get_rotation()) - (FOV/2)) + (i * angleDelta))
		if(ray.size() != 0):
			onAlert()
			break
		i += 1

func _on_guard_view_area_body_entered(body: Node2D) -> void:
	if(body != get_node("../player")):
		return
		
	onAlert()

func onAlert():
	
	var player = get_node("../player")
	var diffVect = get_node(".").get_global_position() - player.get_global_position()
	
	#var dist = sqrt(pow(abs(diffVect.x), 2) + pow(abs(diffVect.y), 2))
	#print("dist %f" % dist)
		
	if(alert >= 1):
		#gameOver()
		return
	
	var label = get_node("Label")
	label.show()
	alert = 1
	
	await get_tree().create_timer(0.5).timeout
	
	if(alert >= 1):
		#gameOver()
		return
		
	await get_tree().create_timer(4.5).timeout
	
	alert = 0
	label.hide()


func _on_guard_view_area_body_exited(body: Node2D) -> void:
	if(alert >= 1):
		alert = 0
	pass # Replace with function body.

func castRay(angle: float) -> Dictionary:
	
	var rayLength = 2
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(get_node(".").get_global_position(), get_node(".").get_global_position() + (Vector2.from_angle(angle) * rayLength) + Vector2.from_angle(get_node(".").get_rotation()), 2)
	var result = space_state.intersect_ray(query)
	
	var line = Line2D.new()
	line.add_point(Vector2(get_node(".").get_global_position()))
	line.add_point((Vector2.from_angle(angle) * rayLength) + get_node(".").get_position() + Vector2.from_angle(get_node(".").get_rotation()))
	#add_child(line)
	
	return result


func gameOver():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
