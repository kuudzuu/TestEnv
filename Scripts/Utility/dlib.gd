extends Node

## Convert array of x and y value to array of angle (in radians) and magnitude
func xy_to_vector(xy):
	var magnitude = sqrt(pow(xy[0], 2) + pow(xy[1], 2))
	var angle = atan2(xy[0], xy[1])
	return [angle, magnitude]

## Convert array of [angle, magnitude] to array of [x, y]
func vector_to_xy(vector):
	var x = vector[1] * sin(vector[0])
	var y = vector[1] * cos(vector[0])
	return [x, y]

## Find the resulting point when applying vector from a given point
func get_offset_from_point(point, angle, offset):
	var added_offset = vector_to_xy([angle, offset])
	return [point.x + added_offset[0], point.z + added_offset[1]]
