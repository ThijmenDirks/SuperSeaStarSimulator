extends Node2D

#var school_logos : Array # not really used
#
#var all_colors = ["red", "blue", "green", "purple"] # not really used
#var used_colors = ["red", "green", "blue", "a", "purple"] # not really used
#
##var sprite: Sprite2D = Sprite2D.new()
#
#var used_schools: Array = ["fire", "buff", "other"] # not really used
#
#var i: int = 0

@onready var scroll_bar = $Sprite2D

var fire_school_logo = load("res://art/UI_and_the_like/school_logos/FireSchoolLogoV1.png")
var buff_school_logo = load("res://art/UI_and_the_like/school_logos/BuffSchoolLogoV1.png")
var other_school_logo = load("res://art/UI_and_the_like/school_logos/MagicSchoolLogoV1.png")

var used_school_logos: Array = [fire_school_logo, buff_school_logo, other_school_logo]

var school_sprites: Array = []

var min_scroll_bar_hight: int

func _ready() -> void:
	scroll_bar.position = Vector2(550, (250+32))
	min_scroll_bar_hight = (250+32) - ((used_school_logos.size()) * 64)
	for i in range(used_school_logos.size()):
		var logo: Texture2D = used_school_logos[i]
		
		var sprite := Sprite2D.new()
		sprite.texture = logo
		sprite.position = Vector2(550, 250 - i * 64)
		sprite.scale = Vector2(2, 2)
		
		add_child(sprite)
		school_sprites.append(sprite) # sla sprites op i.p.v. alleen textures
		
		print("Added school logo", i)


func update_scroll_bar(direction: String, sensitivity: float):
	if direction == "up":
		scroll_bar.position.y -= 6.4 * sensitivity
		if scroll_bar.position.y < min_scroll_bar_hight:
			scroll_bar.position.y = (250+32)
	else:
		scroll_bar.position.y += 6.4 * sensitivity
		if scroll_bar.position.y > (250+32):
			scroll_bar.position.y = min_scroll_bar_hight
	print("scrollbar updated")
	return scroll_bar.position.y


#func _ready() -> void:
	#for school in used_school_logos:
		#var sprite: Sprite2D = Sprite2D.new()
		#print("i", i)
		##var color = used_colors[i]
		#var new_school_logo = school#.instantiate() #load("res://scenes/UI_and_the_like/mana_thingy.tscn").instantiate()
		#var new_sprite = sprite#instantiate()
		#new_sprite.texture = new_school_logo
		#add_child(new_sprite)
		##new_mana_thingy.my_color = color # just a reminderr mi might want to set their colors...
		##new_mana_thingy.position = Vector2(-190, 50-i*30) # from top top bottom instean bottom to top ?
		#new_sprite.position = Vector2(200, 250 - i * 30
		#school_logos.append(new_school_logo)
		#i += 1
#extends Node2D
#
#var used_school_logos: Array = [
	#load("res://icon.svg"),
	#load("res://icon.svg"),
	#load("res://icon.svg")
#]
	#for i in range(used_colors.size() - 1, -1, -1):
		#var color = used_colors[i]
		#var new_mana_thingy = load("res://scenes/UI_and_the_like/mana_thingy.tscn").instantiate()
		#add_child(new_mana_thingy)
		#new_mana_thingy.my_color = color
		##new_mana_thingy.position = Vector2(-190, 50-i*30) # from top top bottom instean bottom to top ?
		#new_mana_thingy.position = Vector2(35, 250-i*30)
		#mana_thingies.append(new_mana_thingy)
