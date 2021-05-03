extends KinematicBody
# Vanliga variabler
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
var push = 2

var weapon_to_spawn
var weapon_to_drop

#Konstiga variabler
onready var head = $head
onready var camera = $head/Camera
onready var reach = $doggo/reach
onready var hand = $doggo/hand

onready var gun_a_hr = preload("res://gun A HR.tscn")
onready var gun_a = preload("res://gun A.tscn")
onready var gun_b_hr = preload("res://gun B HR.tscn")
onready var gun_b = preload("res://gun B.tscn")

#Koden för att kolla om du kan greppa saker
func _process(delta):
	if reach.is_colliding():
		if reach.get_collider().get_name() == "gun A":
			weapon_to_spawn = gun_a_hr.instance()
		elif reach.get_collider().get_name() == "gun B":
			weapon_to_spawn = gun_b_hr.instance()
		else:
			weapon_to_spawn = null
	else:
		weapon_to_spawn = null
	
	if hand.get_child(0) != null:
		if hand.get_child(0).get_name() == "gun A HR":
			weapon_to_drop = gun_a.instance()
		elif hand.get_child(0).get_name() == "gun B HR":
			weapon_to_drop = gun_b.instance()
	else: 
		weapon_to_drop = null
		
		#koden som gör att du greppar saker
	if Input.is_action_just_pressed("grab"):
		if weapon_to_spawn != null:
			if hand.get_child(0) != null:
				get_parent().add_child(weapon_to_drop)
				weapon_to_drop.global_transform = hand.global_transform
				weapon_to_drop.dropped = true
				hand.get_child(0).queue_free()
			reach.get_collider().queue_free()
			hand.add_child(weapon_to_spawn)
			weapon_to_spawn.rotation = hand.rotation
			
		
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
	#$head/Camera.rotation.y = lerp_angle($head/Camera.rotation.y, atan2(-direction.z, direction.x), delta * angular_acceleration) 
	#Gör så att hunden kan hoppa upp på en rigidbody
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)
	
	#Fixar gravitation i spelet. 
	if !is_on_floor():
		vertical_velocity -= gravity * delta
	#else:
	#	vertical_velocity = 0
		
		#Mekanismen för att hoppa.
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = jump_magnitude
		
		
	
