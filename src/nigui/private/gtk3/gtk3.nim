# NiGui - minimal GTK+ 3 binding

{.deadCodeElim: on.}

when defined(windows):
  const libgtk3Path* = "libgtk-3-0.dll"
elif defined(gtk_quartz):
  const libgtk3Path* = "libgtk-3.0.dylib"
elif defined(macosx):
  const libgtk3Path* = "libgtk-x11-3.0.dylib"
else:
  const libgtk3Path* = "libgtk-3.so(|.0)"

{.pragma: libgtk3, cdecl, dynlib: libgtk3Path.}

# ----------------------------------------------------------------------------------------
#                                       Types
# ----------------------------------------------------------------------------------------

type
  GError* {.byCopy.} = object
    domain*: int32
    code*: cint
    message*: cstring

  GdkRectangle* {.byCopy.} = object
    x*, y*: cint
    width*, height*: cint

  GtkBorder* {.byCopy.} = object
    left*: int16
    right*: int16
    top*: int16
    bottom*: int16

  GdkRGBA* {.byCopy.} = object
    red*: cdouble
    green*: cdouble
    blue*: cdouble
    alpha*: cdouble

  GList* = ptr object
    data*: pointer
    next*: GList
    prev*: GList

  GtkTargetEntry* {.byCopy.} = object
    target*: cstring
    flags*: cint
    info*: cint

  GdkEventButton* {.byCopy.} = object
    event_type*: cint
    window*: pointer
    send_event*: int8
    time*: cint
    x*, y*: cdouble
    axes*: ptr cdouble
    state*: cint
    button*: cint
    device*: pointer
    x_root*, y_root*: cdouble

  GdkEventKey* {.byCopy.} = object
    event_type*: cint
    window*: pointer
    send_event*: int8
    time*: cint
    state*: cint
    keyval*: cint
    length*: cint
    `string`*: cstring
    hardware_keycode*: int16
    group*: int8
    is_modifier*: int8

  GtkTextIter* {.byCopy.} = object
    dummy1: pointer
    dummy2: pointer
    dummy3: cint
    dummy4: cint
    dummy5: cint
    dummy6: cint
    dummy7: cint
    dummy8: cint
    dummy9: pointer
    dummy10: pointer
    dummy11: cint
    dummy12: cint
    dummy13: cint
    dummy14: pointer

# ----------------------------------------------------------------------------------------
#                                       Constants
# ----------------------------------------------------------------------------------------

const
  # GtkWindowType:
  GTK_WINDOW_TOPLEVEL* = 0
  GTK_WINDOW_POPUP*    = 1

  # GtkDestDefaults:
  # [..]
  GTK_DEST_DEFAULT_ALL* = 7

  # GdkDragAction:
  GDK_ACTION_DEFAULT* = 1
  GDK_ACTION_COPY*    = 2
  GDK_ACTION_MOVE*    = 4
  GDK_ACTION_LINK*    = 8
  GDK_ACTION_PRIVATE* = 16
  GDK_ACTION_ASK*     = 32

  # GtkOrientation:
  GTK_ORIENTATION_HORIZONTAL* = 0
  GTK_ORIENTATION_VERTICAL*   = 1

  # GtkWrapMode:
  GTK_WRAP_NONE*      = 0
  GTK_WRAP_CHAR*      = 1
  GTK_WRAP_WORD*      = 2
  GTK_WRAP_WORD_CHAR* = 3

  # GtkPolicyType:
  GTK_POLICY_ALWAYS*    = 0
  GTK_POLICY_AUTOMATIC* = 1
  GTK_POLICY_NEVER*     = 2
  GTK_POLICY_EXTERNAL*  = 3

  # PangoEllipsizeMode:
  PANGO_ELLIPSIZE_NONE*   = 0
  PANGO_ELLIPSIZE_START*  = 1
  PANGO_ELLIPSIZE_MIDDLE* = 2
  PANGO_ELLIPSIZE_END*    = 3

  # GtkButtonBoxStyle:
  GTK_BUTTONBOX_SPREAD* = 0
  GTK_BUTTONBOX_EDGE*   = 1
  GTK_BUTTONBOX_START*  = 2
  GTK_BUTTONBOX_END*    = 3
  GTK_BUTTONBOX_CENTER* = 4
  GTK_BUTTONBOX_EXPAND* = 5

  # GtkJustification:
  GTK_JUSTIFY_LEFT*   = 0
  GTK_JUSTIFY_RIGHT*  = 1
  GTK_JUSTIFY_CENTER* = 2
  GTK_JUSTIFY_FILL*   = 3

  # GtkStateFlags:
  GTK_STATE_FLAG_NORMAL* = 0
  # [..]

  # GdkEventMask:
  GDK_BUTTON_PRESS_MASK*   = 256
  GDK_BUTTON_RELEASE_MASK* = 512
  GDK_KEY_PRESS_MASK*      = 1024
  # [..]

  # cairo_format_t:
  CAIRO_FORMAT_ARGB32* = 0
  # [..]

  # GtkFileChooserAction:
  GTK_FILE_CHOOSER_ACTION_OPEN* = 0
  GTK_FILE_CHOOSER_ACTION_SAVE* = 1
  GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER* = 2
  GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER* = 3

  # GtkResponseType:
  GTK_RESPONSE_NONE*         = -1
  GTK_RESPONSE_REJECT*       = -2
  GTK_RESPONSE_ACCEPT*       = -3
  GTK_RESPONSE_DELETE_EVENT* = -4
  GTK_RESPONSE_OK*           = -5
  GTK_RESPONSE_CANCEL*       = -6
  GTK_RESPONSE_CLOSE*        = -7
  GTK_RESPONSE_YES*          = -8
  GTK_RESPONSE_NO*           = -9
  GTK_RESPONSE_APPLY*        = -10
  GTK_RESPONSE_HELP*         = -11

