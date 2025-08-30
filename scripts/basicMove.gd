extends CharacterBody2D

@onready var animator = get_node("animator")
@onready var keycards = 10
@onready var player = get_node(".")
const speed = 100
var animationOverride = false

func _process(delta: float) -> void:
	
	var animation = animator.get_animation()
	if((animation == "fight_N" or animation == "fight_S" or animation == "fight_E" or animation == "fight_W") and animator.is_playing()):
		animationOverride = true
	else:
		animationOverride = false
	
	motion_mode = MOTION_MODE_FLOATING
	velocity = Vector2(0, 0)
	
	if(Input.is_action_pressed("left")):
		velocity.x -= 100 * speed * delta
		if(!animationOverride):
			animator.play("flying_W")
		
	if(Input.is_action_pressed("right")):
		velocity.x += 100 * speed * delta
		if(!animationOverride):
			animator.play("flying_E")
		
	if(Input.is_action_pressed("up")):
		velocity.y -= 100 * speed * delta
		if(!animationOverride):
			animator.play("flying_N")
		
	if(Input.is_action_pressed("down")):
		velocity.y += 100 * speed * delta
		if(!animationOverride):
			animator.play("flying_S")
		
	if(Input.is_action_pressed("sneak")):
		velocity *= 0.5
		
	#player.set_global_position(pos)
	#print("x: %f y: %f" % [pos.x, pos.y])
	#player.move_and_collide(pos * delta)
	player.move_and_slide()
	
	if(animationOverride):
		return
	
	if(velocity.length() <= 0.01):
		animator.play("idle")
	else:
		animator.stop()
