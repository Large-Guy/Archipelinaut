extends AnimationPlayer

func play_one_shot(animation: String):
	stop(false)
	play(animation)