# ----------------------------------------------------------------------------------------
#                                   General Gtk Procs
# ----------------------------------------------------------------------------------------

proc g_slist_length*(list: pointer): int {.importc: "g_slist_length", libgtk3.}
proc g_slist_nth_data_string*(list: pointer, n: int): cstring {.importc: "g_slist_nth_data", libgtk3.}

proc gtk_init*(argc, argv: pointer) {.importc: "gtk_init", libgtk3.}

proc gtk_main*() {.importc: "gtk_main", libgtk3.}
proc gtk_main_quit*() {.importc: "gtk_main_quit", libgtk3.}
proc gtk_events_pending*(): cint {.importc: "gtk_events_pending", libgtk3.}
proc gtk_main_iteration*(): cint {.importc: "gtk_main_iteration", libgtk3.}
proc g_timeout_add*(interval: cint, function, data: pointer): cint {.importc: "g_timeout_add", libgtk3.}
proc g_source_remove*(tag: cint): bool {.importc: "g_source_remove", libgtk3.}
proc g_signal_connect_data*(instance: pointer, detailed_signal: cstring, c_handler: pointer, data, destroy_data, connect_flags: pointer = nil): pointer {.importc: "g_signal_connect_data", libgtk3.}

proc gtk_window_new*(`type`: cint): pointer {.importc: "gtk_window_new", libgtk3.}
proc gtk_window_set_title*(window: pointer, title: cstring) {.importc: "gtk_window_set_title", libgtk3.}
# proc gtk_window_get_title*(window: pointer): cstring {.importc: "gtk_window_get_title", libgtk3.}
proc gtk_window_set_transient_for*(window, parent: pointer) {.importc: "gtk_window_set_transient_for", libgtk3.}
proc gtk_window_set_modal*(window: pointer, modal: cint) {.importc: "gtk_window_set_modal", libgtk3.}
# proc gtk_window_set_default_size*(window: pointer, width, height: cint) {.importc: "gtk_window_set_default_size", libgtk3.}
proc gtk_window_resize*(window: pointer, width, height: cint) {.importc: "gtk_window_resize", libgtk3.}
proc gtk_window_resize_to_geometry*(window: pointer, width, height: cint) {.importc: "gtk_window_resize_to_geometry", libgtk3.}
proc gtk_window_get_size*(window: pointer, width, height: var cint) {.importc: "gtk_window_get_size", libgtk3.}
proc gtk_window_get_position*(window: pointer, x, y: var cint) {.importc: "gtk_window_get_position", libgtk3.}
proc gtk_window_move*(window: pointer, x, y: cint) {.importc: "gtk_window_move", libgtk3.}
proc gtk_window_set_icon_from_file*(window: pointer, filename: cstring, err: pointer) {.importc: "gtk_window_set_icon_from_file", libgtk3.}

