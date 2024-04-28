extends MarginContainer


#region vars
@onready var stones = $Stones

var bag = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	bag = input_.bag
	type = input_.type


func reshuffle_all_stones() -> void:
	var _stones = []
	
	while stones.get_child_count() > 0:
		var stone = stones.get_child(0)
		stones.remove_child(stone)
		_stones.append(stone)
	
	_stones.shuffle()
	
	for stone in _stones:
		stones.add_child(stone)


func advance_random_stone() -> void:
	refill_check()
	var stone = stones.get_children().pick_random()
	stone.advance_area()


func advance_all_stones() -> void:
	while stones.get_child_count() > 0:
		advance_random_stone()


func refill_check() -> void:
	if stones.get_child_count() == 0:
		var donor = Global.dict.area.prior[type]
		var stonestack = bag.get(donor)
		stonestack.advance_all_stones()
#endregion
