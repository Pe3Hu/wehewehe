extends MarginContainer


#region vars
@onready var available = $Stones/Available
@onready var discharged = $Stones/Discharged
@onready var broken = $Stones/Broken
@onready var hand = $Stones/Hand

var backpack = null
var type = null
var capacity = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	backpack = input_.backpack
	type = input_.type
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Global.vec.size.bag
	capacity.current = 1
	capacity.limit = 10
	
	init_starter_kit_stones()
	input_.bag = self
	
	for key in Global.dict.area.next:
		if key != null:
			input_.type = key
			var stonestack = get(key)
			stonestack.set_attributes(input_)


func init_starter_kit_stones() -> void:
	for _type in Global.dict.stone.type:
		for value in Global.dict.stone.type[_type]:
			for _i in Global.dict.stone.type[_type][value]:
				var input = {}
				input.proprietor = self
				input.cost = 0
				input.resources = {}
				input.resources[_type] = value
				input.area = "discharged"
			
				var stone = Global.scene[type].instantiate()
				discharged.stones.add_child(stone)
				stone.set_attributes(input)
				stone.set_bag_as_proprietor(self)
				#print([stone.get_index(), suit, rank])
	
	#print("___")
	#reshuffle_available()
#endregion



func refill_hand() -> void:
	var stonestack = get(Global.dict.area.prior[hand.type])
	
	while hand.stones.get_child_count() < capacity.current:
		stonestack.advance_random_stone()


func disstone_hand() -> void:
	hand.advance_all_stones()
