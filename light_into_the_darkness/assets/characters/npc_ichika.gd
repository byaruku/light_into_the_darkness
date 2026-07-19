class_name NPCIchika
extends NPC

@export var question_count := 3
@export_file("*.json") var quiz_data_path: String

var quiz_data


func _ready() -> void:
	super._ready()
	
	if not quiz_data_path:
		push_error("No path to the quiz-data-file set.")
		return
	
	var quiz_file = ResourceLoader.load(quiz_data_path)
	if not quiz_file:
		push_error("Error while loading the quiz-data: " + quiz_data_path)
		return
	
	var file = FileAccess.open(quiz_data_path, FileAccess.READ)
	if not file:
		push_error("Error while opening the quiz-data.")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	quiz_data = JSON.parse_string(json_string)
	if not quiz_data is Array:
		push_error("Invaild quiz-data-format: Expected format is an array.")
		quiz_data = []


func interact() -> void:
	if state != State.IDLE:
		return
		
	state = State.DIALOG
	quiz_data.shuffle()
	
	for i in range(min(question_count, quiz_data.size())):
		var runner = DialogueManager.dialogue_runner
		var question = quiz_data[i]
		
		for j in range(question["question"].size()):
			runner.variable_storage.set_value("$line" + str(j), question["question"][j])
		
		for j in range(question["options"].size()):
			runner.variable_storage.set_value("$option" + str(j), question["options"][j])
		
		runner.variable_storage.set_value("$answer", int(question["answer"]))
		runner.variable_storage.set_value("$selected", -1)
		
		await DialogueManager.start_dialogue(yarn_node)
	state = State.IDLE


func change_animation(animation_name: String):
	super.change_animation(animation_name)
