
/// Slightly nicer syntax for working with dbg_views 
/// functions can be chained for simpler construction. Parameters passed into the "add_" functions should always match instance variable names. Local variables don't work with dbg_views
/// @param {String} view_name the title of the view
/// @param {Id.Instance|Struct} obj The object being debugged. Can be a regular struct, an instance or a full object
function DebugView(view_name, obj) constructor {

    view_ptr = dbg_view(view_name, false); // calling dbg_view opens the overlay automatically 
    obj_ref = obj;

    static add_watch = function (_name, _label = _name){
        dbg_watch(ref_create(self.obj_ref, _name), _label);
        return self;
    }

    static add_slider_int = function(_name, min, max, label = _name, step = 1){
        // dbgref: Array<Undefined.DbgRef>|Undefined.DbgRef, minimum?: Real, maximum?: Real, label?: String, step?: Real)
        dbg_slider_int(ref_create(self.obj_ref, _name), min, max, label, step);
        return self;
    }

    static add_slider = function(_name, min, max, label = _name, step = 0.01){
        dbg_slider(ref_create(self.obj_ref, _name), min, max, label = name, step);
        return self;
    }

    static add_checkbox = function(_name, _label = _name){
        dbg_checkbox(ref_create(self.obj_ref, _name), _label);
        return self;
    }

    static add_button = function(_label, fn){
        dbg_button(_label, fn);
        return self;
    }

    static add_section = function(_name, _open = true) {
        dbg_section(_name, true);
        return self;
    }

    static show = function(){
        show_debug_overlay(true);
        dbg_set_view(self.view_ptr)
        return self;
    }

    static hide = function(){
        show_debug_overlay(false);
        return self;
    }

    static delete_view = function(){
        dbg_view_delete(self.view_ptr);
        return self;
    }
}