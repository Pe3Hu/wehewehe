extends MarginContainer


#region vars
@onready var spells = $VBox/Pages/Spells
@onready var mantras = $VBox/Pages/Mantras
@onready var available = $VBox/Pages/Available
@onready var discharged = $VBox/Pages/Discharged
@onready var threats = $VBox/Threats

var god = null
var statistic = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_pages()
	init_statistic()


func init_pages() -> void:
	var input = {}
	input.grimoire = self
	
	for type in Global.arr.page:
		input.type = type
		var page = get(type+"s")
		page.set_attributes(input)


func init_statistic() -> void:
	var keys = ["available", "discharged"]
	
	for key in keys:
		statistic[key] = {}
	
	#for gem in god.backpack.gems.topaz.available.gems.get_children():
		#for socket in gem.sockets.get_children():
			#var value = socket.get_value()
			#
			#if !statistic.available.has(value):
				#for key in keys:
					#var input = {}
					#input.proprietor = self
					#input.type = "statistic"
					#input.subtype = key
					#input.value = 0
					#
					#var node = get(key)
					#var token = Global.scene.token.instantiate()
					#node.add_child(token)
					#token.set_attributes(input)
					#statistic[key][value] = token
			#
			#statistic.available[value].change_value(1)
#endregion


func spread_topazes() -> void:
	var threats = get_threats()
	
	if threats.is_empty():
		pass


func get_threats() -> Array:
	return god.opponents.front().grimoire.threats.get_children()