proc gdk_window_begin_paint_rect*(window: pointer, rectangle: var GdkRectangle) {.importc: "gdk_window_begin_paint_rect", libgtk3.}
proc gdk_window_begin_paint_region*(window: pointer, region: pointer) {.importc: "gdk_window_begin_paint_region", libgtk3.}
proc gdk_window_end_paint*(window: pointer) {.importc: "gdk_window_end_paint", libgtk3.}
proc gdk_window_get_clip_region*(window: pointer): pointer {.importc: "gdk_window_get_clip_region", libgtk3.}

proc gtk_widget_destroy*(widget: pointer) {.importc: "gtk_widget_destroy", libgtk3.}
proc gtk_widget_show*(widget: pointer) {.importc: "gtk_widget_show", libgtk3.}
proc gtk_widget_hide*(widget: pointer) {.importc: "gtk_widget_hide", libgtk3.}
proc gtk_widget_set_size_request*(widget: pointer, width, height: cint) {.importc: "gtk_widget_set_size_request", libgtk3.}
proc gtk_widget_size_allocate*(widget: pointer, allocation: var GdkRectangle) {.importc: "gtk_widget_size_allocate", libgtk3.}
proc gtk_widget_get_size_request*(widget: pointer, width, height: var cint) {.importc: "gtk_widget_get_size_request", libgtk3.}
proc gtk_widget_get_allocation*(widget: pointer, allocation: var GdkRectangle) {.importc: "gtk_widget_get_allocation", libgtk3.}
# proc gtk_widget_set_allocation*(widget: pointer, allocation: var GdkRectangle) {.importc: "gtk_widget_set_allocation", libgtk3.}
# proc gtk_widget_set_hexpand*(widget: pointer, expand: cint) {.importc: "gtk_widget_set_hexpand", libgtk3.}
proc gtk_widget_queue_draw*(widget: pointer) {.importc: "gtk_widget_queue_draw", libgtk3.}
proc gtk_widget_set_margin_top*(widget: pointer, margin: cint) {.importc: "gtk_widget_set_margin_top", libgtk3.}
proc gtk_widget_add_events*(widget: pointer, events: cint) {.importc: "gtk_widget_add_events", libgtk3.}
proc gtk_widget_set_can_focus*(widget: pointer, can_focus: cint) {.importc: "gtk_widget_set_can_focus", libgtk3.}
proc gtk_widget_modify_font*(widget: pointer, font_desc: pointer) {.importc: "gtk_widget_modify_font", libgtk3.}
proc gtk_widget_override_color*(widget: pointer, state: cint, color: var GdkRGBA) {.importc: "gtk_widget_override_color", libgtk3.}
proc gtk_widget_override_background_color*(widget: pointer, state: cint, color: var GdkRGBA) {.importc: "gtk_widget_override_background_color", libgtk3.}
proc gtk_widget_get_path*(widget: pointer): pointer {.importc: "gtk_widget_get_path", libgtk3.}
proc gtk_widget_style_get*(widget: pointer, first_property_name: cstring, value: pointer, passNil: pointer) {.importc: "gtk_widget_style_get", libgtk3.}
proc gtk_widget_get_style_context*(widget: pointer): pointer {.importc: "gtk_widget_get_style_context", libgtk3.}
proc gtk_widget_grab_focus*(widget: pointer) {.importc: "gtk_widget_grab_focus", libgtk3.}
proc gtk_widget_is_focus*(widget: pointer): bool {.importc: "gtk_widget_is_focus", libgtk3.}
proc gtk_widget_realize*(widget: pointer) {.importc: "gtk_widget_realize", libgtk3.}
proc gtk_widget_draw*(widget, cr: pointer) {.importc: "gtk_widget_draw", libgtk3.}

proc gtk_container_add*(container, widget: pointer) {.importc: "gtk_container_add", libgtk3.}
proc gtk_container_remove*(container, widget: pointer) {.importc: "gtk_container_remove", libgtk3.}
# proc gtk_container_foreach*(container, callback, callback_data: pointer) {.importc: "gtk_container_foreach", libgtk3.}
proc gtk_container_get_children*(container: pointer): GList {.importc: "gtk_container_get_children", libgtk3.}
proc gtk_container_set_border_width*(container: pointer, width: cint) {.importc: "gtk_container_set_border_width", libgtk3.}

