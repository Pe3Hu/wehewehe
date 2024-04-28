extends "res://scene/4/gem.gd"

#region init
func init_basic_setting() -> void:
	super.init_basic_setting()
	init_tokens()


func init_tokens() -> void:
	var input = {}
	input.proprietor = self
	capacity = 1
	
	for _i in capacity:
		input.type = "stone"
		input.subtype = "charge"
		input.value = 1
		
		var token = Global.scene.token.instantiate()
		sockets.add_child(token)
		token.set_attributes(input)
#endregion
