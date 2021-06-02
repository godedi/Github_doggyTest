extends KinematicBody
# Vanliga variabler
var direction = Vector3.FORWARD
var velocity = Vector3.ZERO

var vertical_velocity = 0
var gravity = 27
var jump_magnitude = 6

var movement_speed = 0
var walk_speed = 3.5
var acceleration = 4
var angular_acceleration = 7 
var push = 0.8

var flyingDog = false
var dogGravity = true

var state_machine

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	# Kod för vilka knappar som styr hunden.
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		
		direction = Vector3(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
				0,
				Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()
		
		movement_speed = walk_speed
		state_machine.travel("RUN")
	else:
		movement_speed = 0
		
	# ?
	velocity = lerp(velocity,direction * movement_speed, delta * acceleration)
	if movement_speed == 0 and flyingDog == false:
		state_machine.travel("Idle")
	elif movement_speed > 0 and vertical_velocity == 0 and flyingDog == false:
		state_machine.travel("RUN")
		
	# ?
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP,false,4,0.785398,false)
	
	#Gör att hundens "Mesh" roterar. Så att den tittar åt det håll man går. 
	$"Armature/Skeleton/doggo".rotation.y = lerp_angle($"Armature/Skeleton/doggo".rotation.y, atan2(-direction.z, direction.x), delta * angular_acceleration) 
	
	#Gör så att hunden kan interagera med rigidbodies.
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)
	
	#Fixar gravitation i spelet när dogGravity är true, annars går gravitationen uppåt (flyger).
	if dogGravity == true:
		if !is_on_floor():
			vertical_velocity -= gravity * delta
	else: vertical_velocity += gravity * delta
		
		
	# Gör så att hunden hoppar.
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = jump_magnitude
			state_machine.travel("jump")
	
	# gör så att hunden skäller.
	if Input.is_action_just_pressed("skall"):
		$AudioStreamPlayer.play()
		
		
		# Tillfällig kod för att flyga. 
	if Input.is_action_just_pressed("grab"):
		$Armature/Skeleton/doggo/node_id12.visible = true
		$Collision_balloon.disabled = false
		flyingDog = true
		if flyingDog == true:
			dogGravity = false
	if dogGravity == false:
		state_machine.travel("Flying")
		$"Camera1".set_target($"Armature/2")
		

#Byter scen till the end när du träffar tårtan
func _on_Cake_body_entered(body):
	if body.name == "dog":
		get_tree().change_scene("res://TheEnd.tscn")
	

# Byter till flyg animationen när hunden träffar ballongerna.
func _on_balloons_body_entered(body):
	if body.name == "doggo":
		$Armature/Skeleton/doggo/node_id12.visible = true
		$Collision_balloon.disabled = false
		flyingDog = true
		if flyingDog == true:
			dogGravity = false
	if dogGravity == false:
		state_machine.travel("Flying")
		$"Camera1".set_target($"Armature/2")
			

	# Gör så att kakorna försvinner när hunden träffar dem.
func _on_cookie_body_entered(body):
	if body.name == "doggo":
		queue_free()
