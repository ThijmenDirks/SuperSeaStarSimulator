extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var animation_tree : AnimationTree

#@onready var timer = $Timer

func _ready() -> void:
	base_speed = 30 # 50
	speed = base_speed
	look_for_player_area = $LookForPlayerArea
	#timer.start(1)
	attack_damage = 50
	chase_end_distance = 25
	melee_range = 15
	attack_speed = 0.5
	max_hp = 500
	hp = max_hp

	state = STATES.IDLE_STAND
	idle_stand(randi_range(3, 3), "enter") # shuoldnt you just call change_state(IDLE_STAND) ?
	super()


func _physics_process(delta: float) -> void:

	#print("goblin_state: ", state)
	update_animation_parameters()


func on_something_in_vision_field(bodies : Array):
	if player_in_vision_field:
		chase_target = player_in_vision_field
		#for body in bodies:
			#if body is Player:
				#chase_target = body
		request_change_state(STATES.CHASE)


func request_change_state(new_state):
	match new_state:
		STATES.CHASE:
			change_state(STATES.CHASE)
		STATES.PATHFIND:
			change_state(STATES.PATHFIND)
		STATES.IDLE_STAND:
			change_state(STATES.IDLE_STAND)
		STATES.IDLE_WALK:
			change_state(STATES.IDLE_WALK)
		STATES.MELEE_ATTACK:
			change_state(STATES.MELEE_ATTACK)
		STATES.ATTACK:
			change_state(STATES.MELEE_ATTACK)


func change_state(new_state):
	state_duration_timer.stop()
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_history.append(state)
	match new_state:
		STATES.IDLE_STAND:
			state = STATES.IDLE_STAND
			idle_stand(randi_range(3, 5), "enter")
		STATES.IDLE_WALK:
			state = STATES.IDLE_WALK
			idle_walk(0, randi_range(3, 5), "enter")
		STATES.CHASE:
			state = STATES.CHASE
			chase_state(0, "enter")
		STATES.PATHFIND:
			pathfind_state(0, "enter")
			state = STATES.PATHFIND
		STATES.MELEE_ATTACK:
			melee_attack_state(0, "enter")
			state = STATES.MELEE_ATTACK

	#if state == STATES.IDLE_STAND:
		#state = STATES.IDLE_WALK
		#idle_walk(0, "enter")
		#rotate_vision_field()
		#timer.start(3)
	#elif state == STATES.IDLE_WALK:
		#state = STATES.IDLE_STAND
		#idle_stand() # ?
		#timer.start(2)


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
	animation_tree["parameters/IdleCast/blend_position"] = velocity
	animation_tree["parameters/WalkCast/blend_position"] = velocity

# dit spul moet wel weer aan
#func _on_timer_timeout() -> void:
	#match state:
		#STATES.IDLE_STAND:
			#change_state(STATES.IDLE_WALK)
		#STATES.IDLE_WALK:
			#change_state(STATES.IDLE_STAND)
	#timer.start(randi_range(1,5)) # dit moet eigenlijk in WALK, IDLE, ETC


#func _on_vision_field_body_entered(body: Node2D) -> void:
	#if body is Player:
		#if look_for_player_in_vision_field(body):
			#chase_target = body
			#change_state(STATES.CHASE)
# this does not work when the players is in visionfield but there is a wall between them,
# casuse when the wall is gone but the player didnt left the visionField, ithis wont trigger again.