proc gtk_fixed_new*(): pointer {.importc: "gtk_fixed_new", libgtk3.}
proc gtk_fixed_move*(fixed, widget: pointer, x, y: cint) {.importc: "gtk_fixed_move", libgtk3.}

proc gtk_layout_new*(hadjustment, vadjustment: pointer): pointer {.importc: "gtk_layout_new", libgtk3.}
# proc gtk_layout_put*(layout, child_widget: pointer, x, y: cint) {.importc: "gtk_layout_put", libgtk3.}
proc gtk_layout_move*(layout, child_widget: pointer, x, y: cint) {.importc: "gtk_layout_move", libgtk3.}
# proc gtk_layout_set_size*(layout: pointer, width, height: cint) {.importc: "gtk_layout_set_size", libgtk3.}
# proc gtk_layout_get_hadjustment*(layout: pointer): pointer {.importc: "gtk_layout_get_hadjustment", libgtk3.}
# proc gtk_layout_get_vadjustment*(layout: pointer): pointer {.importc: "gtk_layout_get_vadjustment", libgtk3.}

# proc gtk_scrollbar_new*(orientation: GtkOrientation, adjustment: pointer): pointer {.importc: "gtk_scrollbar_new", libgtk3.}

proc gtk_dialog_new*(): pointer {.importc: "gtk_dialog_new", libgtk3.}
proc gtk_dialog_run*(dialog: pointer): cint {.importc: "gtk_dialog_run", libgtk3.}
proc gtk_dialog_add_button*(dialog: pointer, button_text: cstring, response_id: cint): pointer {.importc: "gtk_dialog_add_button", libgtk3.}
proc gtk_dialog_get_content_area*(dialog: pointer): pointer {.importc: "gtk_dialog_get_content_area", libgtk3.}
proc gtk_dialog_get_action_area*(dialog: pointer): pointer {.importc: "gtk_dialog_get_action_area", libgtk3.}

proc gtk_file_chooser_dialog_new*(title: string, parent: pointer, action: int, text1: cstring, response1: int, text2: cstring, response2: int, ending: pointer): pointer {.importc: "gtk_file_chooser_dialog_new", libgtk3.}
proc gtk_file_chooser_set_current_name*(chooser: pointer, name: cstring): bool {.importc: "gtk_file_chooser_set_current_name", libgtk3.}
proc gtk_file_chooser_get_filename*(chooser: pointer): cstring {.importc: "gtk_file_chooser_get_filename", libgtk3.}
proc gtk_file_chooser_get_filenames*(chooser: pointer): pointer {.importc: "gtk_file_chooser_get_filenames", libgtk3.}
proc gtk_file_chooser_set_select_multiple*(chooser: pointer, select_multiple: bool) {.importc: "gtk_file_chooser_set_select_multiple", libgtk3.}
proc gtk_file_chooser_set_current_folder*(chooser: pointer, filename: cstring): bool {.importc: "gtk_file_chooser_set_current_folder", libgtk3.}

proc gtk_button_box_set_layout*(widget: pointer, layout_style: cint) {.importc: "gtk_button_box_set_layout", libgtk3.}

# proc gtk_message_dialog_new*(parent: pointer, flags: GtkDialogFlags, `type`: GtkMessageType, buttons: GtkButtonsType, message_format: cstring): pointer {.importc: "gtk_message_dialog_new", libgtk3.}

proc gtk_label_new*(str: cstring): pointer {.importc: "gtk_label_new", libgtk3.}
proc gtk_label_set_text*(label: pointer, str: cstring) {.importc: "gtk_label_set_text", libgtk3.}
# proc gtk_label_get_text*(label: pointer): cstring {.importc: "gtk_label_get_text", libgtk3.}
proc gtk_label_set_ellipsize*(label: pointer, mode: cint) {.importc: "gtk_label_set_ellipsize", libgtk3.}
# proc gtk_label_set_justify*(label: pointer, jtype: cint) {.importc: "gtk_label_set_justify", libgtk3.}
proc gtk_label_set_xalign*(label: pointer, xalign: cfloat) {.importc: "gtk_label_set_xalign", libgtk3.}
proc gtk_label_set_yalign*(label: pointer, yalign: cfloat) {.importc: "gtk_label_set_yalign", libgtk3.}

