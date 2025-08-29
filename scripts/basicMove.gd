extends CharacterBody2D

var animator

func _process(delta: float) -> void:
	
	var player = get_node(".")
	animator = get_node("animator")
	
	motion_mode = MOTION_MODE_FLOATING
	velocity = Vector2(0, 0)
	const speed = 100

	#pos = player.get_global_position()
	
	if(Input.is_action_pressed("left")):
		velocity.x -= 100 * speed * delta
		animator.play("flying_W")
		
	if(Input.is_action_pressed("right")):
		velocity.x += 100 * speed * delta
		animator.play("flying_E")
		
	if(Input.is_action_pressed("up")):
		velocity.y -= 100 * speed * delta
		animator.play("flying_N")
		
	if(Input.is_action_pressed("down")):
		velocity.y += 100 * speed * delta
		animator.play("flying_S")
		
	#player.set_global_position(pos)
	#print("x: %f y: %f" % [pos.x, pos.y])
	#player.move_and_collide(pos * delta)
	player.move_and_slide()
	
	if(velocity.length() <= 0.01):
		animator.play("idle")
	else:
		animator.stop()
