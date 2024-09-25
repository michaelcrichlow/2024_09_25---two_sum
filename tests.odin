package test

import "core:fmt"
import "core:mem"
print :: fmt.println
printf :: fmt.printf

DEBUG_MODE :: true

main :: proc() {

	when DEBUG_MODE {
		// tracking allocator
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf(
					"=== %v allocations not freed: context.allocator ===\n",
					len(track.allocation_map),
				)
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf(
					"=== %v incorrect frees: context.allocator ===\n",
					len(track.bad_free_array),
				)
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}

		// tracking temp_allocator
		track_temp: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track_temp, context.temp_allocator)
		context.temp_allocator = mem.tracking_allocator(&track_temp)

		defer {
			if len(track_temp.allocation_map) > 0 {
				fmt.eprintf(
					"=== %v allocations not freed: context.temp_allocator ===\n",
					len(track_temp.allocation_map),
				)
				for _, entry in track_temp.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track_temp.bad_free_array) > 0 {
				fmt.eprintf(
					"=== %v incorrect frees: context.temp_allocator ===\n",
					len(track_temp.bad_free_array),
				)
				for entry in track_temp.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track_temp)
		}
	}

	// main work
	my_list := [?]int{2, 7, 11, 15}

	val := two_sum(my_list[:], 9)
	defer delete(val)

	print(val)

}

two_sum :: proc(nums: []int, target: int, the_allocator := context.allocator) -> [dynamic]int {
	num_dict := make(map[int]int, allocator = the_allocator)
	final_list := make([dynamic]int, allocator = the_allocator)
	defer delete(num_dict)
	// memory allocated for `final_list` will be freed in main()

	// as you build dictionary, check to see if 'target - val' is already in it
	for val, i in nums {
		if (target - val) in num_dict {
			append(&final_list, i)
			append(&final_list, num_dict[target - val])
			break
		}
		num_dict[val] = i
	}
	return final_list
}
