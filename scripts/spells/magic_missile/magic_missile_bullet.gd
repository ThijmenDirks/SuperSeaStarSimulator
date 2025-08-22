extends Spell


var has_exploded : bool = false

#
#func deal_damage(a,b):
	#pass
	##anti-eroor func!
	##don't leave it here!
	#^true!


func _ready():
	#position = Vector2(0,0)
	position = caster.global_position
	#print("you cast ", self.name, " !")
	#print("nnn   ", caster)
	#texture = load("res://art/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt.png")
	#other_texture = $Sprite2D
	#hit_enemies = ["goblin", "goblin", "orc"]
	this_spell = SpellDatabase.magic_missile
	#aoe_size = this_spell.spell_aoe_size
	noise = this_spell.spell_noise
	speed = this_spell.spell_speed
	#ray_cast = $RayCast2D
	origin_position = caster.global_position
	base_damage = this_spell.spell_damage
	damage_type = this_spell.spell_damage_type
	print("damage_type ", damage_type)
	if caster is Player:
		orb_cost = this_spell.spell_orb_cost
		var damage_multiplier = get_multiplier(orb_cost)  #caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").get_color_bar("q").size_flags_stretch_ratio
		base_damage *= damage_multiplier
		target_position = get_global_mouse_position()

	#direction = origin_position.angle_to(get_global_mouse_position())
	#direction = get_local_mouse_position().angle()

	max_range = min(origin_position.distance_to(target_position), this_spell.spell_range)
	self.look_at(target_position)
	#rotation += PI
	print("max_range: ", max_range, "   position   ", position, "   global_position   ", global_position, "   origin_pos:  ", origin_position, "   target_position   ", target_position, "   length:   ", self.position.distance_to(origin_position), "   parent   ", get_parent().name, "   caster   ", caster.name,  "   caster_pos   ", caster.position,  "   caster_glob_pos   ", caster.global_position )

	#speed = 0 # please deltet this line !

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
	queue_free()
	#explosion("small")


func _on_body_entered(body: Node) -> void:
	if body == caster:
		print("hit caster !")
		return
	if body is Enemy or body is BreakbleBlock: # dirty. now shaman cant use it
		body.take_damage(base_damage, damage_type)
	#if body is MoveableBlock:
		#body.move_speed = speed
	queue_free()
