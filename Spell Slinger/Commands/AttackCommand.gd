extends BaseCommand
class_name AttackCommand

var mouse_position:Vector2

func execute(actor) -> void:
	actor.attack(mouse_position)
	emit_signal("finished")
	yield(actor.animationPlayer,  "finished")
	print("command completed")
