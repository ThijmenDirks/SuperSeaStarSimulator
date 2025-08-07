#class_name MoveableBlock extends RigidBody2D
##
##
#var move_speed: int
#var direction: Vector2
#var travelled_distance : float
#var grid_width = 40
#var is_moving: bool = false
#var space_check_area: Area2D # space_check_area ?
#
#@onready var up_space_check_area = $UpSpaceCheckArea
#@onready var right_space_check_area = $RightSpaceCheckArea
#@onready var down_space_check_area = $DownSpaceCheckArea
#@onready var left_space_check_area = $LeftSpaceCheckArea
## ^ these four areas masken op layer 2
#@onready var area = $Area2D
#@onready var static_body = $StaticBody2D
#
#
#func _ready() -> void:
	##up_space_check_area.add_collision_exception_with(static_body)
	##right_space_check_area.add_collision_exception_with(static_body)
	##down_space_check_area.add_collision_exception_with(static_body)
	##left_space_check_area.add_collision_exception_with(static_body)
#
	#static_body.add_collision_exception_with(up_space_check_area)
	#static_body.add_collision_exception_with(right_space_check_area)
	#static_body.add_collision_exception_with(down_space_check_area)
	#static_body.add_collision_exception_with(left_space_check_area)
#
#
### Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#freeze = false
	#static_body.set_collision_layer_value(2, false)
	##print("move ", is_moving)
	#if is_moving:
		##print("move/   position:   ", position, "   movement:   ", direction * delta * move_speed, "   end_pos:  ", position + direction * delta * move_speed)
		#position += direction * delta * move_speed
		#travelled_distance += abs(direction.length() * delta * move_speed)
		##print("moveable_block travelled:   ", travelled_distance, "  position:  ", position)
		#if grid_width - travelled_distance < delta * move_speed * 1.1: #travelled_distance >= grid_width:#grid_width - travelled_distance < delta * move_speed * 2: #travelled_distance >= grid_width:
			##print("movemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemovemove")
			##print("moveable_block travelled:   ", travelled_distance, "  position:  ", position)
			##if direction == Vector2(1, 0):
				###position.x = (grid_width - travelled_distance)
				##position.x -= (travelled_distance - grid_width)
			##else:
				###position.y += (grid_width - travelled_distance)
				##position.y -= (travelled_distance - grid_width)
			#position += direction.normalized() * (grid_width - travelled_distance)
			## Snap de blokpositie expliciet naar het grid
			##position = (position / grid_width).round() * grid_width
#
			#move_speed = 0
			#travelled_distance = 0
			#is_moving = false
			#
			#linear_velocity = Vector2.ZERO
			##sleeping = true
	#else:
		#linear_velocity = Vector2.ZERO
	#var c = area.get_overlapping_bodies()
	#print("spac   ", c)
	#if c:
		#c = c[0]
#
		#var my_pos = global_position
		#var other_pos = c.get_position()
		#var diff = other_pos - my_pos
#
		#if abs(diff.x) > abs(diff.y):
			#if diff.x > 0:
				##print("Character is to the RIGHT of the rigidbody")
				#direction = Vector2(-1, 0)
				#space_check_area = left_space_check_area
			#else:
				##print("Character is to the LEFT of the rigidbody")
				#direction = Vector2(1, 0)
				#space_check_area = right_space_check_area
		#else:
			#if diff.y > 0:
				##print("Character is BELOW the rigidbody")
				#direction = Vector2(0, -1)
				#space_check_area = up_space_check_area
			#else:
				##print("Character is ABOVE the rigidbody")
				#direction = Vector2(0, 1)
				#space_check_area = down_space_check_area
		## en dan hierzo kijken voor ruimte
		##static_body.set_collision_layer_value(2, false)
		## komt natuurlijk door physics frame
		#await get_tree().physics_frame
		#await get_tree().physics_frame
		#if space_check_area.get_overlapping_bodies():
			#print("space   ", space_check_area.get_overlapping_bodies()[0].name, "   ", space_check_area.get_overlapping_bodies()[0].get_collision_layer_value(2), "   ", randf())
			#freeze = true
			#static_body.set_collision_layer_value(2, true)
			#is_moving = false
			#move_speed = 0
			##set_process(false)
			##PROCESS_MODE_DISABLED
			##linear_velocity = Vector2(0, 0)
			##self.MODE_STATIC
			##$".".linear_lock_x = true
			##$".".linear_lock_y = true
			##$".".angular_lock = true
			#return
		#else:
			##set_collision_layer_value(2, false)
			#linear_velocity = Vector2.ZERO
