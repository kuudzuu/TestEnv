extends Node

## Convert array of x and y value to array of angle (in radians) and magnitude
func xy_to_vector(xy):
	var magnitude = sqrt(pow(xy[0], 2) + pow(xy[1], 2))
	var angle = atan2(xy[0], xy[1])
	return [angle, magnitude]

func xy_to_angle(xy):
	return atan2(xy[0], xy[1])

func xy_to_mag(xy):
	return sqrt(pow(xy[0], 2) + pow(xy[1], 2))

func xyz_to_mag(xyz):
	return sqrt(pow(xyz[0], 2) + pow(xyz[1], 2) + pow(xyz[2], 2))

## Convert array of [angle, magnitude] to array of [x, y]
func vector_to_xy(vector):
	var x = vector[1] * sin(vector[0])
	var y = vector[1] * cos(vector[0])
	return [x, y]

func angle_between_xy(xy1, xy2):
	return xy_to_angle([xy2[0] - xy1[0], xy2[1] - xy1[1]])

func vector_between_xy(xy1, xy2):
	return xy_to_vector([xy2[0] - xy1[0], xy2[1] - xy1[1]])

func norm_cam_rot(rotation):
	return fmod(rotation, deg_to_rad(360))

func point_by_vector_offset(point, vector):
	var added_offset = vector_to_xy(vector)
	return [point.x + added_offset[0], point.z + added_offset[1]]

## Blends values a and b together based on alteration percent t.
## t is clamped between 0 and 1
## When t is 0, a is output. When t is 1, b is output.
func blend_linear(a, b, t):
	t = clamp(t, 0.0, 1.0)
	return (a * t) + (b * (1-t))
