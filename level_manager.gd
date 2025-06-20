extends Node
var current_quota: int = 0
var score = 0


func _ready():
	var rand_quota = randi_range(12,22)
	set_quota(rand_quota)


func set_quota(new_quota):
	current_quota = new_quota
	get_tree().get_first_node_in_group("quotaVisual").set_text("[center]" + str(current_quota) + "[/center]")


func reduce_quota():
	if randi_range(0,1) > 0:
		set_quota(current_quota-1)


func add_to_score(num_to_add):
	score += num_to_add
	get_tree().get_first_node_in_group("scoreVisual").set_text("[center]" + str(score) + "[/center]")
