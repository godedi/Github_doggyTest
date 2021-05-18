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

var weapon_to_spawn
var weapon_to_drop

#Konstiga variabler

onready var reach = $doggo/reach
onready var hand = $doggo/hand

onready var gun_a_hr = preload("res://gun A HR.tscn")
onready var gun_a = preload("res://gun A.tscn")


#Koden för att kolla om du kan greppa saker
#func _process(delta):
#	if reach.is_colliding():
#		if reach.get_collider().get_name() == "gun A":
#			weapon_to_spawn = gun_a_hr.instance()
#		else:
#			weapon_to_spawn = null
#
#	if hand.get_child(0) != null:
#		if hand.get_child(0).get_name() == "gun A HR":
#			weapon_to_drop = gun_a.instance()
#	else: 
#		weapon_to_drop = null
#
#		#koden som gör att du greppar saker
#	if Input.is_action_just_pressed("grab"):
#		if weapon_to_spawn != null:
#			if hand.get_child(0) != null:
#				get_parent().add_child(weapon_to_drop)
#				weapon_to_drop.global_transform = hand.global_translation
#				weapon_to_drop.dropped = true
#			reach.get_collider().queue_free()
#			hand.add_child(weapon_to_spawn)
#			weapon_to_spawn.rotation = hand.rotation
			
#		if Input.is_action_just_pressed("drop"):
#			if weapon_to_drop != null:
				
		
			
			
			
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
	
	#Gör så att hunden kan hoppa upp på en rigidbody
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)
	
	#Fixar gravitation i spelet. 
	if !is_on_floor():
		vertical_velocity -= gravity * delta
		
		#Mekanismen för att hoppa.
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vertical_velocity = jump_magnitude
			
	
	if Input.is_action_just_pressed("skall"):
		$AudioStreamPlayer.play()
		
		
		
	

#Byter scen till the end när du nuddar tårtan
func _on_Cake_body_entered(body):
	if body.name == "dog":
		get_tree().change_scene("res://TheEnd.tscn")
	
