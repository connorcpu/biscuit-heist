extends Sprite2D

@onready var player = get_node("../player")
@onready var animator = get_node("../player/animator")
@onready var label = get_node("Label")
@onready var path = get_node("path")
@onready var viewArea = get_node("guardViewArea")
@onready var viewAreaIndicator = get_node("Polygon2D")

var routine: Array
var routineIndx = 0
var alert = 0
var lerpVar = 0
var prevRot = 0
var speed = 20
var inside = false
var interuptPathFinding = false

func _ready() -> void:
	for i in path.get_children():
		routine.append(i.get_global_position())

func fixLabel():
	
	
	label.set_rotation(-self.get_rotation())

func _process(delta: float) -> void:
	
	checkPlayerLight()
	fixLabel()
	
	if(interuptPathFinding == false):
		doPathFinding(delta)

	#print("target: %f" % targetDir.angle())
	#print("real target: %f" % targetAngle)
	#print("rotation: %f" % rot)
	#print("length: %f" % dir.length())
	#print("lerp: %f" % lerp)
	
	

func doPathFinding(delta: float):
	
	var pos = self.get_global_position()
	var rot = self.get_rotation() - (PI/2)
	
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
		self.set_global_position(self.get_global_position() + targetDir * delta * speed)
		self.set_rotation(dir.angle() + (PI/2))
		lerpVar = 0
		prevRot = self.get_rotation() - (PI/2)
	else:
		self.set_rotation(lerp_angle(prevRot, targetDir.angle(), lerpVar) + (PI/2))
		lerpVar += delta
		
	if(dir.length() < 5.0):
		routineIndx += 1
		if routineIndx >= routine.size():
			routineIndx = 0

func checkPlayerLight():
	await RenderingServer.frame_post_draw
	var lighthingColour = animator.get_color_difference()
	var rawBrightness = lighthingColour.get_luminance()
	#const expectedMin = -0.165
	#const expectedMax = -0.05
	var brightness = clampf((rawBrightness + 0.165) * 8.7, 0.0, 1.0)

	
	var scaleVect = Vector2(1.5 + (brightness), 1.5 + (brightness))
	viewArea.scale = scaleVect
	viewAreaIndicator.scale = scaleVect

func _on_guard_view_area_body_entered(body: Node2D) -> void:
	if(body != player):
		return
	inside = true
	onAlert()

func onAlert():
	
	var diffVect = self.get_global_position() - player.get_global_position()
	var dist = sqrt(pow(abs(diffVect.x), 2) + pow(abs(diffVect.y), 2))
	print("dist %f" % dist)
		
	if(alert >= 1):
		#gameOver()
		alert = 0
		label.hide()
		return
	
	
	label.show()
	alert = 1
	
	await get_tree().create_timer(0.5).timeout
	
	if(inside == true):
		#gameOver()
		alert = 0
		label.hide()
		return
		
	await get_tree().create_timer(2.5).timeout
	
	alert = 0
	label.hide()


func _on_guard_view_area_body_exited(body: Node2D) -> void:
	if(body != player):
		inside = false
	

func castRay(angle: float) -> Dictionary:
	
	var rayLength = 2
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(self.get_global_position(), self.get_global_position() + (Vector2.from_angle(angle) * rayLength) + Vector2.from_angle(self.get_rotation()), 2)
	var result = space_state.intersect_ray(query)
	
	var line = Line2D.new()
	line.add_point(Vector2(self.get_global_position()))
	line.add_point((Vector2.from_angle(angle) * rayLength) + self.get_position() + Vector2.from_angle(self.get_rotation()))
	#add_child(line)
	
	return result


func gameOver():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _on_hitbox_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		var diffVect = self.get_global_position() - player.get_global_position()
		var dist = sqrt(pow(abs(diffVect.x), 2) + pow(abs(diffVect.y), 2))
		if dist < 30:
			player.incrementKeycards()
			
			animator.stop()
			#animator.play("fight")
			#diff vect points player to guard
			var angle = wrapf(diffVect.angle(), 0.0, TAU)
			if(angle >= PI*0.25 and angle < PI*0.75):
				animator.play("fight_S")
				pass
			elif(angle >= PI*0.75 and angle < PI*1.25):
				#left
				animator.play("fight_W")
				pass
			elif(angle >= PI*1.25 and angle < PI*1.75):
				#down
				animator.play("fight_N")
				pass
			elif(angle >= PI*1.75 or angle < PI*0.25):
				#right
				animator.play("fight_E")
				pass
			
			interuptPathFinding = true
			speed = 0
			await get_tree().create_timer(0.4).timeout
			
			self.hide()
			
			await get_tree().create_timer(45).timeout
			
		else:
			pass
