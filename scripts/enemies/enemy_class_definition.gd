class_name Enemy extends  CharacterBody2D

@onready var debug_label = $DebugLabel

@onready var ray_cast = $RayCast2D
@onready var vision_field = $VisionField
@onready var vector_wheel = $VectorWheel
@onready var nav_agent = $NavigationAgent2D

var speed : int
var jump_hight : int
var direction : Vector2 #float # wil dit liever in rad of degree hebben # bij nader inzien: gewoon V2
#@onready var timer = $Timer
var max_HP = 100#: int# = 100
var HP = 100#: int
var resistances_and_weaknesses : Dictionary
var threat_range : int
var vision_range : int
var loot_table : Dictionary
var state = STATES.IDLE_STAND
var angry = false
var is_casting = null
var jump_distance : int
var hoever_deze_jump_al_was = 0
var s_and_x = 0
var last_delta : float
var hoeveelheid_waarmee_hij_nu_veranderd = 0
#var jump_duration = 10
var jump_height = 20
var jump_timer = 0.0
var ground_position : Vector2
var destination : Vector2
var z_for_jumping = 0.0
var jump_time = 2.0
var sprite : Sprite2D
var rng = RandomNumberGenerator.new()
var look_for_player_area : Area2D
var spell_heard
var waypoint_area : Area2D
var steering_constant = 2
var steerong_force
var desired_walk_direction
var pathfind_target
#var pathfind_target_position : Vector2
var chase_target
var chase_target_position : Vector2
var base_waypoint = {
	"name" : "placeholder_name",
	"children" : []
}

enum STATES {
	IDLE_STAND,
	IDLE_WALK,
	ATTACK,
	CAST,
	SLIME_IDLE,
	JUMP_ATTACK,
	JUMP,
	CHASE,
	PATHFIND,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(0)
	waypoint_area = Area2D.new() # gets automatically deleted when this function is done # ?
	var waypoint_area_collision = CollisionShape2D.new()
	waypoint_area_collision.shape = CircleShape2D.new()
	waypoint_area_collision.shape.radius = 300
	waypoint_area.set_collision_mask_value(1, false)
	waypoint_area.set_collision_mask_value(8, true)
	waypoint_area.add_child(waypoint_area_collision)
	waypoint_area.name = "waypoint_area"
		# VERGEET DIT DING NIET OOK TE VERWIJDEREN!
	#add_child(waypoint_area)

	#timer.start(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#chase()
	#print("PPP ", get_parent())
	#if HP != 0:
		#print("HP", HP)
	vision_field.rotation = velocity.angle()
	var chase_target_placeholder =  look_for_player_in_vision_field()
	if chase_target_placeholder:
		chase_target = chase_target_placeholder
		request_change_state(STATES.CHASE)
	#if body is Player:
		#if look_for_player_in_vision_field(body):
			#chase_target = body
			#change_state(STATES.CHASE)
	update_state(delta)


func update_state(delta):
	match(state):
		STATES.IDLE_WALK:
			idle_walk(delta)
		STATES.PATHFIND:
			pathfind_state(delta)
		STATES.CHASE:
			chase_state(delta)


func request_change_state(new_state):
	pass


func state_template(phase = "running"):
	match phase:
		"enter":
			pass
		"running":
			pass
		"exit":
			pass


func idle_stand(phase = "running"):
	match phase:
		"enter":
			velocity = Vector2.ZERO
		"running":
			debug_label.set_text("IDLE.STAND")
			pass
		"exit":
			pass


func idle_walk(delta : float, phase : String = "running"):
	match phase:
		"enter":
			#desired_walk_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
			# deze line moet wel weer aan
			print("idle_walk enter")
		"running":
			desired_walk_direction = get_local_mouse_position()
			move(desired_walk_direction, delta)
			#move_and_slide()
			#print("goblinwalk ", velocity, speed)
			print("STATES.IDLE_WALK RUNNING")
			debug_label.set_text("IDLE.WALK")
		"exit":
			pass


func look_for_player_in_vision_field():
	for body in vision_field.get_overlapping_bodies():
		if body == null or body is Player:
			ray_cast.target_position = to_local(body.global_position)
			ray_cast.force_raycast_update()
			if ray_cast.get_collider() == body:
				return body
	return false


func chase_state(delta, phase : String = "running"): # fpr when player is in sight
# assuihng melee enemy:
#run after coords were player last seen. once there, look around
	match phase:
		"enter":
			print("STATES.CHASE ENTER")
			pass
		"running":
			debug_label.set_text("CHASE")
			if look_for_player_in_vision_field():
				chase_target_position = chase_target.global_position
			move(to_local(chase_target_position), delta)
			print(self, "   hhh   ", chase_target)
			if self.global_position.distance_to(chase_target.global_position) < 100:
				debug_label.set_text("ATTACK!")
			elif self.global_position.distance_to(chase_target_position) < 100:
				debug_label.set_text("CHASE ENDED")
				if look_for_player_in_vision_chircle():
					chase_target_position = chase_target.global_position
				else:
					request_change_state(STATES.IDLE_WALK) # STATES.ALERTED ?
			print("STATES.CHASE RUNNING")
		"exit":
			print("STATES.CHASE EXIT")
			pass


func pathfind_state(delta, phase : String = "running"):
	match phase:
		"enter":
			#pathfind_target_position = pathfind_target.global_position
			nav_agent.target_position = pathfind_target.global_position#pathfind_target_position#to_global(pathfind_target.position)
			#print("STATE.PATHFIND ENTER  ", nav_agent.target_position, "  ", pathfind_target_position)
			pass
		"running":
			#nav_agent.target_position = pathfind_target_position#to_global(pathfind_target.position)
			#print("STATE.PATHFIND ENTER  ", nav_agent.target_position, "  ", pathfind_target_position)

