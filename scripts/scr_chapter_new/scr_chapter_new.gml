/// @description Constructor for loading Chapter data from JSON and providing type completion
/// see the actual json files for extended documentation on each property
function ChapterData() constructor {
	id = eCHAPTERS.UNKNOWN;
	name = "";
	points = 0;
	flavor = "";
	origin = eCHAPTER_ORIGINS.NONE;
	founding = eCHAPTERS.UNKNOWN;
	successors = 0;
	splash = 0;
	icon = 0;
	icon_name = "aa";
	aspirant_trial = eTrials.BLOODDUEL;
	fleet_type = eFLEET_TYPES.NONE;
	strength = 0;
	purity = 0;
	stability = 0;
	cooperation = 0;
	homeworld = "Hive"; //e.g. "Death"
	homeworld_name = global.name_generator.generate_star_name(); // e.g. "The Rock"
	homeworld_exists = 0;
	recruiting_exists = 0;
	recruiting = "Death"; 
	recruiting_name = global.name_generator.generate_star_name();
	homeworld_rule = eHOMEWORLD_RULE.NONE;
	flagship_name = global.name_generator.generate_imperial_ship_name();
	monastary_name = "";
	advantages = array_create(9);
	disadvantages = array_create(9);
	discipline = "default"; // todo convert to enum

	full_liveries = "none"

	colors = {
		main: "Grey",
		secondary: "Grey",
		pauldron_r: "Grey",
		pauldron_l: "Grey",
		trim: "Grey",
		lens: "Grey",
		weapon: "Grey",
		/// 0 - normal, 1 - Breastplate, 2 - Vertical, 3 - Quadrant
		special: 0,
		/// 0 no, 1 yes for special trim colours
		trim_on: 0,
	};
	names = {
		hchaplain: global.name_generator.generate_imperial_name(),
		clibrarian: global.name_generator.generate_imperial_name(),
		fmaster: global.name_generator.generate_imperial_name(),
		hapothecary: global.name_generator.generate_imperial_name(),
		recruiter: global.name_generator.generate_imperial_name(),
		admiral: global.name_generator.generate_imperial_name(),
		honorcapt: global.name_generator.generate_imperial_name(),
		watchmaster: global.name_generator.generate_imperial_name(),
		arsenalmaster: global.name_generator.generate_imperial_name(),
		marchmaster: global.name_generator.generate_imperial_name(),
		ritesmaster: global.name_generator.generate_imperial_name(),
		victualler: global.name_generator.generate_imperial_name(),
		lordexec: global.name_generator.generate_imperial_name(),
		relmaster: global.name_generator.generate_imperial_name(),
	};
	mutations = {
		preomnor: 0,
		voice: 0,
		doomed: 0,
		lyman: 0,
		omophagea: 0,
		ossmodula: 0,
		membrane: 0,
		zygote: 0,
		betchers: 0,
		catalepsean: 0,
		secretions: 0,
		occulobe: 0,
		mucranoid: 0,
	};
	battle_cry = "For the Emperor";
	equal_specialists = 0;
	load_to_ships = {
		escort_load: 0,
		split_scouts: 0,
		split_vets: 0,
	};
	/// @type {Array<Real>} 
	disposition = array_create(10, 0);
	/// @type {Array<String>} 
	company_titles = array_create(11, "");
	chapter_master = {
		name: global.name_generator.generate_imperial_name(),
		melee: 0,
		ranged: 0,
		specialty: eCM_SPECIALTY.NONE,
		/// @type {Array<String>}
		traits: [],
		gear: "",
		mobi: "",
		armour: "",
	};
	extra_ships = {
		battle_barges: 0,
		gladius: 0,
		strike_cruisers: 0,
		hunters: 0
	};
	extra_specialists = {
		chaplains: 0,
		techmarines: 0,
		apothecary: 0,
		epistolary: 0,
		codiciery: 0,
		lexicanum: 0,
		terminator: 0,
		assault: 0,
		veteran: 0,
		devastator: 0,
	};
	extra_marines = {
		second: 0,
		third: 0,
		fourth: 0,
		fifth: 0,
		sixth: 0,
		seventh: 0,
		eighth: 0,
		ninth: 0,
		tenth: 0,
	};
	extra_vehicles = {
		rhino: 0,
		whirlwind: 0,
		predator: 0,
		land_raider: 0,
		land_speeder: 0,
	}
	extra_equipment = [];
	custom_roles = {};
	squad_name = "Squad";
	custom_squads = {};


	/// @desc Returns true if loaded successfully, false if not.
	/// @param {Enum.eCHAPTERS} chapter_id 
	/// @param {Bool} use_app_data if set to true will read from %AppData%/Local/ChapterMaster instead of /datafiles
	/// @returns {Bool} 
	function load_from_json(chapter_id, use_app_data = false){
		var file_loader = new JsonFileListLoader();
		var load_result;
		if(use_app_data){
			load_result = file_loader.load_struct_from_json_file($"chaptersave#{chapter_id}.json", "chapter", true);
		} else {
			 load_result = file_loader.load_struct_from_json_file($"main\\chapters\\{chapter_id}.json", "chapter", false);
		}
		if(!load_result.is_success){
			// debugl($"No chapter json exits for chapter_id {chapter_id}");
			return false;
		}
		var json_chapter = load_result.value.chapter;
		var keys = struct_get_names(json_chapter);
		for(var i = 0; i < array_length(keys); i++){
			var key = keys[i];
			var val = struct_get(json_chapter, key);

			// Treat incoming empty vals as 'use default' and don't overwrite
			// a value if it was already set in the chapter constructor
			if(self[key] != "" && val == ""){
				continue;
			}
			struct_set(self, key, val);
		}
		return true;
	}
}

