extends "res://scene/4/gem.gd"

#region init
func init_basic_setting() -> void:
	super.init_basic_setting()
	init_tokens()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	
	for _i in description.capacity:
		input.type = "stone"
		input.subtype = "charge"
		input.value = description.charge
		
		var token = Global.scene.token.instantiate()
		sockets.add_child(token)
		token.set_attributes(input)


func advance_area() -> void:
	super.advance_area()
	var statistic = proprietor.backpack.grimoire.statistic
	
	for socket in sockets.get_children():
		var value = socket.get_value()
		
		match area:
			"available":
				if !statistic.available.has(value):
					var keys = ["available", "discharged"]
					
					for key in keys:
						var input = {}
						input.proprietor = self
						input.type = "statistic"
						input.subtype = key
						input.value = 0
						
						var node = proprietor.backpack.grimoire.get(key)
						var token = Global.scene.token.instantiate()
						node.add_child(token)
						token.set_attributes(input)
						statistic[key][value] = token
				
				statistic.available[value].change_value(1)
				
				if statistic.discharged[value].get_value() > 0:
					statistic.discharged[value].change_value(-1)
			"hand":
				if statistic.available[value].get_value() > 0:
					statistic.available[value].change_value(-1)
			"discharged":
				statistic.discharged[value].change_value(1)
#endregion