			#nav_agent.target_position = target.position
			#print("nnn ", nav_agent.get_next_path_position(), "   ", )#move(nav_agent.get_next_path_position(), delta))
			move(nav_agent.get_next_path_position() - global_position, delta)
			print("LLL ", pathfind_target)
			# ^ this line should come back
			#velocity = nav_agent.get_next_path_position() - global_position # this line is just for debuging
			print("STATES.PATHFIND RUNNING")
			debug_label.set_text("PATHFIND")
		"exit":
			print("STATES.PATHFIND EXIT")
			pass


func steering_behavior(steering_constant, delta, speed):
	pass


func move(desired_walk_direction : Vector2, delta : float):
	# desired_walk_direction is in local (?)
	velocity = velocity.normalized()
	desired_walk_direction = vector_wheel.get_most_favourable_direction(desired_walk_direction)
	var steering_force = (desired_walk_direction - velocity) * steering_constant# * speed
	velocity += steering_force * delta
	velocity *= speed
	#velocity = desired_walk_direction * speed # for debugging, shouldget deleted
	move_and_slide() 


func attack():
	pass


func take_damage(damage : int, damage_type : String):
	if damage_type in resistances_and_weaknesses:
		damage *= resistances_and_weaknesses.damage_type
	HP -= damage
	if HP < 0:
		die()


func die():
	#drop_loot()
	self.queue_free()


func drop_loot():
	var loot_possible : Array
	var loot_drop_rate : Array
	for loot in loot_table:
		loot_possible.append(loot)
		loot_drop_rate.append(loot_table[loot])
	return loot_possible[rng.rand_weighted(loot_drop_rate)]