# proc gtk_box_new*(orientation: GtkOrientation, spacing: cint): pointer {.importc: "gtk_box_new", libgtk3.}
proc gtk_box_pack_start*(box, child: pointer, expand, fill: cint, padding: cint) {.importc: "gtk_box_pack_start", libgtk3.}

proc gtk_button_new*(): pointer {.importc: "gtk_button_new", libgtk3.}
# proc gtk_button_new_with_label*(label: cstring): pointer {.importc: "gtk_button_new_with_label", libgtk3.}
# proc gtk_button_get_label*(button: pointer): cstring {.importc: "gtk_button_get_label", libgtk3.}
proc gtk_button_set_label*(button: pointer, label: cstring) {.importc: "gtk_button_set_label", libgtk3.}

proc gtk_entry_new*(): pointer {.importc: "gtk_entry_new", libgtk3.}
proc gtk_entry_set_text*(entry: pointer, text: cstring) {.importc: "gtk_entry_set_text", libgtk3.}
proc gtk_entry_get_text*(entry: pointer): cstring {.importc: "gtk_entry_get_text", libgtk3.}
proc gtk_entry_set_width_chars*(entry: pointer, n_chars: cint) {.importc: "gtk_entry_set_width_chars", libgtk3.}

proc gtk_text_view_new*(): pointer {.importc: "gtk_text_view_new", libgtk3.}
proc gtk_text_view_set_buffer*(text_view, buffer: pointer) {.importc: "gtk_text_view_set_buffer", libgtk3.}
proc gtk_text_view_get_buffer*(text_view: pointer): pointer {.importc: "gtk_text_view_get_buffer", libgtk3.}
proc gtk_text_view_set_wrap_mode*(text_view: pointer, wrap_mode: cint) {.importc: "gtk_text_view_set_wrap_mode", libgtk3.}
proc gtk_text_view_set_left_margin*(text_view: pointer, margin: cint) {.importc: "gtk_text_view_set_left_margin", libgtk3.}
proc gtk_text_view_set_right_margin*(text_view: pointer, margin: cint) {.importc: "gtk_text_view_set_right_margin", libgtk3.}
proc gtk_text_view_set_top_margin*(text_view: pointer, margin: cint) {.importc: "gtk_text_view_set_top_margin", libgtk3.}
proc gtk_text_view_set_bottom_margin*(text_view: pointer, margin: cint) {.importc: "gtk_text_view_set_bottom_margin", libgtk3.}
proc gtk_text_view_scroll_to_iter*(text_view: pointer, iter: var GtkTextIter, within_margin: cfloat, use_align: bool, xalign, yalign: cfloat) {.importc: "gtk_text_view_scroll_to_iter", libgtk3.}
# proc gtk_text_view_scroll_to_mark*(text_view, mark: pointer, within_margin: cfloat, use_align: bool, xalign, yalign: cfloat) {.importc: "gtk_text_view_scroll_to_mark", libgtk3.}
# proc gtk_text_view_place_cursor_onscreen*(text_view: pointer): bool {.importc: "gtk_text_view_place_cursor_onscreen", libgtk3.}

# proc gtk_text_mark_new*(name: cstring, left_gravity: bool): pointer {.importc: "gtk_text_mark_new", libgtk3.}

# proc gtk_text_buffer_new*(table: pointer): pointer {.importc: "gtk_text_buffer_new", libgtk3.}
proc gtk_text_buffer_set_text*(text_buffer: pointer, text: cstring, len: cint) {.importc: "gtk_text_buffer_set_text", libgtk3.}
proc gtk_text_buffer_get_text*(text_buffer: pointer, start, `end`: var GtkTextIter, include_hidden_chars: cint): cstring {.importc: "gtk_text_buffer_get_text", libgtk3.}
proc gtk_text_buffer_get_start_iter*(text_buffer: pointer, iter: var GtkTextIter) {.importc: "gtk_text_buffer_get_start_iter", libgtk3.}
proc gtk_text_buffer_get_end_iter*(text_buffer: pointer, iter: var GtkTextIter) {.importc: "gtk_text_buffer_get_end_iter", libgtk3.}
# proc gtk_text_buffer_add_mark*(buffer, mark: pointer, where: var GtkTextIter) {.importc: "gtk_text_buffer_add_mark", libgtk3.}
# proc gtk_text_buffer_get_insert*(buffer: pointer): pointer {.importc: "gtk_text_buffer_get_insert", libgtk3.}
# proc gtk_text_buffer_get_iter_at_line*(buffer: pointer, iter: var GtkTextIter, line_number: cint) {.importc: "gtk_text_buffer_get_iter_at_line", libgtk3.}
proc gtk_text_buffer_insert*(buffer: pointer, iter: var GtkTextIter, text: cstring, len: cint) {.importc: "gtk_text_buffer_insert", libgtk3.}

