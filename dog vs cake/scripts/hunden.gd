extends KinematicBody
# Vanliga variabler
var direction = Vector3.FORWARD
var velocity = Vector3.ZERO

var vertical_velocity = 0
var gravity = 28
var jump_magnitude = 15

var movement_speed = 0
var walk_speed = 11
var run_speed = 19
var acceleration = 8
var angular_acceleration = 7 
var push = 2


func _physics_process(delta):
	
	# Själva rörelsekoden. 
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		
		direction = Vector3(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
				0,
				Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()
		
		# Kontroll för hastigheten på hunden
		if Input.is_action_pressed("shift"):
			movement_speed = run_speed
		else:
			movement_speed = walk_speed
	else:
			movement_speed = 0
			
	
	velocity = lerp(velocity,direction * movement_speed, delta * acceleration)
		
	 
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP,false,4,0.785398,false)
	
	#Gör att hundens "Mesh" roterar. Så att den tittar åt det håll man går. 
	$Doggy.rotation.y = lerp_angle($Doggy.rotation.y, atan2(-direction.z, direction.x), delta * angular_acceleration) 
	
	#Gör så att hunden kan hoppa upp på en rigidbody
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)
	
	#Fixar gravitation i spelet. 
	if !is_on_floor():
		vertical_velocity -= gravity * delta
		
	#kod för att hoppa.
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = jump_magnitude
			

#Byter scen till yuummy när du nuddar tårtan
func _on_Cake_body_entered(body):
	if body.name == "Hunden":
		get_tree().change_scene("res://TheEnd.tscn")