 #my_array[rng.rand_weighted(weights)]


#anti-error placeholder, altough it might get to be used.
func attack_player():
	pass
	speed



func on_noise_heard(noise_source):
	#print("enter")
	if not look_for_player_in_vision_chircle():
		#print("state.chase enter")
		#nav_agent.target_position = noise_source.position
		pathfind_target = noise_source
		#nav_agent.target_position = pathfind_target.position
		#print("STATE.PATHFIND ENTER ", pathfind_target.position, "  ", noise_source.position)
		request_change_state(STATES.PATHFIND)
		#if not look_for_sound_source(noise_source):
			#pass
	#else:
		#print("")


func has_line_of_sight(from, to):
	var raycast = $RayCast  # Reuse one raycast node
	raycast.global_position = from
	raycast.target_position = to
	raycast.force_raycast_update()
	# if get_collider == to: return true else: false
	return not raycast.is_colliding()




func rotate_vision_field():
	print("velocity.angle()", velocity.angle())
	vision_field.rotation = velocity.angle()


# no works...
# whyn't ?
func look_for_player_in_vision_chircle():
	print("eee")
	#var old_rotation = vision_field.rotation
	#var look_for_player_area = Area2D.new()
	for body in look_for_player_area.get_overlapping_bodies():
		if body is Player:
			ray_cast.target_position = to_local(body.position)
			ray_cast.force_raycast_update()
			if ray_cast.get_collider() is Player:
				#some_func() , like attacking the player,different for each enemy
				print(self, " dddd ", "player detected! ", randf_range(-1.0, 1.0))
				var label = Label.new()
				self.add_child(label)
				#label.set_text("i see you")  # but can go back
				label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
				#vision_field.rotation = old_rotation
				return true
	var label = Label.new()
	self.add_child(label)
	#label.set_text("mustvbeen a wall")  # but can go back
	label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
	return false


func look_for_sound_source(noise_source):
	ray_cast.target_position = to_local(noise_source.position)
	ray_cast.force_raycast_update()
	if ray_cast.get_collider() is Spell:
		#some_func() , like attacking the player,different for each enemy
		print("dddd ", "spell detected! ", randf_range(-1.0, 1.0))
		#print(self, " dddd ", "player detected! ", randf_range(-1.0, 1.0))
		var label = Label.new()
		self.add_child(label)
		#label.set_text("i hear you")  # but can go back
		label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
		return true
	var label = Label.new()
	self.add_child(label)
	#label.set_text("no idea")  # but can go back
	label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
	return false



func get_nearby_waypoints(subject: Node2D) -> Array:
	var area := Area2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 300
	
	var collision := CollisionShape2D.new()
	collision.shape = shape
	
	area.name = "waypoint_area"
	area.set_collision_mask_value(1, false)
	area.set_collision_mask_value(8, true)
	area.add_child(collision)
	
	subject.add_child(area)
	await get_tree().physics_frame
	
	var waypoints := []
	for body in area.get_overlapping_bodies():
		if body is Waypoint:
			waypoints.append(body)
	
	subject.remove_child(area)
	return waypoints

func expand_waypoint_node(tree_node: Dictionary, visited: Array) -> void:
	var current_node: Node2D = tree_node["name"]
	var nearby := await get_nearby_waypoints(current_node) # ! coroutine
	
	for body in nearby:
		if body in visited:
			continue
		
		var new_node = {
			"name": body,
			"children": []
		}
		tree_node["children"].append(new_node)


func search_for_spell(tree_node: Dictionary, path := [], visited := []) -> Array:
	var node: Node2D = tree_node["name"]
	
	if node in visited:
		return []
	
	path.append(tree_node)
	visited.append(node)
	
	# Check for Spell nearby
	for body in await get_nearby_waypoints(node):  # ! coroutine
		if body is Spell:
			var final_path := path.duplicate()
			final_path.reverse()
			print("hhh ", final_path)
			return final_path
	
	# Expand only once
	if tree_node["children"].is_empty():
		expand_waypoint_node(tree_node, visited)
	
	for child in tree_node["children"]:
		var result := await search_for_spell(child, path.duplicate(), visited.duplicate())
		if result.size() > 0:
			return result
	
	return []

func search_all_branches(tree: Array) -> Array:
	for node in tree:
		var result := await search_for_spell(node)
		if result.size() > 0:
			return result
	return []


			#get_waypoint_path()
			#look_for_waypoint(self)
			
#			
			#je voegt een niewuwe area toe en neem alle body in die area. for bodies in die area doe je if is wapoint, ray_cast.cast()/
			# if dat ding returnt body: voeg toe aan die tree_var.
			# wanneer die for loop over is doe je het nog een keer (dus bovenstaand gevaarte wordt eigen funcite), maar dan in een for loop die door de eerstegraadsnodes van tree_var loopt.
			# in die loop voeg je dus de area toe (aan bijbvoorbeeld waypoint.)DZEZ AREA IS DUS NIET ONDERDEEL VAN ENEMY, AAR WORDT VIA CODE TOEGEVOEGD. deze area niet iedere keer opnieuw maken, dat doe je ergnes aan het begin van on_souns-_heard ofzo. miss nog iets eerder.
			# area add je gewoon steeds as child. vergeet neit weer te deleten.
			# dat dan nog een keer maar dan met tweedegraads? hoe benaadere je die? met veel nesteded forloops?
			# + dan heb je kans dat die niet voor kortste route maar minste waypoint route gaat.