proc gtk_scrolled_window_new*(hadjustment, vadjustment: pointer): pointer {.importc: "gtk_scrolled_window_new", libgtk3.}
proc gtk_scrolled_window_set_policy*(scrolled_window: pointer, hscrollbar_policy, vscrollbar_policy: cint) {.importc: "gtk_scrolled_window_set_policy", libgtk3.}
proc gtk_scrolled_window_get_hscrollbar*(scrolled_window: pointer): pointer {.importc: "gtk_scrolled_window_get_hscrollbar", libgtk3.}
proc gtk_scrolled_window_get_vscrollbar*(scrolled_window: pointer): pointer {.importc: "gtk_scrolled_window_get_vscrollbar", libgtk3.}
proc gtk_scrolled_window_get_hadjustment*(scrolled_window: pointer): pointer {.importc: "gtk_scrolled_window_get_hadjustment", libgtk3.}
proc gtk_scrolled_window_get_vadjustment*(scrolled_window: pointer): pointer {.importc: "gtk_scrolled_window_get_vadjustment", libgtk3.}
# proc gtk_scrolled_window_get_max_content_width*(scrolled_window: pointer): cint {.importc: "gtk_scrolled_window_get_max_content_width", libgtk3.}
# proc gtk_scrolled_window_get_min_content_width*(scrolled_window: pointer): cint {.importc: "gtk_scrolled_window_get_min_content_width", libgtk3.}
# proc gtk_scrolled_window_set_overlay_scrolling*(scrolled_window: pointer, overlay_scrolling: bool) {.importc: "gtk_scrolled_window_set_overlay_scrolling", libgtk3.}

proc gtk_frame_new*(label: cstring): pointer {.importc: "gtk_frame_new", libgtk3.}
proc gtk_frame_set_label*(frame: pointer, label: cstring) {.importc: "gtk_frame_set_label", libgtk3.}
proc gtk_frame_get_label_widget*(frame: pointer): pointer {.importc: "gtk_frame_get_label_widget", libgtk3.}

proc gtk_drawing_area_new*(): pointer {.importc: "gtk_drawing_area_new", libgtk3.}

proc gtk_adjustment_get_value*(adjustment: pointer): cdouble {.importc: "gtk_adjustment_get_value", libgtk3.}
proc gtk_adjustment_set_value*(adjustment: pointer, value: cdouble) {.importc: "gtk_adjustment_set_value", libgtk3.}
proc gtk_adjustment_set_upper*(adjustment: pointer, upper: cdouble) {.importc: "gtk_adjustment_set_upper", libgtk3.}
proc gtk_adjustment_get_upper*(adjustment: pointer): cdouble {.importc: "gtk_adjustment_get_upper", libgtk3.}
proc gtk_adjustment_set_page_size*(adjustment: pointer, page_size: cdouble) {.importc: "gtk_adjustment_set_page_size", libgtk3.}
proc gtk_adjustment_get_page_size*(adjustment: pointer): cdouble {.importc: "gtk_adjustment_get_page_size", libgtk3.}

proc gtk_drag_dest_set*(widget: pointer, flags: cint, targets: pointer, n_targets: cint, actions: cint) {.importc: "gtk_drag_dest_set", libgtk3.}

proc gdk_keyval_to_unicode*(keyval: cint): cint {.importc: "gdk_keyval_to_unicode", libgtk3.}

