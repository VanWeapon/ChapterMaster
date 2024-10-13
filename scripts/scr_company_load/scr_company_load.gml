function scr_company_load(ship_loc) {

	var s=0,temp=0;

	for (var i=0;i<array_length(obj_ini.ship);i++){
	    if (obj_ini.ship[i]!="") and (obj_ini.ship_location[i]==ship_loc){
	        s++;
	        sh_ide[s]=i;
	        sh_name[s]=obj_ini.ship[i];
	        sh_class[s]=obj_ini.ship_class[i];
	        sh_loc[s]=obj_ini.ship_location[i];
	        sh_uid[s]=obj_ini.ship_uid[i];
	        temp=round(obj_ini.ship_hp[i]/obj_ini.ship_maxhp[i])*100;
	        sh_hp[s]=string(temp)+"% HP";
	        sh_cargo[s]=obj_ini.ship_carrying[i];
	        sh_cargo_max[s]=obj_ini.ship_capacity[i];
	    }
	}

	ship_current=1;
	ship_max=s;
	ship_see=30;

}