			#zal vast al wergesn staan, maar:
			#een wqypoint bestaat uit een dictionary:
			#een string: name and een sarray: chuldren
			#in de array zitten dictionaries...
			
	# twee vars, diepte/layer en stap

#
func delteme():
	var tree_var_example = [
		{
			"name" : "waypoint_1", # !! "name" is not just the name, IT IS THE NODE SELF!
			"children" : [
				{
					"name" : "waypoint_11",
					"children" : []
				},
				{
					"name" : "waypoint_12",
					"children" : [
						{
							"name" : "waypoint_121",
							"children" : []
						}
					]
				},
			]
		},
		{},
		{},
		{},
	]

			# ^ way_find() ^

	#ray_cast.target_position


	#for i in 1000:
		#ray_cast.force_raycast_update()
	#if add_child(RayCast2D.new()).get_collider():
	if ray_cast.get_collider() is Player:# or ray_cast.is_colliding():
		print("ddd", ray_cast.get_collider())
		pass
	#if ray_to_player() == player: # and thus not something like a wall:
		#move_to_player()
	#if ray_to_sound() == sound: # and thus not something like a wall:
		#move_to_sound()
	#pass


#func look_for_waypoint(subject):
	#subject.add_child(waypoint_area)
	#for body in subject.get_node("waypoint_area").get_overlapping_bodies():
		#print("fff ",body)




#func singal_test(argumeng):
	#print("kukiric", randf_range(-1.0, 1.0))


	#for i in 36:
		#vision_field.rotation_degrees += 10
		#var seen_bodies = vision_field.get_overlapping_bodies()
		#for body in seen_bodies:
			#if body is PLayer:
				#ray_cast.target_position = to_local(body.position)
				#ray_cast.force_raycast_update()
				#if ray_cast.get_collider() is PLayer:
					##some_func() , like attacking the player,different for each enemy
					#print("dddd ", "player detected! ", randf_range(-1.0, 1.0))
					#var label = Label.new()
					#self.add_child(label)
					#label.set_text("i see you")
					#label.position = Vector2(randi_range(-50, 50), randi_range(-50, 50))
					#vision_field.rotation = old_rotation
					#return true
	#return false

#func ray_to_player():
	#if ray_to_player.succeeds():
		#move_to_sound()
		#return true
	#else:
		#return false
#
#func ray_to_sound():
	#if ray_to_sound.succeeds():
		#attack_player()
		#return true
	#else:
		#return false


 #hierzo was ik bezig
 #25-05-25

#func expand_tree_until_spell(tree: Array) -> Array:
	#var results := []
	#for root_node_dict in tree:
		#_recurse(root_node_dict, [])
#
	#return results
#
#func _recurse(current_node_dict: Dictionary, path: Array):
	#var current_node := current_node_dict["name"]
	#
	## Check if this is a Spell
	#if current_node is Spell:
		## Store the reversed path INCLUDING the Spell node
		#var reversed_path = path.duplicate()
		#reversed_path.append(current_node)
		#results.append(reversed_path.inverted())
		#return
		#
	## Expand this node
	#get_waypoints_in_area(current_node_dict)
	#
	## Recurse into children
	#for child in current_node_dict["children"]:
		## Append the current node to the path and dive deeper
		#var new_path = path.duplicate()
		#new_path.append(current_node)
		#_recurse(child, new_path)