proc gdk_screen_get_default*(): pointer {.importc: "gdk_screen_get_default", libgtk3.}
proc gdk_screen_get_primary_monitor*(screen: pointer): cint {.importc: "gdk_screen_get_primary_monitor", libgtk3.}
# proc gdk_screen_get_width*(screen: pointer): cint {.importc: "gdk_screen_get_width", libgtk3.}
# proc gdk_screen_get_height*(screen: pointer): cint {.importc: "gdk_screen_get_height", libgtk3.}
proc gdk_screen_get_monitor_workarea*(screen: pointer, monitor_num: cint, dest: var GdkRectangle) {.importc: "gdk_screen_get_monitor_workarea", libgtk3.}

proc gtk_style_context_get_padding*(context: pointer, state: cint, padding: var GtkBorder) {.importc: "gtk_style_context_get_padding", libgtk3.}
proc gtk_style_context_get_background_color*(context: pointer, state: cint, color: var GdkRGBA) {.importc: "gtk_style_context_get_background_color", libgtk3.}
proc gtk_style_context_get_color*(context: pointer, state: cint, color: var GdkRGBA) {.importc: "gtk_style_context_get_color", libgtk3.}
# proc gtk_style_context_get_font*(context: pointer, state: cint): pointer {.importc: "gtk_style_context_get_font", libgtk3.}

proc gtk_border_new*(): pointer {.importc: "gtk_border_new", libgtk3.}

# proc gdk_threads_init*() {.importc: "gdk_threads_init", libgtk3.}
# proc gdk_threads_add_idle*(function, data: pointer): cint {.importc: "gdk_threads_add_idle", libgtk3.}

proc gtk_scrollbar_new*(orientation: cint, adjustment: pointer): pointer {.importc: "gtk_scrollbar_new", libgtk3.}

proc gtk_adjustment_new*(value, lower, upper, step_increment, page_increment, page_size: cdouble): pointer {.importc: "gtk_adjustment_new", libgtk3.}

# proc gtk_selection_data_get_length*(selection_data: pointer): cint {.importc: "gtk_selection_data_get_length", libgtk3.}
# proc gtk_selection_data_get_text*(selection_data: pointer): cstring {.importc: "gtk_selection_data_get_text", libgtk3.}

proc gtk_selection_data_get_uris*(selection_data: pointer): ptr cstring {.importc: "gtk_selection_data_get_uris", libgtk3.}
proc g_filename_from_uri*(uri: pointer): cstring {.importc: "g_filename_from_uri", libgtk3.}


# ----------------------------------------------------------------------------------------
#                                   Drawing Related Procs
# ----------------------------------------------------------------------------------------

proc gtk_widget_create_pango_layout*(widget: pointer, text: cstring): pointer {.importc: "gtk_widget_create_pango_layout", libgtk3.}
proc gdk_cairo_set_source_rgba*(cr: pointer, rgba: var GdkRGBA) {.importc: "gdk_cairo_set_source_rgba", libgtk3.}
proc gdk_cairo_surface_create_from_pixbuf*(pixbuf: pointer, scale: cint, for_window: pointer): pointer {.importc: "gdk_cairo_surface_create_from_pixbuf", libgtk3.}
proc gdk_pixbuf_new_from_file*(filename: cstring, error: pointer): pointer {.importc: "gdk_pixbuf_new_from_file", libgtk3.}
proc gdk_pixbuf_save*(pixbuf: pointer, filename, `type`: cstring, error: pointer, param5, param6, param7: cstring): bool {.importc: "gdk_pixbuf_save", libgtk3.}
proc gdk_pixbuf_get_from_surface*(surface: pointer, src_x, src_y, width, height: cint): pointer {.importc: "gdk_pixbuf_get_from_surface", libgtk3.}
# proc gdk_pixmap_create_from_data*(drawable, data: pointer, width, height, depth: cint, fg, bg: var GdkRGBA): pointer {.importc: "gdk_pixmap_create_from_data", libgtk3.}

