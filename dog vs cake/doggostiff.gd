extends KinematicBody
# Variabler för resten av koden
var direction = Vector3.FORWARD
var velocity = Vector3.ZERO

var vertical_velocity = 0
var gravity = 28
var jump_magnitude = 15

var movement_speed = 0
var walk_speed = 5
var run_speed = 10
var acceleration = 6
var angular_acceleration = 7 


func _physics_process(delta):
	# Själva rörelsekoden. Inte 100 på att höger och vänster mm egentligen är rätt anpassat. Kan vara så att själva lvl är spegelvänd
	if Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		
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
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP)
	
	#Fixar gravitation i spelet. 
	if !is_on_floor():
		vertical_velocity -= gravity * delta
	else:
		vertical_velocity = 0
		
		#Mekanismen för att hoppa.
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			vertical_velocity = jump_magnitude
		
		#Gör att hundens "Mesh" roterar. Så att den tittar åt det håll man går. 
	$doggo.rotation.y = lerp_angle($doggo.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration) 
		
		
		
		