	# Start the recursion

#func expand_tree_until_spell(tree: Array) -> Array:
	#var results := []
	#for root_node_dict in tree:
		#_recurse(root_node_dict, [], results)
	#return results
#
#func _recurse(current_node_dict: Dictionary, path: Array, results: Array) -> void:
	#var current_node = current_node_dict["name"]
#
	#if current_node is Spell:
		#var reversed_path = path.duplicate()
		#reversed_path.append(current_node)
		#results.append(reversed_path.inverted())
		#return
#
	#get_waypoints_in_area(current_node_dict)
#
	#for child in current_node_dict["children"]:
		#var new_path = path.duplicate()
		#new_path.append(current_node)
		#_recurse(child, new_path, results)

#func expand_tree_until_spell(tree: Array) -> Array:
	#var results := []
#
	#for root_node_dict in tree:
		#expand_recurse(root_node_dict, [], {}, results)
#
	#return results
#
#
#func expand_recurse(current_node_dict: Dictionary, path: Array, visited: Dictionary, results: Array) -> void:
	#var current_node = current_node_dict["name"]
#
	## Cycle check
	#if current_node in visited:
		#return
	#
	## Add this node to visited set
	##visited.insert(current_node)
#
	#if current_node is Spell:
		#var reversed_path = path.duplicate()
		#reversed_path.append(current_node)
		#results.append(reversed_path.inverted())
		#return
#
	#get_waypoints_in_area(current_node_dict)
#
	#for child in current_node_dict["children"]:
		#var new_path = path.duplicate()
		#new_path.append(current_node)
		#expand_recurse(child, new_path, visited.duplicate(), results)
# Call this to kick off the search. Returns an Array of Node2D (deepest → root).
# If no Spell is found, returns an empty Array.
#func wat_dan_ook(): # get_waypoint_path
#
	#var still_searching = true
#
	#var tree_var : Array
#
	##var layer : int = 0
	##var sibling_count : int = 0
#
	#var current_place : Array # [parent, child, grandchild]
	#var enemy
#
	##datgene_met_add_area(enemy)
#
	#while still_searching:
		#for waypoint in enemy:
				#pass
			##layer += 1
#
#func get_waypoint_path():
	#pass
#
#func add_to_tree_var():
	#pass
#
#func get_waypoints_in_area(subject): # waypoint (soms enemy)
	 ##die node getten we met die functie_van_chagtpt(Node)
	#
	## NEE. we stoppen er niet een nde in maar een plek binnen tree_var
	#subject.add_child(waypoint_area)
	#await get_tree().physics_frame
	#for body in waypoint_area.get_overlapping_bodies():
		#if body is Waypoint:
			#var new_waypoint = base_waypoint.duplicate()
			#new_waypoint.name = body
			##tree_var[layer]
			#subject["children"].append(new_waypoint)
	#subject.remove_child(waypoint_area)
#
#func get_node_in_tree_var(tree_var, layer, step):
	#pass
#
#
#func find_spell_path(tree_var: Array) -> Array:
	#var visited := []        # Array of Node2D we’ve already seen
	#var path := []           # current root→…→node chain
	#var result := []         # will hold the reversed chain when Spell is found
#
	#for root_dict in tree_var:
		#if await _dfs_find_spell(root_dict, visited, path, result):
			#print("hhh ", result)
			#return result
	#print("hhhh")
	#return []
#
#
## Recursive helper. Returns true as soon as Spell is found.
## - dict: a {"name":Node2D, "children":Array} dict
## - visited: Array of Node2D
## - path: Array of Node2D from root down to current
## - result: Array to populate (inverted) on success
#func _dfs_find_spell(dict: Dictionary, visited: Array, path: Array, result: Array) -> bool:
	#var node: Node2D = dict["name"]
#
	## cycle check
	#if visited.has(node):
		#return false
	#visited.append(node)
	#path.append(node)
#
	## found the Spell!
	#if node is Spell:
		## copy and reverse the path
		#result.clear()
		#result = path.duplicate()
		#result.reverse()
		#return true
	## if no children yet, expand this leaf
	#if dict["children"].size() == 0:
		#await get_waypoints_in_area(dict)
	## recurse into each child
	#for child_dict in dict["children"]:
		#if await _dfs_find_spell(child_dict, visited, path, result):
			#return true
	## backtrack
	#path.pop_back()
	#return false

#----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER! ----- D4NGER!

# HIERONDER VOLT JUMP!

func jump(delta):
	pass
	#velocity = direction * speed
	#print("slime_jump ", velocity, speed)
	#move_and_slide()
	#print("slime_jump ", position, "  ", velocity, speed)
	# move a bit while doing jumo animation
	# dont bother keeping track of time
##---
#func walk():
	#if velocity == Vector2.ZERO:
		#velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed # dit moet natuurlijk eigenlijk in chage_state
	#move_and_slide()
	#print("goblinwalk ", velocity, speed)
##---
		#timer.start(jump_duration)
		#var direction_angle = randf_range(0.0, TAU) # TAU = 2 * PI
		#direction = Vector2(cos(direction_angle), sin(direction_angle)).normalized()
		##velocity = direction * speed
		#velocity = Vector2(cos(direction_angle), sin(direction_angle)) * speed
		#velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * speed
##---

#func jump(delta):
	## 1. Verplaatsing over de grond
	#var move_delta = direction.normalized() * speed * delta
	#ground_position += move_delta
#
	## 2. Update springtijd
	#jump_timer += delta
	#var jump_progress = clamp(jump_timer / jump_duration, 0.0, 1.0)
#
	## 3. Bereken spronghoogte met sinuscurve (0→PI → op/neer)
	#var z_offset = -sin(jump_progress * PI) * jump_height
#
	## 4. Top-down offset (projectie van sprong richting op y)
	#var direction_angle = direction.angle()
	#var topdown_angle_factor = sin(direction_angle)
	#var visual_y_offset = z_offset * topdown_angle_factor
#
	## 5. Combineer grondpositie en visuele hoogte
	#position.x = ground_position.x
	#position.y = ground_position.y + visual_y_offset

# s = v * t
# met
# t = delta
# s = x
# v = speed
# posietie op l = -(x-1)**2 + 1
# if s == 1: is_jumping = false

# y = l + m * sin(dircetion.angle())

# of

# x(t) = t
# y(t) = -t ** 2 + 2t

# y(t) = sin(t)
# t = delta

# position.x gaat *cos(direction)

# zorg dat er ook een las  _delta is
# er moet eigenlijk een "jump" eneen "jump_and_attack" zijn.
# bij "jump_and_attack" wordt gekeken of de player geraakt kan worden, bij "jump" niet
#func jump(delta):
	## er moet ook nog een jump_dtstance zijn
	#print(delta)
	#hoeveelheid_waarmee_hij_nu_veranderd += delta - hoever_deze_jump_al_was # bijna= t
	#position.x += hoeveelheid_waarmee_hij_nu_veranderd * cos(direction.angle()) * speed * 0.2# jump_height
	#position.y += (sin(hoever_deze_jump_al_was + delta * PI) - sin(hoever_deze_jump_al_was * PI))# vergeet ook niet het haakje sluiten hier links te verwijderen. # + 0.7 * delta * sin(direction.angle())) * 1
	#var direction_angle = direction.angle()
	#s_and_x += speed * delta * 0.05
	##position.x += s_and_x * 50 * cos(direction_angle)
	##position.y += -(cos((-(s_and_x - 1) ** 2 + 1) * jump_hight) + s_and_x * 0.7 * sin(direction_angle))
	##position += Vector2(10.1 * delta, 10.1 * (- delta ** 2 + 2 * delta))
	##position += Vector2(direction.x * speed * delta, -delta**2 + 2 * delta - 1 * cos(deg_to_rad(abs(deg_to_rad(direction.angle())))))
	#hoever_deze_jump_al_was += delta
	#if hoever_deze_jump_al_was >= 1:
		##jumping = false
		#state = IDLE
		#hoever_deze_jump_al_was = 0
		#hoeveelheid_waarmee_hij_nu_veranderd = 0
		#print("enemy_slime_jump_no_more")
	#print("enemy_slime_jump ", s_and_x, "   ", direction)
	#last_delta = delta

#func jump(delta):
	#print("slime_jump")
	#position += speed * direction * delta # dit werkt! (Denk/hoop ik)
	##position.x = move_toward(position.x, destination.x, delta)
	##position.y = move_toward(position.y, destination.y, delta)
	#z_for_jumping += sin(((hoever_deze_jump_al_was + delta)/jump_time) * PI) - sin((hoever_deze_jump_al_was/jump_time) * PI)
	#sprite.position.y = (z_for_jumping + (0.7 * position.y - z_for_jumping))/0.7
	#print("slime_jump_z = ", z_for_jumping, "   ", hoever_deze_jump_al_was/jump_time)
	##state = IDLE
	#hoever_deze_jump_al_was += delta
	#if hoever_deze_jump_al_was > jump_time:
		#print("slime_jump_stop")
		#state = IDLE
		#hoever_deze_jump_al_was = 0
