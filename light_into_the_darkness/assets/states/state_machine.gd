class_name StateMachine
extends RefCounted

var current_state: BaseState
var state_stack: Array[BaseState] = []

var owner


func _init(state_owner):
	owner = state_owner


func execute(delta):
	if current_state:
		current_state.execute(delta)


func push(new_state: BaseState):
	state_stack.append(new_state)

	current_state = new_state

	current_state.enter(owner)


func pop():
	if state_stack.is_empty():
		return

	var old_state = state_stack.pop_back()

	old_state.exit()

	if not state_stack.is_empty():
		current_state = state_stack[-1]
	else:
		current_state = null


func change_state(new_state: BaseState):
	if current_state:
		current_state.exit()

	state_stack.clear()

	state_stack.append(new_state)

	current_state = new_state

	current_state.enter(owner)


func get_previous_state():
	if state_stack.size() < 2:
		return null

	return state_stack[-2]