/// @mixin obj_creation
/// @description called when a chapter's icon is clicked on the first page after the main menu.
/// used to set up initialise the data that is later fed into `scr_initialize_custom` when the game starts
function scr_chapter_new(argument0) {

	full_liveries = "none"; // until chapter objects are in full use kicks off livery propogation

	// argument0 = chapter
	obj_creation.use_chapter_object = false; // for the new json testing
	var chapter_id = eCHAPTERS.UNKNOWN;

	//1st captain =	honor_captain_name	
	//2nd captain =	watch_master_name	
	//3rd captain = arsenal_master_name	
	//4th captain =	lord_admiral_name
	//5th captain =	march_master_name
	//6th captain =	rites_master_name
	//7th captain =	chief_victualler_name
	//8th captain =	lord_executioner_name
	//9th captain =	relic_master_name
	//10th captain = recruiter_name

	var i = 0;
	world = array_create(20, "");
	world_type = array_create(20, "");
	world_feature = array_create(20, "");
	

	points=100;maxpoints=100;custom=0;
	//Chapter Staff
	hapothecary=global.name_generator.generate_space_marine_name();
	hchaplain=global.name_generator.generate_space_marine_name();
	clibrarian=global.name_generator.generate_space_marine_name();
	fmaster=global.name_generator.generate_space_marine_name();
	//Company Captains
	honorcapt=global.name_generator.generate_space_marine_name();
	watchmaster=global.name_generator.generate_space_marine_name();
	arsenalmaster=global.name_generator.generate_space_marine_name();
	admiral=global.name_generator.generate_space_marine_name();
	marchmaster=global.name_generator.generate_space_marine_name();
	ritesmaster=global.name_generator.generate_space_marine_name();
	victualler=global.name_generator.generate_space_marine_name();
	lordexec=global.name_generator.generate_space_marine_name();
	relmaster=global.name_generator.generate_space_marine_name();
	recruiter=global.name_generator.generate_space_marine_name();

	
	function load_default_gear(_role_id, _role_name, _wep1, _wep2, _armour, _mobi, _gear){
		for(var i = 100; i <=102; i++){
			obj_creation.role[i][_role_id] = _role_name;
			obj_creation.wep1[i][_role_id] = _wep1;
			obj_creation.wep2[i][_role_id] = _wep2;
			obj_creation.armour[i][_role_id] = _armour;
			obj_creation.mobi[i][_role_id] = _mobi;
			obj_creation.gear[i][_role_id] = _gear;
			obj_creation.race[i][_role_id] = 1;
		}
	}
	load_default_gear(Role.HONOUR_GUARD, "Honour Guard", "Power Sword", "Bolter", "Artificer Armour", "", "");
	load_default_gear(Role.VETERAN, "Veteran", "Chainsword", "Combiflamer", "Power Armour", "", "");
	load_default_gear(Role.TERMINATOR, "Terminator", "Power Fist", "Storm Bolter", "Terminator Armour", "", "");
	load_default_gear(Role.CAPTAIN, "Captain", "Power Sword", "Bolt Pistol", "Power Armour", "", "Iron Halo");
	load_default_gear(Role.DREADNOUGHT, "Dreadnought", "Dreadnought Lightning Claw", "Lascannon", "Dreadnought", "", "");
	load_default_gear(Role.CHAMPION, "Champion", "Power Sword", "Power Armour", "Power Armour", "", "Combat Shield");
	load_default_gear(Role.TACTICAL, "Tactical", "Bolter", "Combat Knife", "Power Armour", "", "");
	load_default_gear(Role.DEVASTATOR, "Devastator", "", "Combat Knife", "Power Armour", "", "");
	load_default_gear(Role.ASSAULT, "Assault", "Chainsword", "Bolt Pistol", "Power Armour", "Jump Pack", "");
	load_default_gear(Role.ANCIENT, "Ancient", "Company Standard", "Bolt Pistol", "Power Armour", "", "");
	load_default_gear(Role.SCOUT, "Scout", "Bolter", "Combat Knife", "Scout Armour", "", "");
	load_default_gear(Role.CHAPLAIN, "Chaplain", "Crozius Arcanum", "Bolt Pistol", "Power Armour", "", "Rosarius");
	load_default_gear(Role.APOTHECARY, "Apothecary", "Chainsword", "Bolt Pistol", "Power Armour", "", "Narthecium");
	load_default_gear(Role.TECHMARINE, "Techmarine", "Power Axe", "Bolt Pistol", "Artificer Armour", "Servo-arm", "");
	load_default_gear(Role.LIBRARIAN, "Librarian", "Force Staff", "Bolt Pistol", "Power Armour", "", "Psychic Hood");
	load_default_gear(Role.SERGEANT, "Sergeant", "Chainsword", "Bolt Pistol", "Power Armour", "", "");
	load_default_gear(Role.VETERAN_SERGEANT, "Veteran Sergeant", "Chainsword", "Plasma Pistol", "Power Armour", "", "");


	for(var c = 0; c < array_length(obj_creation.all_chapters); c++){
		if(argument0 == obj_creation.all_chapters[c].name && obj_creation.all_chapters[c].json == true){
			obj_creation.use_chapter_object = true;
			chapter_id = obj_creation.all_chapters[c].id;
		}
	}

	if(obj_creation.use_chapter_object){

		var chapter_obj = new ChapterData();
		var successfully_loaded = chapter_obj.load_from_json(chapter_id);
		if(!successfully_loaded){
			var issue = $"No json file exists for chapter id {chapter_id} and name {argument0}";
			debugl (issue);
			scr_popup("Error Loading Chapter", issue, "debug");
			return false;
		}

		global.chapter_creation_object = chapter_obj;


	}


	#region V1 Chapter Initialised factions
	

	if (argument0="Carcharodons"){founding=9;points=100;
	    selected_chapter=15;chapter=argument0;icon=15;icon_name="cd";
	    fleet_type=2;strength=5;purity=8;stability=4;cooperation=5;
	    adv[1]="Assault Doctrine";adv[2]="Boarders";adv[3]="Kings of Space";dis[1]="Splintered";dis[2]="Suspicious";
	    homeworld_exists=0;recruiting_exists=0;flagship_name="Nicor";
	    recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_rule=0;aspirant_trial=eTrials.CHALLENGE;
	    color_to_main="Codex Grey";color_to_secondary="Codex Grey";color_to_trim="Copper";
	    color_to_pauldron2="Dark Grey";color_to_pauldron="Dark Grey";color_to_lens="Red";
	    color_to_weapon="Black";col_special=0;trim=1;
		hapothecary="Tamaron";hchaplain="Niko'manu";clibrarian="Te Kahurangi";fmaster="Uthulu";
		honorcapt="Tagaloa";watchmaster="Akamu";arsenalmaster="Akia";admiral="Mannfor";marchmaster="Fa'atiu";
		ritesmaster="Mafui'e";victualler="Aleki";lordexec="Atonga";relmaster="Enele";recruiter="Bail Sharr"
	    battle_cry="Silence";
	    equal_specialists=0;load_to_ships=[2,1,1];successors=0;
	    mutations=1;mutations_selected=1;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=1;
	    disposition[1]=30;// Prog
	    disposition[2]=40;disposition[3]=40;disposition[4]=40;disposition[5]=30;
	    disposition[6]=30;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Tyberos";chapter_master_melee=2;
	    chapter_master_ranged=1;chapter_master_specialty=2;
		role[i,4]="Red Brother";
		role[i,5]="Company Master";wep1[i,5]="Eviscerator";
		role[i,19]="Veteran Strike Leader";wep1[i,19]="Power Axe";
		role[i,18]="Strike Leader";wep1[i,18]="Chainaxe";
		role[i,8]="Void Brother";wep2[i,8]="Chainaxe";
		role[i,10]="Devourer";wep1[i,10]="Chainaxe";
		
	}
	
	if (argument0="Soul Drinkers"){points=200;
	    selected_chapter=16;chapter=argument0;icon=14;icon_name="sd";founding= 4;
	    fleet_type=2;strength=2;purity=10;stability=2;cooperation=2;
	    adv[1]="Assault Doctrine";adv[2]="Kings of Space";adv[3]="Boarders";adv[4]="Daemon Binders";dis[1]="Suspicious";
	    homeworld="Dead";homeworld_name="Entymion";
	    homeworld_exists=0;recruiting_exists=1;
	    recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_rule=0;aspirant_trial=eTrials.CHALLENGE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Purple";color_to_secondary="Purple";color_to_trim="Dark Gold";
	    color_to_pauldron2="Purple";color_to_pauldron="Purple";color_to_lens="Red";
	    color_to_weapon="Purple";col_special=0;trim=1;
	    battle_cry="Cold and Hard, Soul Drinkers";
	    equal_specialists=0;load_to_ships=[2,0,0];successors=0;
	    mutations=1;mutations_selected=1;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=1;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    disposition[1]=60;// Prog
	    disposition[2]=15;disposition[3]=20;disposition[4]=10;disposition[5]=25;
	    disposition[6]=50;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Sarpedon";chapter_master_melee=8;
	    chapter_master_ranged=3;chapter_master_specialty=3;
	}


	if (argument0="Doom Benefactors"){points=100;
	    selected_chapter=135;chapter=argument0;icon=0;icon_name="eye";founding=0;scr_icon("");
	    fleet_type=1;strength=1;purity=10;stability=7;cooperation=8;
	    homeworld="Forge";homeworld_name="Ariana Prime";recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_exists=1;recruiting_exists=1;homeworld_rule=2;aspirant_trial=eTrials.APPRENTICESHIP;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Dark Red";color_to_secondary="Black";color_to_trim="Copper";
	    color_to_pauldron="Black";color_to_pauldron2="Black";color_to_lens="Sanguine Red";
	    color_to_weapon="Black";col_special=0;trim=1;
	    hapothecary="Vaylund";
	    hchaplain="Eli";
	    clibrarian="Dagoth";
	    fmaster="Mjenzi";
	    admiral=global.name_generator.generate_space_marine_name();
	    battle_cry="Death to the enemy!  DEATH";// monastery_name="Fortress of Hera";master_name=
	    equal_specialists=0;
    
	    load_to_ships=[2,0,0];
	    // load_to_ships=0;
    
	    successors=0;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    disposition[1]=60;// Prog
	    disposition[2]=50;disposition[3]=40;disposition[4]=25;disposition[5]=40;
	    disposition[6]=50;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Duke Sacerdos";chapter_master_melee=7;
	    chapter_master_ranged=3;chapter_master_specialty=3;
    
	    adv[1]="Paragon";
	    adv[2]="Reverent Guardians";
	    adv[3]="Crafters";
	    dis[1]="First In, Last Out";
    
	    stage=6;
	}
	#endregion

	#region Custom Chapter
	//generates custom chapter if it exists
	if (is_real(argument0) && argument0 >= eCHAPTERS.CUSTOM_1 && argument0 <= eCHAPTERS.CUSTOM_10){
		obj_creation.use_chapter_object = true;
		var chapter_obj = new ChapterData();
		var successfully_loaded = chapter_obj.load_from_json(argument0, true);
		if(!successfully_loaded){
			var issue = $"No json file exists for chapter id {argument0} and name {argument0}";
			debugl (issue);
			scr_popup("Error Loading Chapter", issue, "debug");
			return false;
		}
		global.chapter_creation_object = chapter_obj;
	}
	#endregion



	if(obj_creation.use_chapter_object){
				
		var chapter_object = global.chapter_creation_object;
		
		// * All of this obj_creation setting is just to keep things working 
		obj_creation.founding = chapter_object.founding;
		obj_creation.successors = chapter_object.successors;
		obj_creation.homeworld_rule = chapter_object.homeworld_rule;
		obj_creation.chapter_name = chapter_object.name;

		obj_creation.icon = chapter_object.icon;
		obj_creation.icon_name = chapter_object.icon_name;
		obj_creation.fleet_type = chapter_object.fleet_type;
		obj_creation.strength = chapter_object.strength;
		obj_creation.purity = chapter_object.purity;
		obj_creation.stability = chapter_object.stability;
		obj_creation.cooperation = chapter_object.cooperation;
		
		obj_creation.homeworld_exists = chapter_object.homeworld_exists;
		obj_creation.homeworld = chapter_object.homeworld;
		obj_creation.homeworld_rule = chapter_object.homeworld_rule;

		obj_creation.recruiting_exists = chapter_object.recruiting_exists;
		obj_creation.recruiting = chapter_object.recruiting;
		obj_creation.recruiting_name = chapter_object.recruiting_name;

		obj_creation.aspirant_trial = trial_map(chapter_object.aspirant_trial);
		obj_creation.adv = chapter_object.advantages;
		obj_creation.dis = chapter_object.disadvantages;

		obj_creation.full_liveries = chapter_object.full_liveries;

		obj_creation.color_to_main = chapter_object.colors.main;
		obj_creation.color_to_secondary = chapter_object.colors.secondary;
		obj_creation.color_to_pauldron = chapter_object.colors.pauldron_r;
		obj_creation.color_to_pauldron2 = chapter_object.colors.pauldron_l;
		obj_creation.color_to_trim = chapter_object.colors.trim;
		obj_creation.color_to_lens = chapter_object.colors.lens;
		obj_creation.color_to_weapon = chapter_object.colors.weapon;
		obj_creation.col_special = chapter_object.colors.special;
		obj_creation.trim = chapter_object.colors.trim_on;

		// handles making sure blank names are generated properly and only 
		// actual values being set in the json will overwrite them
		struct_foreach(chapter_object.names, function(key, val){
			if(val != ""){
				struct_set(obj_creation, key, val);
			}
		});

		obj_creation.battle_cry = chapter_object.battle_cry;
		obj_creation.discipline = chapter_object.discipline;

		var load = chapter_object.load_to_ships;
		obj_creation.load_to_ships = [load.escort_load, load.split_scouts, load.split_vets];
		obj_creation.equal_specialists = chapter_object.equal_specialists;
		
		obj_creation.mutations = 0;
		struct_foreach(chapter_object.mutations, function(key, val){
			struct_set(obj_creation, key, val);
			if(val == 1) {
				obj_creation.mutations += 1;
			}
		});

		obj_creation.disposition = chapter_object.disposition;

		obj_creation.chapter_master = chapter_object.chapter_master;

		if(chapter_object.chapter_master.name != ""){
			obj_creation.chapter_master_name = chapter_object.chapter_master.name;
		}
		obj_creation.chapter_master_melee = chapter_object.chapter_master.melee;
		obj_creation.chapter_master_ranged = chapter_object.chapter_master.ranged;
		obj_creation.chapter_master_specialty = chapter_object.chapter_master.specialty;
		if(struct_exists(chapter_object, "company_titles")){
			obj_creation.company_title = chapter_object.company_titles;
		}

		if(struct_exists(chapter_object, "artifact")){
			obj_creation.artifact = chapter_object.artifact;
		}
		
		obj_creation.flagship_name = chapter_object.flagship_name;
		obj_creation.extra_ships = chapter_object.extra_ships;
		obj_creation.extra_specialists = chapter_object.extra_specialists;
		obj_creation.extra_marines = chapter_object.extra_marines;
		obj_creation.extra_vehicles = chapter_object.extra_vehicles;
		obj_creation.extra_equipment = chapter_object.extra_equipment;

		obj_creation.squad_name = chapter_object.squad_name;
		if(struct_exists(chapter_object, "custom_roles")){
			obj_creation.custom_roles = chapter_object.custom_roles;
		}
		if(struct_exists(chapter_object, "custom_squads")){
			obj_creation.custom_squads = chapter_object.custom_squads;
		}

		points = chapter_object.points;
		maxpoints=chapter_object.points;	

	}






	
	for(var a = 0; a < array_length(adv); a++){
	    for(var k = 0; k < array_length(obj_creation.all_advantages); k++){
			if(adv[a]!="" && obj_creation.all_advantages[k].name=adv[a]){
				adv_num[a] = k;
			}
		}
		for(var j = 0; j < array_length(obj_creation.all_disadvantages); j++){
			if (dis[a]!="" && obj_creation.all_disadvantages[j].name=dis[a]){
				dis_num[a]=j;
			}
		}
	}



	maxpoints=points;
	var livery_picker = new ColourItem(0,0);
	livery_picker.scr_unit_draw_data();
	full_liveries = array_create(21,DeepCloneStruct(livery_picker.map_colour));	
	return true;
}


enum eFLEET_TYPES {
	NONE = 0,
	HOMEWORLD = 1,
	FLEET_BASED,
	PENITENCE,
}

enum eHOMEWORLD_RULE {
	NONE = 0,
	GOVERNOR = 1,
	COUNTRY,
	PERSONAL,
}

enum eCM_SPECIALTY {
	NONE = 0,
	LEADER = 1,
	CHAMPION,
	PSYKER,
}
