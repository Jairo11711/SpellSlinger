extends Node
class_name BaseCommand

signal finished

func execute(actor) -> void:
	emit_signal("finished")
