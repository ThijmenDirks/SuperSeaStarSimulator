class_name Slime extends Enemy


@export var animation_tree : AnimationTree # this should go in enemy_classs_definiton

@onready var damage_area: Area2D = $DamageArea

var jump_duration = 1.5 # in sec


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var bodies_in_damage_area = damage_area.get_overlapping_bodies()
	for body in bodies_in_damage_area: # right now this for loop is not really needed, cause the CollisionLayers only target player
		if body is Player:
			body.take_damage(attack_damage, "acid") # might replace it with "damage_type", which then will be set in each slime. # or even set it here as acid andthe nin the rare few slimes that dont deal acid damage set it there again


func slime_move():
	pass


func slime_attack():
	pass


func update_animation_parameters(): # this should go in enemyclassdefintion #(or maybe that wouldnt work if some enmies have stragne animations #(then dont call it))
	if velocity == Vector2.ZERO:
		return
	#print("slime ", animation_tree["parameters/Walk/blend_position"], " ", velocity)
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
	animation_tree["parameters/IdleCast/blend_position"] = velocity
	animation_tree["parameters/WalkCast/blend_position"] = velocity

#
#func _on_damage_area_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.
	#if body is Player:
		#print("slime deals damage")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


## these two are going to each slime, and will be deleteted here
#func request_change_state(new_state):
	#match new_state:
		#STATES.CHASE:
			#change_state(STATES.CHASE)
		#STATES.PATHFIND:
			#change_state(STATES.PATHFIND)
		#STATES.IDLE_STAND:
			#change_state(STATES.IDLE_STAND)
		#STATES.IDLE_WALK:
			#change_state(STATES.IDLE_WALK)
		#STATES.MELEE_ATTACK:
			#change_state(STATES.MELEE_ATTACK)
#
#
#func change_state(new_state):
## right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	#if state_is_locked:
		#return
	#state_history.append(state)
	#match new_state:
		#STATES.IDLE_STAND:
			#state = STATES.IDLE_STAND
			#idle_stand(randi_range(3, 5), "enter")
		#STATES.IDLE_WALK:
			#state = STATES.IDLE_WALK
			#idle_walk(0, randi_range(3, 5), "enter")
		#STATES.CHASE:
			#state = STATES.CHASE
			#chase_state(0, "enter")
		#STATES.PATHFIND:
			#pathfind_state(0, "enter")
			#state = STATES.PATHFIND
		#STATES.MELEE_ATTACK:
			#melee_attack_state(0, "enter")
			#state = STATES.MELEE_ATTACK


#func change_state():
	#if state == STATES.IDLE_STAND:
		#state = STATES.JUMP
		##walk()
		##jump(0.0)
		#print("slime_jumpp")
		#timer.start(jump_duration)
		#var direction_angle = randf_range(0.0, TAU) # TAU = 2 * PI
		#direction = Vector2(cos(direction_angle), sin(direction_angle)).normalized()
		##velocity = direction * speed
		#velocity = Vector2(cos(direction_angle), sin(direction_angle)) * speed
		#velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed
#
#
	#elif state == STATES.IDLE_WALK:
		#state = STATES.IDLE_STAND
		#print("WARN1NG! SOMETHING GOES WRONG")
		##idle() # ?
	#elif state == STATES.JUMP:
		#state = STATES.IDLE_STAND
		#timer.start(3)




#func _on_timer_timeout() -> void:
	#print("slime_timout")
	#change_state()
#---
	#if state == IDLE:
		#state = JUMP
		## NOT timer.start(1). dat wordt al gedaan in change_state()
	#if state == JUMP:
		#state = IDLE
#---
	#state = JUMP_ATTACK
	#var direction_angle = randf_range(0.0, TAU) # TAU = 2 * PI
	#direction = Vector2(cos(direction_angle), sin(direction_angle)).normalized()   #Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	##destination = position + direction * 100
	#jump_distance = 100
	##jump()
	##timer.start(randi_range(1,5)) # dit moet eigenlijk in WALK, IDLE, ETC
	#timer_is_already_running = false
	#timer.start(2)
	##ground_position.x = position.x
	#ground_position = position

# snijpunt van z = 0 y en z = 0.7 y + b
# y = (z - b)/0.7
# z = 0.7 * y + b
# door (y, z)
#      (7, 2)
# b = z - 0.7 y

# y = (z - b)/0.7
# y = (z -z + 0.7 y)/0.7


# slime.z = 2
# slime.y = 7
# -> b = -2.9
# z = 0.7y -2.9
# y = (2 + 2.9)/0.7  <-
# y = (2 + (-2 + 0.7 * 7))/0.7
# y = (z + (0.7 * y - z))/0.7

# y = (z + (0.7 * y - z))/0.7
