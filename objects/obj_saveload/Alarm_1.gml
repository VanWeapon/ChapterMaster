
obj_controller.menu=0;obj_controller.zui=0;obj_controller.invis=false;
obj_cursor.image_alpha=1;obj_controller.cooldown=20;


if (global.restart>0){
    
    with(obj_ini){
        instance_destroy();
    }
    room_instance_add(Creation, 0, 0, obj_cursor);
    room_instance_add(Creation, 0, 0, obj_main_menu_buttons);
    room_instance_add(Creation, 0, 0, obj_creation);
    room_goto(Creation);
}

instance_destroy();