#
			#is_moving = true
			#move_speed = c.speed
#
		##sleeping = true
#
				##var push_force = 10
				##c.get_collider().apply_central_impulse(-c.get_normal() * push_foararce)
#
#
#func _on_body_entered(body: Node) -> void:
	#return
	##print("Character iss")
	#if is_moving:
		#return
	##print("Character is")
#
	##for i in get_slide_collision_count():
		##var c = get_slide_collision(i)
		##var collider = c.get_collider()
	#if body:
		##print("is to the   ", c.get_position())
		#is_moving = true
		#move_speed = body.speed
		#var my_pos = global_position
		#var other_pos = body.get_position()
		#var diff = other_pos - my_pos
#
		#if abs(diff.x) > abs(diff.y):
			#if diff.x > 0:
				##print("Character is to the RIGHT of the rigidbody")
				#direction = Vector2(-1, 0)
			#else:
				##print("Character is to the LEFT of the rigidbody")
				#direction = Vector2(1, 0)
		#else:
			#if diff.y > 0:
				##print("Character is BELOW the rigidbody")
				#direction = Vector2(0, -1)
			#else:
				##print("Character is ABOVE the rigidbody")
				#direction = Vector2(0, 1)
#
#
##func move(to_direction: Vector2, speed : int): # but now this func is not needed anymore
	##if is_moving:
		##return
	### hier nog ff kijken of er wel ruimte is
	##
	##is_moving = true
	##move_speed = speed
	##direction = to_direction
	##move_and#
	##position += to_direction * speed * delta
	##is_moving = false
#
#
##func _physics_process(_delta):
	##if abs(linear_velocity.x) <= 70 and abs(linear_velocity.y) <= 70:
		##position = position.snapped(Vector2.ONE*40)
#
#
##func move(from_direction: String, body: Node2D):
	##print("moveable_block")
	##if from_direction == "left":
		##speed = body.velocity.normalized().x * body.speed
		##direction = Vector2(1, 0)
	##if from_direction == "up":
		##speed = body.velocity.normalized().y * body.speed
		##direction = Vector2(0, 1)
	##if from_direction == "right":
		##speed = body.velocity.normalized().x * body.speed
		##direction = Vector2(1, 0)
	##if from_direction == "down":
		##speed = body.velocity.normalized().y * body.speed
		##direction = Vector2(0, 1)
	###if speed == 0:
		###pass
	###else:
		###return
##
##
##func _on_left_push_area_body_entered(body: Node2D) -> void:
	##if body is Player:
		###speed = body.velocity.normalized().x * body.speed
		###direction = body.velocity.normalized()
		##move("left", body)
##
##
##func _on_up_push_area_body_entered(body: Node2D) -> void:
	##if body is Player:
		###speed = body.velocity.normalized().y * body.speed
		###direction = body.velocity.normalized()
		##move("up", body)
##
##
##func _on_right_push_area_body_entered(body: Node2D) -> void:
	##if body is Player:
		###direction = body.velocity.normalized()
		###speed = body.velocity.normalized().x * body.speed
		##move("right", body)
##
##
##func _on_down_push_area_body_entered(body: Node2D) -> void:
	##if body is Player:
		###direction = body.velocity.normalized()
		###speed = body.velocity.normalized().y * body.speed
		##move("down", body)





class_name MoveableBlock extends RigidBody2D

var move_speed: int
var direction: Vector2
var travelled_distance : float
var grid_width = 40
var is_moving: bool = false
var space_check_area: Area2D

