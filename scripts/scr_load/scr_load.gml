function return_json_from_ini(ini_area,ini_code, default_val=[]){
	var ini_fetch = ini_read_string(ini_area,ini_code,"");
	if (ini_fetch!=""){
		return json_parse(base64_decode(ini_fetch));
	} else {
		return default_val;
	}
}

function load_marine_struct(company, marine){
		var marStruct = ini_read_string("Mar","Struct"+string(company)+"."+string(marine),"");
		if (marStruct != ""){
			marStruct = json_parse(base64_decode(marStruct));
			obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine, "blank");
			obj_ini.TTRPG[company, marine].load_json_data(marStruct);
			delete marStruct;
		} else {
			obj_ini.TTRPG[company, marine] = new TTRPG_stats("chapter", company, marine,"blank");
		}		
};

function scr_load(save_part, save_id) {
	var unit;
	var rang=0,stars=0,pfleets=0,efleets=0;

	var filename = $"save{save_id}.json";
	var fileid = file_text_open_read(filename);
	var raw_json = "";
	while(file_text_eof(fileid) == false){
		raw_json = string_concat(raw_json, file_text_readln(fileid))
	} 
	file_text_close(fileid);
	debugl(raw_json);
	var json_game_save = json_parse(raw_json);

	if(!struct_exists(obj_saveload.GameSave, "Save")){
		obj_saveload.GameSave = json_game_save.GameSave;
	}


	if (save_part=1) or (save_part=0){
		// Globals
		var globals = obj_saveload.GameSave.Save;
		global.chapter_icon_sprite = globals.chapter_icon_sprite;
		global.chapter_icon_frame = globals.chapter_icon_frame;
		global.chapter_icon_path = globals.chapter_icon_path;
		global.chapter_icon_filename = globals.chapter_icon_filename;
	    global.icon_name=globals.icon_name;


	}


	if (save_part=2) or (save_part=0){
		debugl("Loading slot "+string(save_id)+" part 2");

	    // Stars
		var star_array = obj_saveload.GameSave.Stars;
		for(var i = 0; i < array_length(star_array); i++){
			var deserialized = star_array[i];
    		instance_create_layer(deserialized.x, deserialized.y, deserialized.layer, obj_star, deserialized);
			// obj_star.deserialize(star_array[i]);
		}
	}




	if (save_part=3) or (save_part=0){debugl("Loading slot "+string(save_id)+" part 3");
		// Ini
		var deserialized = obj_saveload.GameSave.Ini;
    	instance_create_layer(deserialized.x, deserialized.y, deserialized.layer, obj_ini, deserialized);
		var livery_picker = new ColourItem(0,0);
		livery_picker.scr_unit_draw_data();
		if(struct_exists(deserialized, "full_liveries")){
			obj_ini.full_liveries = base64_decode(deserialized.full_liveries);
		} else {
			obj_ini.full_liveries = array_create(21,DeepCloneStruct(livery_picker.map_colour));
		}


		// Controller
		var deserialized = obj_saveload.GameSave.Controller;
    	var _controller_instance = instance_create_layer(deserialized.x, deserialized.y, deserialized.layer, obj_controller, deserialized);
		// with(_controller_instance){
		// 	scr_colors_initialize();
		// 	scr_shader_initialize();
		// 	// // **sets up starting forge_points
		// 	// location_viewer = new UnitQuickFindPanel();
		// 	// specialist_point_handler.calculate_research_points();
		// 	// //** sets up marine_by_location view
		// 	// global.star_name_colors[1] = make_color_rgb(body_colour_replace[0],body_colour_replace[1],body_colour_replace[2]);
		// }
	}



	if (save_part=4) or (save_part=0){
		debugl("Loading slot "+string(save_id)+" part 4");// PLAYER FLEET OBJECTS
	    var p_fleet = obj_saveload.GameSave.PlayerFleet;
		for(var i = 0; i < array_length(p_fleet); i++){
			var deserialized = p_fleet[i];
    		instance_create_layer(deserialized.x, deserialized.y, deserialized.layer, obj_p_fleet, deserialized);
		}
	}

	if (save_part=5) or (save_part=0){
	    var en_fleet = obj_saveload.GameSave.EnemyFleet;
		for(var i = 0; i < array_length(en_fleet); i++){
			var deserialized = en_fleet[i];
    		instance_create_layer(deserialized.x, deserialized.y, deserialized.layer, obj_en_fleet, deserialized);
		}
	    obj_saveload.alarm[1]=30;
	    obj_controller.invis=false;
	    global.load=0;
	    scr_image("force",-50,0,0,0,0);
	    log_message("Loading slot "+string(save_id)+" completed");
	}


}
