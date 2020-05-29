extends Node2D

#export(Array, PackedScene) var pool: Array = []
export(String) var path: String
export var min_y: int = 430
export var max_y: int = 430
export var starting_x: int = 1000
export var object_velocity = 5
export var min_spawn_wait_ms = 1000
export var max_spawn_wait_ms = 2000

const LEFT_BOUND = -70

var copies_of_each: int = 2
var object_pool: Array = []
var object_pool_available: Array = []
var max_available_objects: int
var last_spawn_time_ms: int = 0
var rand_spawn_wait_ms: int = 0

func _ready() -> void:
    var paths: Array = _get_full_paths(path)
    for path in paths:
        var resource: PackedScene = load(path)
        for i in copies_of_each:
            var prop: Node2D = resource.instance()
            prop.global_position = _get_random_global_position(prop)
            object_pool.append(prop)
            object_pool_available.append(prop)
            
            get_parent().call_deferred("add_child_below_node", self, prop)
    
    max_available_objects = paths.size() * copies_of_each

func _process(delta: float) -> void:
    var time_diff: int = OS.get_system_time_msecs() - last_spawn_time_ms
    
    if time_diff > rand_spawn_wait_ms:
        var available_object: Node2D = _find_and_remove_available_object()
        if available_object:
            available_object.global_position = _get_random_global_position(available_object)
            available_object.start(object_velocity)
            last_spawn_time_ms = OS.get_system_time_msecs()
            rand_spawn_wait_ms = rand_range(min_spawn_wait_ms, max_spawn_wait_ms)
        _add_to_available_objects()

# Returns and removes a random object from the pool of available objects, 
# if one exists.
func _find_and_remove_available_object() -> Node2D:
    if object_pool_available.size() == 0:
        return null
    
    var available_index: int = randi() % object_pool_available.size()
    var available_object: Node2D = object_pool_available[available_index]
    object_pool_available.remove(available_index)
    
    return available_object

# Goes through all the objects in the object pool and moves the available ones
# to the available object pool.
func _add_to_available_objects() -> void:
#    var object: Node2D
    for object in object_pool:
        if object.is_inside_tree() and object.global_position.x < LEFT_BOUND:
            object.global_position = _get_random_global_position(object)
            object.reset()
            object_pool_available.append(object)
    assert(object_pool_available.size() <= max_available_objects)

func _get_full_paths(path: String) -> Array:
    if path.ends_with(".tscn"):
        return [path]
    
    var files: Array = _list_files_in_directory(path)
    var paths = []
    for file in files:
        paths.append(path + file)
    
    return paths

"""
Given a path to a directory, returns the names of all
files in that directory.
@param path the path to a directory, e.g. 'res://scenes/characters/'
@return the names of all files in that directory, e.g. ['CaptainHook.tscn']
"""
func _list_files_in_directory(path: String) -> Array:
    var files = []
    var dir = Directory.new()
    
    dir.open(path)
    
    # Initialize stream used to list all files and directories
    dir.list_dir_begin()
    
#    var file: String = dir.get_next()
#    while (file and file.length() > 0):
#        if not file.begins_with("."):
#            files.append(file)
    
    while true:
        var file: String = dir.get_next()
        if file == "":
            break
        elif not file.begins_with(".") and not file.ends_with(".gd"):
            files.append(file)
    
    dir.list_dir_end()
    
    return files


# Gets a random (within certain boundaries) global position to spawn the 
# passed-in object at.
func _get_random_global_position(object: Node2D) -> Vector2:
    var texture_height: float = object.get_height()
    var starting_y: float = rand_range(min_y, max_y) - (texture_height / 2)
    return Vector2(starting_x, starting_y)
