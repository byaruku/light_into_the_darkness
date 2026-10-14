class_name NPCIchika
extends NPC

@export var question_count := 3
@export_file("*_de.json") var quiz_data_path_de: String
@export_file("*_en.json") var quiz_data_path_en: String
@export var yarn_node_after_quiz: String

var quiz_data
var quiz_data_path: String


func _ready() -> void:
	load_quiz_data()
	
	super._ready()


func interact() -> void:
	if state != State.IDLE:
		return
		
	state = State.DIALOG
	DialogueManager.switch_option_texture(false)
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
		
		DialogueManager.start_dialogue(yarn_node)
		await DialogueManager.on_dialog_finished
	
	DialogueManager.switch_option_texture(true)
	DialogueManager.start_dialogue(yarn_node_after_quiz)
	await DialogueManager.on_dialog_finished
	state = State.IDLE


func change_animation(animation_name: String):
	super.change_animation(animation_name)


func load_quiz_data():
	var language = DialogueManager.dialogue_runner.get_locale()
	if language == "de":
		quiz_data_path = quiz_data_path_de
	else:
		quiz_data_path = quiz_data_path_en
	
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
