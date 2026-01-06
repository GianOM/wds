extends Node3D

@onready var main_office_navigation_zone: NavigationRegion3D = $Main_Office_Navigation_Zone
var Spawn_Point: Vector3 = Vector3.ZERO

#func _ready() -> void:
	#
	#await get_tree().physics_frame 
	#
	#var WTF_IS_RID: RID = main_office_navigation_zone.get_navigation_map()
	#var WTF_IS_RID2: RID = main_office_navigation_zone.get_rid()
	#
	#var regionRID : Array[RID] = NavigationServer3D.map_get_regions(WTF_IS_RID)
	#
	##print(NavigationServer3D.map_get_random_point(WTF_IS_RID,1,false))
	#print(NavigationServer3D.region_get_random_point(WTF_IS_RID2,1,false))
	
	
	
#func _physics_process(delta: float) -> void:
	#
	#var WTF_IS_RID2: RID = main_office_navigation_zone.get_rid()
	#
	#Spawn_Point = NavigationServer3D.region_get_random_point(WTF_IS_RID2,1,false)
	#
	#if Spawn_Point != Vector3.ZERO:
		#set_physics_process(false)
		#print(Spawn_Point)
		
		
	#set_process(false)
