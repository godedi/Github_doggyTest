extends KinematicBody
# Vanliga variabler
var direction = Vector3.FORWARD
var velocity = Vector3.ZERO

var vertical_velocity = 0
var gravity = 28
var jump_magnitude = 10

var movement_speed = 0
var walk_speed = 4
var run_speed = 8
var acceleration = 4
var angular_acceleration = 7 
var push = 2

var flyingDog = false
var dogGravity = true

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
			
		#Kan inte komma ihåg vad denna gjorde.
	velocity = lerp(velocity,direction * movement_speed, delta * acceleration)
		
		#Tror den gjorde hunden mer flytade när den byter riktning. 
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP,false,4,0.785398,false)
	
	#Gör att hundens "Mesh" roterar. Så att den tittar åt det håll man går. 
	$doggo.rotation.y = lerp_angle($doggo.rotation.y, atan2(-direction.z, direction.x), delta * angular_acceleration) 
	$doggo_flyger.rotation.y = lerp_angle($doggo_flyger.rotation.y, atan2(-direction.z, direction.x), delta * angular_acceleration)
	
	
	#Gör så att hunden kan hoppa upp på en rigidbody
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)
	
	#Fixar gravitation i spelet. 
	if dogGravity == true:
		if !is_on_floor():
			vertical_velocity -= gravity * delta
	else: vertical_velocity += gravity * delta
		
		
		#Mekanismen för att hoppa.
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = jump_magnitude
			
	
	if Input.is_action_just_pressed("skall"):
		$AudioStreamPlayer.play()
		
		
		
	if Input.is_action_just_pressed("grab"):
		$doggo.visible = false
		$doggo_flyger.visible = true
		$CollisionShape_flying.disabled = false
		flyingDog = true
		if flyingDog == true:
			dogGravity = false
			

#Byter scen till the end när du nuddar tårtan
func _on_Cake_body_entered(body):
	if body.name == "dog":
		get_tree().change_scene("res://TheEnd.tscn")
	


func _on_balloons_body_entered(body):
	if body.name == "dog":
		$doggo.visible = false
		$doggo_flyger.visible = true
		$CollisionShape_flying.disabled = false
		flyingDog = true
		if flyingDog == true:
			dogGravity = false


func _on_cookie_body_entered(body):
	if body.name == "dog":
		print("mums")
