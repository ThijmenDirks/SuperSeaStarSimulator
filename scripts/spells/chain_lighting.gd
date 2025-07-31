extends Spell


var has_exploded : bool = false
var hit_targets : Array

func get_damage_by_explosion(base_damage, distance_enemy_to_center, aoe_size):
	var distance_to_center_ratio : float =  (1 - float(float(distance_enemy_to_center)/float(aoe_size))) # 1 op center, 0 op rand)
	print("HP   ", distance_to_center_ratio)
	return int((2 ** distance_to_center_ratio) * float(base_damage))
	#return 100

func deal_damage(a,b):
	pass
	#anti-eroor func!
	#don't leave it here!
	#^true!


func _ready():
	return
	print("you cast ", self.name, " !")
	#print("nnn   ", caster)
	#texture = load("res://art/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt.png")
	#other_texture = $Sprite2D
	#hit_enemies = ["goblin", "goblin", "orc"]
	this_spell = SpellDatabase.chain_lightning
	var chain_range = this_spell.spell_chain_range
	noise = this_spell.spell_noise
	speed = this_spell.spell_speed
	ray_cast = $RayCast2D
	origin_position = caster.position
	base_damage = this_spell.spell_damage
	damage_type = this_spell.spell_damage_type
	print("damage_type ", damage_type)
	if caster is Player:
		orb_cost = this_spell.spell_orb_cost
		var damage_multiplier = get_multiplier(orb_cost)  #caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("red").size_flags_stretch_ratio
		base_damage *= damage_multiplier
		kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
		target_position = get_global_mouse_position()

	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()

	max_range = min(position.distance_to(target_position), this_spell.spell_range)
	self.look_at(target_position)
	rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))

	if caster is Player:
		if pay_mana(orb_cost):
			change_kleurenbalkje(["red"])
		else:
			print("gigantic miscast!")
			return


func _physics_process(delta: float,) -> void:
	#print("local ", get_local_mouse_position())
	position = position.move_toward(target_position, speed * delta)
	#print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position))
	#print(position, "   target_position   ", target_position)
	#print(position.length(), "   fff   ", self)
	if self.position.distance_to(origin_position) >= max_range or position == target_position:
		on_max_range()



func on_max_range():
	print("on_max_range")
	explosion("small")


func _on_body_entered(body: Node) -> void:
	if body == caster:
		return
	print("big_explosion")
	explosion()


# porbalbly this should go to spell_class_definition
func explosion(size : String = "big"):
	print("damage                      ", damage_type)
	if has_exploded:
		return
	has_exploded = true
	var explosion_area
	if size == "big":
		explosion_area = $BigExplosion
	else:
		explosion_area = $SmallExplosion
	var hit_targets = explosion_area.get_overlapping_bodies()
	for target in hit_targets:
		if target is Enemy or target is Player:
			#var ray_cast = RayCast2D.new() # uiteindeijk wil ik wel weer gewoon terug naar een raycast hergebruiken
			ray_cast.set_collision_mask_value(1, false)
			ray_cast.set_collision_mask_value(2, true)
			#add_child(ray_cast)
			ray_cast.target_position = to_local(target.global_position)
			#ray_cast.rotation -= rotation + PI
			ray_cast.force_raycast_update()
			print("coll   ", ray_cast.get_collider(), rotation_degrees)
			if not ray_cast.is_colliding():
				print("hit an enemy  ", target, "   damage:   ", get_damage_by_explosion(base_damage, self.global_position.distance_to(target.global_position) , aoe_size), damage_type)
				target.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(target.global_position) , aoe_size), damage_type)
	await make_noise(noise)
	queue_free()
