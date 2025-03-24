function return_json_from_ini(ini_area,ini_code, default_val=[]){
	var ini_fetch = ini_read_string(ini_area,ini_code,"");
	if (ini_fetch!=""){
		return json_parse(base64_decode(ini_fetch));
	} else {
		return default_val;
	}
}

function load_marine_struct(company, marine, struct){

	obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine, "blank");
	obj_ini.TTRPG[company, marine].load_json_data(struct);
			
};

function scr_load(save_part, save_id) {
	var filename = $"save{save_id}.json";
	if(file_exists(filename)){
		var _gamesave_buffer = buffer_load(filename);
		var _gamesave_string = buffer_read(_gamesave_buffer, buffer_string);
		var json_game_save = json_parse(_gamesave_string);
	}

	if(!struct_exists(obj_saveload.GameSave, "Save")){
		obj_saveload.GameSave = json_game_save;
	}


	if (save_part=1) or (save_part=0){
		// Globals
		var globals = obj_saveload.GameSave.Save;
		global.chapter_icon_sprite = spr_icon_chapters;
		global.chapter_icon_frame = globals.chapter_icon_frame;
		global.chapter_icon_path = globals.chapter_icon_path;
		global.chapter_icon_filename = globals.chapter_icon_filename;
	    global.icon_name=globals.icon_name;
		global.chapter_name = globals.chapter_name;
		global.custom = globals.custom;
		// global.icon = globals.icon;
		

	}


	if (save_part=2) or (save_part=0){
		debugl("Loading slot "+string(save_id)+" part 2");

	    // Stars
		var star_array = obj_saveload.GameSave.Stars;
		for(var i = 0; i < array_length(star_array); i++){
			var star_save_data = star_array[i];
    		var star_instance = instance_create(0,0, obj_star);
			with(star_instance){
				deserialize(star_save_data);
			}
		}
	}

	if (save_part=3) or (save_part=0){debugl("Loading slot "+string(save_id)+" part 3");
		// Ini
		var ini_save_data = obj_saveload.GameSave.Ini;
		obj_ini.deserialize(ini_save_data);

		// Controller
		var con_save_data = obj_saveload.GameSave.Controller;
		with(obj_controller){
			load_con_data(con_save_data);
		}
	}



	if (save_part=4) or (save_part=0){
		debugl("Loading slot "+string(save_id)+" part 4");// PLAYER FLEET OBJECTS
	    var p_fleet = obj_saveload.GameSave.PlayerFleet;
		for(var i = 0; i < array_length(p_fleet); i++){
			var deserialized = p_fleet[i];
    		var p_fleet_instance = instance_create_layer(0,0, deserialized.layer, obj_p_fleet);
			with(p_fleet_instance){
				var exclusions = ["id"]; // skip automatic setting of certain vars, handle explicitly later

				// Automatic var setting
				var all_names = struct_get_names(p_fleet);
				var _len = array_length(all_names);
				for(var i = 0; i < _len; i++){
					var var_name = all_names[i];
					if(array_contains(exclusions, var_name)){
						continue;
					}
					var loaded_value = struct_get(deserialized_con, var_name);
					// show_debug_message($"p_fleet {p_fleet_instance.id}  - var: {var_name}  -  val: {loaded_value}");
					try {
						variable_struct_set(p_fleet_instance, var_name, loaded_value);	
					} catch (e){
						show_debug_message(e);
					}
				}
			}
		}
	}

	if (save_part=5) or (save_part=0){
	    var en_fleet = obj_saveload.GameSave.EnemyFleet;
		for(var i = 0; i < array_length(en_fleet); i++){
			var deserialized = en_fleet[i];
    		var en_fleet_instance = instance_create_layer(0,0, deserialized.layer, obj_en_fleet);
			with(en_fleet_instance){
				var exclusions = ["id"]; // skip automatic setting of certain vars, handle explicitly later

				// Automatic var setting
				var all_names = struct_get_names(en_fleet);
				var _len = array_length(all_names);
				for(var i = 0; i < _len; i++){
					var var_name = all_names[i];
					if(array_contains(exclusions, var_name)){
						continue;
					}
					var loaded_value = struct_get(deserialized_con, var_name);
					// show_debug_message($"en_fleet {en_fleet_instance.id}  - var: {var_name}  -  val: {loaded_value}");
					try {
						variable_struct_set(en_fleet_instance, var_name, loaded_value);	
					} catch (e){
						show_debug_message(e);
					}
				}
			}		
		}
	    obj_saveload.alarm[1]=30;
	    obj_controller.invis=false;
	    global.load=0;
	    scr_image("force",-50,0,0,0,0);
	    debugl("Loading slot "+string(save_id)+" completed");
		room_goto(Game);
	}


}
