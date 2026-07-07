class_name NPCIchika
extends NPC

@export var question_count: int


func _ready() -> void:
	super._ready()


func interact() -> void:
	if state != State.IDLE:
		return
		
	state = State.DIALOG
	var questions = QuizData.get_questions()
	questions.shuffle()
	
	for i in range(question_count):
		var runner = DialogueManager.dialogue_runner
		var question = questions[i]
		
		runner.variable_storage.set_value("$question", question["question"])
		runner.variable_storage.set_value("$answer0", question["answer"][0])
		runner.variable_storage.set_value("$answer1", question["answer"][1])
		runner.variable_storage.set_value("$answer2", question["answer"][2])
		runner.variable_storage.set_value("$answer3", question["answer"][3])
		runner.variable_storage.set_value("$correct", question["correct"])
		runner.variable_storage.set_value("$selected", -1)
		
		await DialogueManager.start_dialogue(yarn_node)
	state = State.IDLE


func change_animation(animation_name: String):
	super.change_animation(animation_name)
