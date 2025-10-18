extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var max_respawns: int = 5
var amount_of_respawns: int = 0
var is_fake_dead: bool = false
var is_respawning: bool = false
var dead_time: int = 3

@export var animation_tree : AnimationTree

@onready var collision: CollisionShape2D = $CollisionShape2D

# melee_range > chase_end_distance
func _ready() -> void:
	bounty = 50
	base_speed = 25 # 50 # 45
	speed = base_speed
	look_for_player_area = $LookForPlayerArea
	#timer.start(1)
	attack_damage = 50
	chase_end_distance = 20
	melee_range = 30
	attack_speed = 0.05

	state = STATES.IDLE_STAND
	idle_stand(randi_range(3, 3), "enter") # shuoldnt you just call change_state(IDLE_STAND) ?
	super()


func _physics_process(delta: float) -> void:
	if is_fake_dead:
		velocity = Vector2.ZERO	

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
# right now im changing state here, but might do that in state funcionts self because of on_stae("exit"): state = state.last # i dont think so..
	if state_is_locked:
		return
	state_duration_timer.stop()
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


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"] = velocity
	animation_tree["parameters/Walk/blend_position"] = velocity
	#animation_tree["parameters/IdleCast/blend_position"] = velocity
	#animation_tree["pardameters/WalkCast/blend_position"] = velocity


func take_damage(damage : int, damage_type : String):
	if damage_type in resistances_and_weaknesses:
		damage *= resistances_and_weaknesses.damage_type
	hp -= damage
	update_hp_bar()
	angry = true
	if hp < 0:
		if amount_of_respawns < max_respawns:
			fake_die()
		else:
			true_die()


func fake_die():
	is_fake_dead = true
	for i in [3,4,5,10]:
		set_collision_layer_value(i, false)
	amount_of_respawns += 1
	#set_collision_layer_value(3, false,)
	#set_collision_layer_value(4, false,)
	#set_collision_layer_value(5, false,)
	#set_collision_layer_value(10, false,)
	state_is_locked = false
	state = STATES.IDLE_STAND
	state_is_locked = true
	await get_tree().create_timer(dead_time).timeout
	is_fake_dead = false
	respawn()


func respawn():
	is_respawning = true
	print("mummy is respawning")
	await get_tree().create_timer(0.45).timeout
	print("mummy is done respawning")
	is_respawning = false
	for i in [3,4,5,10]:
		set_collision_layer_value(i, true)
	#set_collision_layer_value(3, true,)
	#set_collision_layer_value(4, true,)
	#set_collision_layer_value(5, true,)
	#set_collision_layer_value(10, true,)
	state_is_locked = false
	hp = max_hp * max((1 - (float(amount_of_respawns) / max_respawns)), 0.1)
	update_hp_bar()
	change_state(STATES.IDLE_WALK)


func true_die():
	die()
