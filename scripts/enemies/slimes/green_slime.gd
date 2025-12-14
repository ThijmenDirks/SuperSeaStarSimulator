extends Slime # please dont forget to fix raycast collision masks !!

#const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var timer_is_already_running = true
#var jump_duration = 1.5 # in sec

#@export var animation_tree : AnimationTree

#@onready var timer = $Timer

func _ready() -> void:
	bounty = 40
	max_hp = 200
	hp = 200#max_HP
	base_speed = 60
	speed = base_speed
	chase_end_distance = 250
	melee_range = 50
	attack_damage = 3
	angry = false

	jump_hight = 20
	state = STATES.IDLE_STAND
	idle_stand(9999, "enter")
	look_for_player_area = $LookForPlayerArea
	#print("slime_", state)
	#timer.start(1)
	sprite = $Sprite2D
	loot_table = {
		"green_slimeball" = 50, # %
		"super_legendary_drop" = 0.001,
	}

	super()


func on_something_in_vision_field(bodies : Array):
	print("slime test 10 ", randi(), player_in_vision_field)
	print("player visible?  ", player_in_vision_field)
	if player_in_vision_field:
		print("player visible?  2")
		print("slime test 11 ", randi())
		angry = true
		chase_target = player_in_vision_field
		attack_target = player_in_vision_field
		jump_attack_target = player_in_vision_field
		#for body in bodies:
			#if body is Player:
				#chase_target = body
		request_change_state(STATES.JUMP_ATTACK)
		print("slime test 12, state:  ", state)
	else:
		print("player visible?  3")
		angry = false # but this only runs when there is something in visoin_field


func request_change_state(new_state):
	if state_is_locked:
		return
	#if look_for_player_in_vision_field():	
		#angry = true
	#else:
		#angry = false
	print("slime changes state to  ", new_state, "  angry?  ", angry, "  locked?  ", state_is_locked)
	#if not player_is_in_attack_area():
		#angry = false
	if not angry:
		change_state(STATES.IDLE_STAND)
	else:
		jump_attack_target = look_for_player_in_vision_field()
		change_state(STATES.JUMP_ATTACK)
	return
	match new_state:
		STATES.CHASE: # might want to make slimes unable to chase adn use jump_attack for it instaed
			if state != STATES.JUMP_ATTACK and angry:
				change_state(STATES.CHASE)
		#STATES.PATHFIND:
			#change_state(STATES.PATHFIND)
		STATES.IDLE_STAND:
			angry = false
			if not angry:
				change_state(STATES.IDLE_STAND)
		#STATES.IDLE_WALK:
			#change_state(STATES.IDLE_WALK)
		STATES.JUMP_ATTACK:
			if angry:
				change_state(STATES.CHASE)
		STATES.ATTACK:
			if angry:
				change_state(STATES.CHASE)


func change_state(new_state):
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_duration_timer.stop()
	state_history.append(state)
	match new_state:
		STATES.IDLE_STAND:
			state = STATES.IDLE_STAND
			idle_stand(9999, "enter")
			print("green slime idle_stands !")
		#STATES.IDLE_WALK:
			#state = STATES.IDLE_WALK
			#idle_walk(0, jump_duration, "enter") # the time given here should be the same as N jumps in the animation
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "enter")
		#STATES.PATHFIND:
			#pathfind_state(0, "enter")
			#state = STATES.PATHFIND
		STATES.JUMP_ATTACK:
			state = STATES.JUMP_ATTACK
			jump_attack_state(0, jump_duration, "enter")
			print("green slime jump_attacks !")


func _on_trigger_attack_area_body_entered(body: Node2D) -> void:
	if body is Player:
		print("green slime attacks !")
		angry = true
		#attack_target = body
		#request_change_state(STATES.JUMP_ATTACK)


func _on_trigger_attack_area_body_exited(body: Node2D) -> void:
	if body is Player:
		print("green slime 'hides' !")
		angry = false
