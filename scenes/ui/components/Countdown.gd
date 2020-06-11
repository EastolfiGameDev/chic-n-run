extends Control

const INITIAL_NUMBER := 3
const TEXTURES: Dictionary = {
    "1": preload("res://assets/sprites/ui/hud/number_1.png"),
    "2": preload("res://assets/sprites/ui/hud/number_2.png"),
    "3": preload("res://assets/sprites/ui/hud/number_3.png")
}

var current_number := INITIAL_NUMBER

onready var rect: TextureRect = $TextureRect
onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    animation.play("setup")
    set_initial_texture()

func start_countdown():
    current_number = INITIAL_NUMBER
    animation.play("count")

func set_initial_texture() -> void:
    set_texture_for_number(3)

func set_texture_for_number(number: int) -> void:
    if TEXTURES.has(str(number)):
        rect.texture = TEXTURES.get(str(number))

func next_number() -> void:
    current_number -= 1
    
    if current_number == 0:
        end_countdown()
    else:
        set_texture_for_number(current_number)
        animation.play("count")

func end_countdown() -> void:
    Game.start_scroll()
