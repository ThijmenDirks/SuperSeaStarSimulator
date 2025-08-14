extends Slime # please dont forget to fix raycast collision masks !!

#const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var timer_is_already_running = true
#var jump_duration = 1.5 # in sec

#@export var animation_tree : AnimationTree

#@onready var timer = $Timer

func _ready() -> void:
	max_hp= 200
	hp = 200#max_HP
	base_speed = 30
	speed = base_speed
	chase_end_distance = 250
	melee_range = 50
	attack_damage = 2
	angry = false

	jump_hight = 20
	state = STATES.IDLE_WALK
	idle_walk(0, jump_duration, "enter")
	look_for_player_area = $LookForPlayerArea
	#print("slime_", state)
	#state_duration_timer.start(1)
	sprite = $Sprite2D
	loot_table = {
		"green_slimeball" = 50, # %
		"super_legendary_drop" = 0.001,
	}

#func _process(delta: float) -> void:
	#super(delta)

# shouldnt this be in Enemy?
#func _physics_process(delta: float) -> void:
	##super(delta)
	#print("HP ", hp)
	#update_animation_parameters()
	#if state == STATES.JUMP:
		#jump(delta)
	#if state == STATES.IDLE_STAND:
		#if not timer_is_already_running:
			##timer.start(1)
			#pass


func request_change_state(new_state):
	print("slime angry?   ", angry)
	match new_state:
		STATES.CHASE: # might want to make slimes unable to chase adn use jump_attack for it instaed
			if state != STATES.JUMP_ATTACK and angry:
				change_state(STATES.CHASE)
		#STATES.PATHFIND:
			#change_state(STATES.PATHFIND)
		#STATES.IDLE_STAND:
			#change_state(STATES.IDLE_STAND)
		STATES.IDLE_WALK:
			change_state(STATES.IDLE_WALK)
		STATES.JUMP_ATTACK:
			if angry:
				change_state(STATES.JUMP_ATTACK)
		STATES.ATTACK:
			if angry:
				change_state(STATES.JUMP_ATTACK)


func change_state(new_state):
	state_duration_timer.stop()
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_history.append(state)
	match new_state:
		#STATES.IDLE_STAND:
			#state = STATES.IDLE_STAND
			#idle_stand(randi_range(3, 5), "enter")
		STATES.IDLE_WALK:
			state = STATES.IDLE_WALK
			idle_walk(0, jump_duration, "enter") # the time given here should be the same as N jumps in the animation
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "enter")
		#STATES.PATHFIND:
			#pathfind_state(0, "enter")
			#state = STATES.PATHFIND
		STATES.JUMP_ATTACK:
			state = STATES.JUMP_ATTACK
			jump_attack_state(0, jump_duration, "enter")



#func _on_damage_area_body_entered(body: Node2D) -> void:
	#if body is Player:
		#print("slime deals damage")



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


#func _on_damage_area_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.
