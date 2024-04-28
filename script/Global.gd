extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.resource = ["gold", "power"]
	arr.bag = ["amulet", "ring", "gem"]
	arr.gem = ["emerald", "amethyst", "sapphire", "topaz", "pearl"]
	arr.page = ["spell", "mantra"]
	arr.essence = ["lightning", "fire", "ice", "poison", "bone", "blood", "light", "void", "darkness"]


func init_num() -> void:
	num.index = {}
	num.index.stone = 0


func init_dict() -> void:
	init_neighbor()
	init_stone()
	init_season()
	init_area()
	init_font()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_stone() -> void:
	dict.stone = {}
	dict.stone.type = {}
	dict.stone.type["gold"] = {}
	dict.stone.type["gold"][1] = 5
	dict.stone.type["gold"][2] = 3
	dict.stone.type["gold"][3] = 1
	
	dict.stone.type["power"] = {}
	dict.stone.type["power"][1] = 2
	dict.stone.type["power"][2] = 1


func init_season() -> void:
	dict.season = {}
	dict.season.phase = {}
	dict.season.phase["spring"] = ["incoming"]
	dict.season.phase["summer"] = ["selecting", "outcoming"]
	dict.season.phase["autumn"] = ["wounding"]
	dict.season.phase["winter"] = ["wilting", "sowing"]


func init_area() -> void:
	dict.area = {}
	dict.area.next = {}
	dict.area.next[null] = "discharged"
	dict.area.next["discharged"] = "available"
	dict.area.next["available"] = "hand"
	dict.area.next["hand"] = "discharged"
	dict.area.next["broken"] = "discharged"
	
	dict.area.prior = {}
	dict.area.prior["available"] = "discharged"
	dict.area.prior["hand"] = "available"


func init_font():
	dict.font = {}
	dict.font.size = {}
	dict.font.size["resource"] = 24
	dict.font.size["stone"] = 24
	dict.font.size["season"] = 18
	dict.font.size["phase"] = 18
	dict.font.size["moon"] = 18


func init_emptyjson() -> void:
	dict.emptyjson = {}
	dict.emptyjson.title = {}
	
	var path = "res://asset/json/.json"
	var array = load_data(path)
	
	for emptyjson in array:
		var data = {}
		
		for key in emptyjson:
			if key != "title":
				data[key] = emptyjson[key]
		
		dict.emptyjson.title[emptyjson.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.token = load("res://scene/0/token.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.area = load("res://scene/2/area.tscn")
	
	scene.bag = load("res://scene/3/bag.tscn")
	
	#scene.stone = load("res://scene/4/stone.tscn")
	for gem in arr.gem:
		scene[gem] = load("res://scene/4/" + gem + ".tscn")
	
	scene.paragraph = load("res://scene/5/paragraph.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	
	vec.size.token = vec.size.sixteen * 3
	vec.size.stone = Vector2(vec.size.token.x, vec.size.token.y)
	vec.size.bag = Vector2()#vec.size.token.x * 6, vec.size.token.y * 5)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.stone = {}
	color.stone.selected = {}
	color.stone.selected[true] = Color.from_hsv(160 / h, 0.4, 0.7)
	color.stone.selected[false] = Color.from_hsv(60 / h, 0.2, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func get_all_constituents_based_on_limit(array_: Array, limit_: int) -> Dictionary:
	var constituents = {}
	constituents[0] = []
	constituents[1] = []
	
	for child in array_:
		constituents[0].append(child)
		
		if child.value <= limit_:
			constituents[1].append([child])
	
	for _i in array_.size()-2:
		set_constituents_based_on_size_and_limit(constituents, _i+2, limit_)
	
	var value = 0
	
	for constituent in array_:
		value += constituent.value
	
	if value <= limit_:
		constituents[array_.size()] = [constituents[0]]
	
	constituents.erase(0)
	
	for _i in range(constituents.keys().size()-1,-1,-1):
		var key = constituents.keys()[_i]
		
		if constituents[key].is_empty():
			constituents.erase(key)
	
	return constituents


func set_constituents_based_on_size_and_limit(constituents_: Dictionary, size_:int, limit_: int) -> void:
	var parents = constituents_[size_-1]
	constituents_[size_] = []
	
	for parent in parents:
		var value = 0
		
		for constituent in parent:
			value += constituent.value
		
		for child in constituents_[0]:
			if !parent.has(child) and value + child.value <= limit_:
				var constituent = []
				constituent.append_array(parent)
				constituent.append(child)
				constituent.sort_custom(func(a, b): return constituents_[0].find(a) < constituents_[0].find(b))
				
				if !constituents_[size_].has(constituent):
					constituents_[size_].append(constituent)
