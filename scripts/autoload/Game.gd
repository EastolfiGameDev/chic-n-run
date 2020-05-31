extends Node

signal scroll_started
signal game_ended(score)

func start_countdown() -> void:
    print("3")
    yield(get_tree().create_timer(1.0), "timeout")
    print("2")
    yield(get_tree().create_timer(1.0), "timeout")
    print("1")
    yield(get_tree().create_timer(1.0), "timeout")
    print("Start")

    emit_signal("scroll_started")

func end_run() -> void:
    # save score
    emit_signal("game_ended", 0)