@onready var up_space_check_area = $UpSpaceCheckArea
@onready var right_space_check_area = $RightSpaceCheckArea
@onready var down_space_check_area = $DownSpaceCheckArea
@onready var left_space_check_area = $LeftSpaceCheckArea
@onready var area = $Area2D
@onready var static_body = $StaticBody2D

func _ready() -> void:
	custom_integrator = true

	static_body.add_collision_exception_with(up_space_check_area)
	static_body.add_collision_exception_with(right_space_check_area)
	static_body.add_collision_exception_with(down_space_check_area)
	static_body.add_collision_exception_with(left_space_check_area)

var last_position: Vector2 # for debugging

func _process(_delta: float) -> void:
	#print("pposition   ", position.x)
	#if position.x < last_position.x:
		#print("pposition   ", position.x, "   last pposition   ", last_position.x)
	freeze = false
	static_body.set_collision_layer_value(2, false)
	last_position = position
	# --- UITGESCHAKELD: handmatige position-update via _process ---
	# if is_moving:
	#     position += direction * delta * move_speed
	#     travelled_distance += abs(direction.length() * delta * move_speed)
	#     if grid_width - travelled_distance < delta * move_speed * 1.1:
	#         position += direction.normalized() * (grid_width - travelled_distance)
	#         move_speed = 0
	#         travelled_distance = 0
	#         is_moving = false
	#         linear_velocity = Vector2.ZERO
	# else:
	#     linear_velocity = Vector2.ZERO
	# ---------------------------------------------------------------

	var c = area.get_overlapping_bodies()
	if c:
		print("ccc   ", c)
		c = c[0]

		var my_pos = global_position
		var other_pos = c.get_position()
		var diff = other_pos - my_pos

		if abs(diff.x) > abs(diff.y):
			if diff.x > 0:
				direction = Vector2(-1, 0)
				space_check_area = left_space_check_area
			else:
				direction = Vector2(1, 0)
				space_check_area = right_space_check_area
		else:
			if diff.y > 0:
				direction = Vector2(0, -1)
				space_check_area = up_space_check_area
			else:
				direction = Vector2(0, 1)
				space_check_area = down_space_check_area

		#await get_tree().physics_frame
		#await get_tree().physics_frame

		if space_check_area.get_overlapping_bodies():
			print("cccc")
			freeze = true
			static_body.set_collision_layer_value(2, true)
			is_moving = false
			move_speed = 0
			return
		print("ccc   ", c)
		#if not c is Spell:
		if true:
			linear_velocity = Vector2.ZERO
			is_moving = true
			move_speed = c.speed


# this func has been made by chatGPT
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#if is_moving:
		#var delta = state.step
		#var movement = direction * move_speed * delta
		#state.transform.origin += movement
		#travelled_distance += movement.length()
#
		#if travelled_distance >= grid_width:
			## Snap exact naar het grid
			#state.transform.origin = (state.transform.origin / grid_width).round() * grid_width
			#is_moving = false
			#travelled_distance = 0
			#move_speed = 0
	if is_moving:
		print("ccc", move_speed)
		var delta = state.step
		var movement = direction * move_speed * delta
		var new_distance = travelled_distance + movement.length()

		if new_distance >= grid_width:
			var overshoot = new_distance - grid_width
			# Corrigeer de beweging zodat we exact op het grid eindigen
			movement -= direction.normalized() * overshoot
			state.transform.origin += movement

			is_moving = false
			travelled_distance = 0
			move_speed = 0

			# Optional: force snap naar grid voor zekerheid
			#state.transform.origin = (state.transform.origin / grid_width).round() * grid_width
		else:
			state.transform.origin += movement
			travelled_distance = new_distance


func _on_body_entered(body: Node) -> void:
	return

#hij jittert nog stees een beetje.. op het momentdat het blok aankomt en		if travelled_distance >= grid_width:
			## Snap exact naar het grid
			#state.transform.origin = (state.transform.origin / grid_width).round() * grid_width
			#is_moving = false
			#travelled_distance = 0
			#move_speed = 0
#
#wordt gerund, gaat het blok 2.7 pixels achteruit