proc cairo_image_surface_create*(format: cint, width, height: cint): pointer {.importc: "cairo_image_surface_create", libgtk3.}
# proc cairo_image_surface_create_for_data*(data: pointer, format: cairo_format_t, width, height, stride: cint): pointer {.importc: "cairo_image_surface_create_for_data", libgtk3.}
proc cairo_image_surface_get_width*(surface: pointer): cint {.importc: "cairo_image_surface_get_width", libgtk3.}
proc cairo_image_surface_get_height*(surface: pointer): cint {.importc: "cairo_image_surface_get_height", libgtk3.}
proc cairo_image_surface_get_stride*(surface: pointer): cint {.importc: "cairo_image_surface_get_stride", libgtk3.}
proc cairo_image_surface_get_data*(surface: pointer): cstring {.importc: "cairo_image_surface_get_data", libgtk3.}
proc cairo_surface_flush*(surface: pointer) {.importc: "cairo_surface_flush", libgtk3.}
proc cairo_surface_mark_dirty*(surface: pointer) {.importc: "cairo_surface_mark_dirty", libgtk3.}
proc cairo_surface_destroy*(surface: pointer) {.importc: "cairo_surface_destroy", libgtk3.}

# proc cairo_format_stride_for_width*(format: cairo_format_t, width: cint): cint {.importc: "cairo_format_stride_for_width", libgtk3.}

proc cairo_create*(target: pointer): pointer {.importc: "cairo_create", libgtk3.}
proc cairo_get_target*(cr: pointer): pointer {.importc: "cairo_get_target", libgtk3.}
proc cairo_set_source_rgb*(cr: pointer, red, green, blue: cdouble) {.importc: "cairo_set_source_rgb", libgtk3.}
proc cairo_set_source_surface*(cr, surface: pointer, x, y: cdouble) {.importc: "cairo_set_source_surface", libgtk3.}
proc cairo_fill*(cr: pointer) {.importc: "cairo_fill", libgtk3.}
proc cairo_stroke*(cr: pointer) {.importc: "cairo_stroke", libgtk3.}
proc cairo_rectangle*(cr: pointer, x, y, width, height: cdouble) {.importc: "cairo_rectangle", libgtk3.}
proc cairo_line_to*(cr: pointer, x, y: cdouble) {.importc: "cairo_line_to", libgtk3.}
proc cairo_move_to*(cr: pointer, x, y: cdouble) {.importc: "cairo_move_to", libgtk3.}
proc cairo_set_line_width*(cr: pointer, width: cdouble) {.importc: "cairo_set_line_width", libgtk3.}
# proc cairo_image_surface_create_from_png*(filename: cstring): pointer {.importc: "cairo_image_surface_create_from_png", libgtk3.}
proc cairo_paint*(cr: pointer) {.importc: "cairo_paint", libgtk3.}
proc cairo_scale*(cr: pointer, x, y: cdouble) {.importc: "cairo_scale", libgtk3.}
proc cairo_translate*(cr: pointer, tx, ty: cdouble) {.importc: "cairo_translate", libgtk3.}
# proc cairo_set_antialias*(cr: pointer, antialias: cint) {.importc: "cairo_set_antialias", libgtk3.}
proc cairo_save*(cr: pointer) {.importc: "cairo_save", libgtk3.}
proc cairo_restore*(cr: pointer) {.importc: "cairo_restore", libgtk3.}

proc pango_cairo_show_layout*(cr, layout: pointer) {.importc: "pango_cairo_show_layout", libgtk3.}
proc pango_cairo_create_layout*(cr: pointer): pointer {.importc: "pango_cairo_create_layout", libgtk3.}
proc pango_layout_set_text*(layout: pointer, text: cstring, length: cint) {.importc: "pango_layout_set_text", libgtk3.}
proc pango_layout_get_pixel_size*(layout: pointer, width, height: var cint) {.importc: "pango_layout_get_pixel_size", libgtk3.}
proc pango_layout_set_font_description*(layout, desc: pointer) {.importc: "pango_layout_set_font_description", libgtk3.}
proc pango_font_description_new*(): pointer {.importc: "pango_font_description_new", libgtk3.}
proc pango_font_description_set_family*(desc: pointer, family: cstring) {.importc: "pango_font_description_set_family", libgtk3.}
proc pango_font_description_set_size*(desc: pointer, size: cint) {.importc: "pango_font_description_set_size", libgtk3.}
# proc pango_font_description_get_size*(desc: pointer): cint {.importc: "pango_font_description_get_size", libgtk3.}
# proc pango_layout_set_markup*(layout: pointer, markup: cstring, length: cint) {.importc: "pango_layout_set_markup", libgtk3.}
# proc pango_layout_new*(context: pointer): pointer {.importc: "pango_layout_new", libgtk3.}


