class_name Slime extends Enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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


func change_state(new_state):
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


func slime_move():
	pass


func slime_attack():
	pass
