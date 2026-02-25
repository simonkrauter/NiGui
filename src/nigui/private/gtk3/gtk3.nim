# NiGui - minimal GTK+ 3 binding

when defined(windows):
  const libgtk3Path = "libgtk-3-0.dll"
  {.pragma: libgtk3, cdecl, dynlib: libgtk3Path.}
elif defined(macosx):
  import os
  # Resolved at runtime (inside DatInit) so the binary works on any machine
  # regardless of where Homebrew is installed.
  # Priority: HOMEBREW_PREFIX env var → known locations → bare name fallback.
  proc findGtk3LibPath(): string =
    let envPrefix = getEnv("HOMEBREW_PREFIX")
    if envPrefix.len > 0 and fileExists(envPrefix & "/lib/libgtk-3.0.dylib"):
      return envPrefix & "/lib/libgtk-3.0.dylib"
    if fileExists("/opt/homebrew/lib/libgtk-3.0.dylib"):
      return "/opt/homebrew/lib/libgtk-3.0.dylib"
    if fileExists("/usr/local/lib/libgtk-3.0.dylib"):
      return "/usr/local/lib/libgtk-3.0.dylib"
    return "libgtk-3.0.dylib"
  {.pragma: libgtk3, cdecl, dynlib: findGtk3LibPath().}
else:
  const libgtk3Path = "libgtk-3.so(|.0)"
  {.pragma: libgtk3, cdecl, dynlib: libgtk3Path.}

# ----------------------------------------------------------------------------------------
#                                       Types
# ----------------------------------------------------------------------------------------

type
  Gboolean* = distinct cint

  GError* {.bycopy.} = object
    domain*: int32
    code*: cint
    message*: cstring

  GdkRectangle* {.bycopy.} = object
    x*, y*: cint
    width*, height*: cint

  GtkBorder* {.bycopy.} = object
    left*: int16
    right*: int16
    top*: int16
    bottom*: int16

  GdkRGBA* {.bycopy.} = object
    red*: cdouble
    green*: cdouble
    blue*: cdouble
    alpha*: cdouble

  GList* = ptr object
    data*: pointer
    next*: GList
    prev*: GList

  GtkTargetEntry* {.bycopy.} = object
    target*: cstring
    flags*: cint
    info*: cint

  GdkEventButton* {.bycopy.} = object
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

  GdkEventMotion* {.bycopy.} = object
    event_type*: cint
    window*: pointer
    send_event*: int8
    time*: cint
    x*, y*: cdouble
    axes*: ptr cdouble
    state*: cint
    is_hint*: int16
    device*: pointer
    x_root*, y_root*: cdouble

  GdkEventCrossing* {.bycopy.} = object
    event_type*: cint
    window*: pointer
    send_event*: int8
    subwindow*: pointer
    time*: cint
    x*, y*: cdouble
    x_root*, y_root*: cdouble
    mode*: cint
    detail*: cint
    focus*: bool
    device*: pointer
    state*: cint

  GdkEventKey* {.bycopy.} = object
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

  GdkEventWindowState* {.bycopy.} = object
    event_type*: cint
    window*: pointer
    send_event*: int8
    changed_mask*: cint
    new_window_state*: cint

  GdkEventFocus* {.bycopy.} = object
    event_type*: cint
    window*: pointer
    send_event*: int8
    `in`*: int16

  GtkTextIter* {.bycopy.} = object
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

  GdkGeometry* {.bycopy.} = object
    min_width*: cint
    min_height*: cint
    max_width*: cint
    max_height*: cint
    base_width*: cint
    base_height*: cint
    width_inc*: cint
    height_inc*: cint
    min_aspect*: cdouble
    max_aspect*: cdouble
    win_gravity*: cint


converter gbool*(val: bool): Gboolean = ord(val).Gboolean

converter toBool*(val: Gboolean): bool = int(val) != 0


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
  GDK_POINTER_MOTION_MASK* = 1 shl 2
  GDK_BUTTON_PRESS_MASK*   = 1 shl 8
  GDK_BUTTON_RELEASE_MASK* = 1 shl 9
  GDK_KEY_PRESS_MASK*      = 1 shl 10
  GDK_ENTER_NOTIFY_MASK*   = 1 shl 12
  GDK_LEAVE_NOTIFY_MASK*   = 1 shl 13
  # [..]

  # cairo_format_t:
  CAIRO_FORMAT_ARGB32* = 0
  # [..]

  # cairo_filter_t:
  CAIRO_FILTER_NEAREST* = 3
  CAIRO_FILTER_BILINEAR* = 4

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

  # Selection:
  GDK_SELECTION_CLIPBOARD* = cast[pointer](69)

  # Key modifier masks:
  GDK_CONTROL_MASK* = 1 shl 2

  # GdkWindowState:
  GDK_WINDOW_STATE_WITHDRAWN*  = 1
  GDK_WINDOW_STATE_ICONIFIED*  = 2
  GDK_WINDOW_STATE_MAXIMIZED*  = 4
  GDK_WINDOW_STATE_STICKY*     = 8
  GDK_WINDOW_STATE_FULLSCREEN* = 16
  GDK_WINDOW_STATE_ABOVE*      = 32
  GDK_WINDOW_STATE_BELOW*      = 64
  GDK_WINDOW_STATE_FOCUSED*    = 128
  GDK_WINDOW_STATE_TILED*      = 256

  # GSignalMatchType:
  G_SIGNAL_MATCH_ID*        = 1
  G_SIGNAL_MATCH_DETAIL*    = 2
  G_SIGNAL_MATCH_CLOSURE*   = 4
  G_SIGNAL_MATCH_FUNC*      = 8
  G_SIGNAL_MATCH_DATA*      = 16
  G_SIGNAL_MATCH_UNBLOCKED* = 16

  # GdkWindowTypeHint
  GDK_WINDOW_TYPE_HINT_NORMAL* = 0
  GDK_WINDOW_TYPE_HINT_DIALOG* = 1
  GDK_WINDOW_TYPE_HINT_MENU* = 2
  GDK_WINDOW_TYPE_HINT_TOOLBAR* = 3
  GDK_WINDOW_TYPE_HINT_SPLASHSCREEN* = 4
  GDK_WINDOW_TYPE_HINT_UTILITY* = 5
  GDK_WINDOW_TYPE_HINT_DOCK* = 6
  GDK_WINDOW_TYPE_HINT_DESKTOP* = 7
  GDK_WINDOW_TYPE_HINT_DROPDOWN_MENU* = 8
  GDK_WINDOW_TYPE_HINT_POPUP_MENU* = 9
  GDK_WINDOW_TYPE_HINT_TOOLTIP* = 10
  GDK_WINDOW_TYPE_HINT_NOTIFICATION* = 11
  GDK_WINDOW_TYPE_HINT_COMBO* = 12
  GDK_WINDOW_TYPE_HINT_DND* = 13

  # GdkWindowHints
  GDK_HINT_MIN_SIZE* = 2


# ----------------------------------------------------------------------------------------
#                                   General Gtk Procs
# ----------------------------------------------------------------------------------------

proc g_slist_length*(list: pointer): cint {.importc, libgtk3.}
proc g_slist_nth_data*(list: pointer, n: cint): cstring {.importc, libgtk3.}
proc g_object_ref*(`object`: pointer): pointer {.importc, libgtk3.}
proc g_object_unref*(`object`: pointer) {.importc, libgtk3.}

proc gtk_init*(argc, argv: pointer) {.importc, libgtk3.}

proc gtk_main*() {.importc, libgtk3.}
proc gtk_main_quit*() {.importc, libgtk3.}
proc gtk_events_pending*(): cint {.importc, libgtk3.}
proc gtk_main_iteration*(): cint {.importc, libgtk3.}
proc g_timeout_add*(interval: cint, function, data: pointer): cint {.importc, libgtk3.}
proc g_source_remove*(tag: cint): bool {.importc, libgtk3.}
proc g_signal_connect_data*(instance: pointer, detailed_signal: cstring, c_handler: pointer, data, destroy_data, connect_flags: pointer = nil): pointer {.importc, libgtk3.}
proc g_signal_handlers_block_matched*(instance: pointer, mask, signal_id: cint, detail, closure, function, data: pointer = nil) {.importc, libgtk3.}
proc g_signal_handlers_unblock_matched*(instance: pointer, mask, signal_id: cint, detail, closure, function, data: pointer = nil) {.importc, libgtk3.}

proc gtk_window_new*(`type`: cint): pointer {.importc, libgtk3.}
proc gtk_window_set_title*(window: pointer, title: cstring) {.importc, libgtk3.}
# proc gtk_window_get_title*(window: pointer): cstring {.importc, libgtk3.}
proc gtk_window_set_transient_for*(window, parent: pointer) {.importc, libgtk3.}
proc gtk_window_set_modal*(window: pointer, modal: cint) {.importc, libgtk3.}
proc gtk_window_set_type_hint*(window: pointer, hint: cint) {.importc, libgtk3.}
proc gtk_window_set_default_size*(window: pointer, width, height: cint) {.importc, libgtk3.}
proc gtk_window_resize*(window: pointer, width, height: cint) {.importc, libgtk3.}
proc gtk_window_resize_to_geometry*(window: pointer, width, height: cint) {.importc, libgtk3.}
proc gtk_window_set_resizable*(window: pointer, resizable: bool) {.importc, libgtk3.}
proc gtk_window_set_geometry_hints*(window: pointer, geometry_widget: pointer, geometry: var GdkGeometry, geom_mask: cint) {.importc, libgtk3.}
proc gtk_window_get_size*(window: pointer, width, height: var cint) {.importc, libgtk3.}
proc gtk_window_get_position*(window: pointer, x, y: var cint) {.importc, libgtk3.}
proc gtk_window_move*(window: pointer, x, y: cint) {.importc, libgtk3.}
proc gtk_window_set_icon_from_file*(window: pointer, filename: cstring, err: pointer): bool {.importc, libgtk3.}
proc gtk_window_iconify*(window: pointer) {.importc, libgtk3.}
proc gtk_window_deiconify*(window: pointer) {.importc, libgtk3.}
proc gtk_window_present*(window: pointer) {.importc, libgtk3.}
proc gtk_window_set_keep_above*(window: pointer, setting: bool) {.importc, libgtk3.}

proc gdk_window_begin_paint_rect*(window: pointer, rectangle: var GdkRectangle) {.importc, libgtk3.}
proc gdk_window_begin_paint_region*(window: pointer, region: pointer) {.importc, libgtk3.}
proc gdk_window_end_paint*(window: pointer) {.importc, libgtk3.}
proc gdk_window_get_clip_region*(window: pointer): pointer {.importc, libgtk3.}

proc gtk_widget_destroy*(widget: pointer) {.importc, libgtk3.}
proc gtk_widget_show*(widget: pointer) {.importc, libgtk3.}
proc gtk_widget_hide*(widget: pointer) {.importc, libgtk3.}
proc gtk_widget_set_size_request*(widget: pointer, width, height: cint) {.importc, libgtk3.}
proc gtk_widget_size_allocate*(widget: pointer, allocation: var GdkRectangle) {.importc, libgtk3.}
proc gtk_widget_get_size_request*(widget: pointer, width, height: var cint) {.importc, libgtk3.}
proc gtk_widget_get_allocation*(widget: pointer, allocation: var GdkRectangle) {.importc, libgtk3.}
# proc gtk_widget_set_allocation*(widget: pointer, allocation: var GdkRectangle) {.importc, libgtk3.}
# proc gtk_widget_set_hexpand*(widget: pointer, expand: cint) {.importc, libgtk3.}
proc gtk_widget_queue_draw*(widget: pointer) {.importc, libgtk3.}
proc gtk_widget_set_margin_top*(widget: pointer, margin: cint) {.importc, libgtk3.}
proc gtk_widget_add_events*(widget: pointer, events: cint) {.importc, libgtk3.}
proc gtk_widget_set_can_focus*(widget: pointer, can_focus: cint) {.importc, libgtk3.}
proc gtk_widget_modify_font*(widget: pointer, font_desc: pointer) {.importc, libgtk3.}
proc gtk_widget_override_color*(widget: pointer, state: cint, color: var GdkRGBA) {.importc, libgtk3.}
proc gtk_widget_override_background_color*(widget: pointer, state: cint, color: var GdkRGBA) {.importc, libgtk3.}
proc gtk_widget_get_path*(widget: pointer): pointer {.importc, libgtk3.}
proc gtk_widget_style_get*(widget: pointer, first_property_name: cstring, value: pointer, passNil: pointer) {.importc, libgtk3.}
proc gtk_widget_get_style_context*(widget: pointer): pointer {.importc, libgtk3.}
proc gtk_widget_grab_focus*(widget: pointer) {.importc, libgtk3.}
proc gtk_widget_is_focus*(widget: pointer): bool {.importc, libgtk3.}
proc gtk_widget_realize*(widget: pointer) {.importc, libgtk3.}
proc gtk_widget_draw*(widget, cr: pointer) {.importc, libgtk3.}
proc gtk_widget_set_sensitive*(widget: pointer, sensitive: bool) {.importc, libgtk3.}
proc gtk_widget_get_pointer*(widget: pointer, x, y: var cint) {.importc, libgtk3.}
proc gtk_widget_set_tooltip_text*(widget: pointer, text: cstring) {.importc, libgtk3.}

proc gtk_container_add*(container, widget: pointer) {.importc, libgtk3.}
proc gtk_container_remove*(container, widget: pointer) {.importc, libgtk3.}
# proc gtk_container_foreach*(container, callback, callback_data: pointer) {.importc, libgtk3.}
proc gtk_container_get_children*(container: pointer): GList {.importc, libgtk3.}
proc gtk_container_set_border_width*(container: pointer, width: cint) {.importc, libgtk3.}

proc gtk_fixed_new*(): pointer {.importc, libgtk3.}
proc gtk_fixed_move*(fixed, widget: pointer, x, y: cint) {.importc, libgtk3.}

proc gtk_layout_new*(hadjustment, vadjustment: pointer): pointer {.importc, libgtk3.}
# proc gtk_layout_put*(layout, child_widget: pointer, x, y: cint) {.importc, libgtk3.}
proc gtk_layout_move*(layout, child_widget: pointer, x, y: cint) {.importc, libgtk3.}
proc gtk_layout_set_size*(layout: pointer, width, height: cint) {.importc, libgtk3.}
# proc gtk_layout_get_hadjustment*(layout: pointer): pointer {.importc, libgtk3.}
# proc gtk_layout_get_vadjustment*(layout: pointer): pointer {.importc, libgtk3.}

# proc gtk_scrollbar_new*(orientation: GtkOrientation, adjustment: pointer): pointer {.importc, libgtk3.}

proc gtk_dialog_new*(): pointer {.importc, libgtk3.}
proc gtk_dialog_run*(dialog: pointer): cint {.importc, libgtk3.}
proc gtk_dialog_add_button*(dialog: pointer, button_text: cstring, response_id: cint): pointer {.importc, libgtk3.}
proc gtk_dialog_get_content_area*(dialog: pointer): pointer {.importc, libgtk3.}
proc gtk_dialog_get_action_area*(dialog: pointer): pointer {.importc, libgtk3.}

proc gtk_file_chooser_dialog_new*(title: cstring, parent: pointer, action: cint, text1: cstring, response1: cint, text2: cstring, response2: cint, ending: pointer): pointer {.importc, libgtk3.}
proc gtk_file_chooser_set_current_name*(chooser: pointer, name: cstring): bool {.importc, libgtk3.}
proc gtk_file_chooser_get_filename*(chooser: pointer): cstring {.importc, libgtk3.}
proc gtk_file_chooser_get_filenames*(chooser: pointer): pointer {.importc, libgtk3.}
proc gtk_file_chooser_set_select_multiple*(chooser: pointer, select_multiple: bool) {.importc, libgtk3.}
proc gtk_file_chooser_set_current_folder*(chooser: pointer, filename: cstring): bool {.importc, libgtk3.}

proc gtk_button_box_set_layout*(widget: pointer, layout_style: cint) {.importc, libgtk3.}

# proc gtk_message_dialog_new*(parent: pointer, flags: GtkDialogFlags, `type`: GtkMessageType, buttons: GtkButtonsType, message_format: cstring): pointer {.importc, libgtk3.}

proc gtk_label_new*(str: cstring): pointer {.importc, libgtk3.}
# proc gtk_label_set_text*(label: pointer, str: cstring) {.importc, libgtk3.}
# proc gtk_label_get_text*(label: pointer): cstring {.importc, libgtk3.}
proc gtk_label_set_ellipsize*(label: pointer, mode: cint) {.importc, libgtk3.}
# proc gtk_label_set_justify*(label: pointer, jtype: cint) {.importc, libgtk3.}
# proc gtk_label_set_xalign*(label: pointer, xalign: cfloat) {.importc, libgtk3.}
# proc gtk_label_set_yalign*(label: pointer, yalign: cfloat) {.importc, libgtk3.}

proc gtk_progress_bar_new*(): pointer {.importc, libgtk3.}
proc gtk_progress_bar_set_fraction*(pbar: pointer, fraction: cdouble) {.importc, libgtk3.}

proc gtk_level_bar_new*(): pointer {.importc, libgtk3.}
proc gtk_level_bar_set_value*(pbar: pointer, value: cdouble) {.importc, libgtk3.}

# proc gtk_box_new*(orientation: GtkOrientation, spacing: cint): pointer {.importc, libgtk3.}
proc gtk_box_pack_start*(box, child: pointer, expand, fill: cint, padding: cint) {.importc, libgtk3.}

proc gtk_button_new*(): pointer {.importc, libgtk3.}
# proc gtk_button_new_with_label*(label: cstring): pointer {.importc, libgtk3.}
# proc gtk_button_get_label*(button: pointer): cstring {.importc, libgtk3.}
proc gtk_button_set_label*(button: pointer, label: cstring) {.importc, libgtk3.}

proc gtk_check_button_new*(): pointer {.importc, libgtk3.}
proc gtk_toggle_button_set_active*(toggle_button: pointer, is_active: bool) {.importc, libgtk3.}
proc gtk_toggle_button_get_active*(toggle_button: pointer): bool {.importc, libgtk3.}

proc gtk_combo_box_text_new*(): pointer {.importc, libgtk3.}
proc gtk_combo_box_get_active*(combo_box: pointer): cint {.importc, libgtk3.}
proc gtk_combo_box_set_active*(combo_box: pointer, index: cint) {.importc, libgtk3.}
proc gtk_combo_box_text_get_active_text*(combo_box: pointer): cstring {.importc, libgtk3.}
proc gtk_combo_box_text_append_text*(combo_box: pointer, text: cstring) {.importc, libgtk3.}
proc gtk_combo_box_text_remove_all*(combo_box: pointer) {.importc, libgtk3.}

proc gtk_entry_new*(): pointer {.importc, libgtk3.}
proc gtk_entry_set_text*(entry: pointer, text: cstring) {.importc, libgtk3.}
proc gtk_entry_get_text*(entry: pointer): cstring {.importc, libgtk3.}
proc gtk_entry_set_width_chars*(entry: pointer, n_chars: cint) {.importc, libgtk3.}
proc gtk_entry_set_placeholder_text*(entry: pointer, text: cstring) {.importc, libgtk3.}
proc gtk_editable_get_selection_bounds*(editable: pointer, start_pos, end_pos: var cint): bool {.importc, libgtk3.}
proc gtk_editable_get_chars*(editable: pointer, start_pos, end_pos: cint): cstring {.importc, libgtk3.}
proc gtk_editable_select_region*(editable: pointer, start_pos, end_pos: cint) {.importc, libgtk3.}
proc gtk_editable_get_position*(editable: pointer): cint {.importc, libgtk3.}
proc gtk_editable_set_position*(editable: pointer, position: cint) {.importc, libgtk3.}
proc gtk_editable_set_editable*(editable: pointer, is_editable: bool) {.importc, libgtk3.}

proc gtk_text_view_new*(): pointer {.importc, libgtk3.}
proc gtk_text_view_set_buffer*(text_view, buffer: pointer) {.importc, libgtk3.}
proc gtk_text_view_get_buffer*(text_view: pointer): pointer {.importc, libgtk3.}
proc gtk_text_view_set_wrap_mode*(text_view: pointer, wrap_mode: cint) {.importc, libgtk3.}
proc gtk_text_view_set_left_margin*(text_view: pointer, margin: cint) {.importc, libgtk3.}
proc gtk_text_view_set_right_margin*(text_view: pointer, margin: cint) {.importc, libgtk3.}
proc gtk_text_view_set_top_margin*(text_view: pointer, margin: cint) {.importc, libgtk3.}
proc gtk_text_view_set_bottom_margin*(text_view: pointer, margin: cint) {.importc, libgtk3.}
proc gtk_text_view_scroll_to_iter*(text_view: pointer, iter: var GtkTextIter, within_margin: cdouble, use_align: bool, xalign, yalign: cdouble) {.importc, libgtk3.}
# proc gtk_text_view_scroll_to_mark*(text_view, mark: pointer, within_margin: cdouble, use_align: bool, xalign, yalign: cdouble) {.importc, libgtk3.}
# proc gtk_text_view_place_cursor_onscreen*(text_view: pointer): bool {.importc, libgtk3.}
proc gtk_text_view_set_editable*(text_view: pointer, setting: bool) {.importc, libgtk3.}

# proc gtk_text_buffer_new*(table: pointer): pointer {.importc, libgtk3.}
proc gtk_text_buffer_set_text*(text_buffer: pointer, text: cstring, len: cint) {.importc, libgtk3.}
proc gtk_text_buffer_get_text*(text_buffer: pointer, start, `end`: var GtkTextIter, include_hidden_chars: bool): cstring {.importc, libgtk3.}
proc gtk_text_buffer_get_start_iter*(text_buffer: pointer, iter: var GtkTextIter) {.importc, libgtk3.}
proc gtk_text_buffer_get_end_iter*(text_buffer: pointer, iter: var GtkTextIter) {.importc, libgtk3.}
# proc gtk_text_buffer_add_mark*(buffer, mark: pointer, where: var GtkTextIter) {.importc, libgtk3.}
proc gtk_text_buffer_get_insert*(buffer: pointer): pointer {.importc, libgtk3.}
# proc gtk_text_buffer_get_iter_at_line*(buffer: pointer, iter: var GtkTextIter, line_number: cint) {.importc, libgtk3.}
proc gtk_text_buffer_insert*(buffer: pointer, iter: var GtkTextIter, text: cstring, len: cint) {.importc, libgtk3.}
proc gtk_text_buffer_get_selection_bounds*(buffer: pointer, start, `end`: var GtkTextIter): bool {.importc, libgtk3.}
proc gtk_text_buffer_select_range*(buffer: pointer, ins, bound: var GtkTextIter) {.importc, libgtk3.}
proc gtk_text_buffer_get_iter_at_offset*(buffer: pointer, iter: var GtkTextIter, char_offset: cint) {.importc, libgtk3.}
proc gtk_text_buffer_get_iter_at_mark*(buffer: pointer, iter: var GtkTextIter, mark: pointer) {.importc, libgtk3.}
proc gtk_text_buffer_create_tag*(buffer: pointer, tag_name, property_name, value: cstring, terminator: pointer): pointer {.importc, libgtk3.}
proc gtk_text_buffer_insert_with_tags_by_name*(buffer: pointer, iter: var GtkTextIter, text: cstring, len: cint, first_tag_name: cstring, terminator: pointer) {.importc, libgtk3.}

proc gtk_text_iter_get_offset*(iter: var GtkTextIter): cint {.importc, libgtk3.}
# proc gtk_text_mark_new*(name: cstring, left_gravity: bool): pointer {.importc, libgtk3.}

proc gtk_scrolled_window_new*(hadjustment, vadjustment: pointer): pointer {.importc, libgtk3.}
proc gtk_scrolled_window_set_policy*(scrolled_window: pointer, hscrollbar_policy, vscrollbar_policy: cint) {.importc, libgtk3.}
proc gtk_scrolled_window_get_hscrollbar*(scrolled_window: pointer): pointer {.importc, libgtk3.}
proc gtk_scrolled_window_get_vscrollbar*(scrolled_window: pointer): pointer {.importc, libgtk3.}
proc gtk_scrolled_window_get_hadjustment*(scrolled_window: pointer): pointer {.importc, libgtk3.}
proc gtk_scrolled_window_get_vadjustment*(scrolled_window: pointer): pointer {.importc, libgtk3.}
# proc gtk_scrolled_window_get_max_content_width*(scrolled_window: pointer): cint {.importc, libgtk3.}
# proc gtk_scrolled_window_get_min_content_width*(scrolled_window: pointer): cint {.importc, libgtk3.}
# proc gtk_scrolled_window_set_overlay_scrolling*(scrolled_window: pointer, overlay_scrolling: bool) {.importc, libgtk3.}

proc gtk_frame_new*(label: cstring): pointer {.importc, libgtk3.}
proc gtk_frame_set_label*(frame: pointer, label: cstring) {.importc, libgtk3.}
proc gtk_frame_get_label_widget*(frame: pointer): pointer {.importc, libgtk3.}

proc gtk_drawing_area_new*(): pointer {.importc, libgtk3.}

proc gtk_adjustment_get_value*(adjustment: pointer): cdouble {.importc, libgtk3.}
proc gtk_adjustment_set_value*(adjustment: pointer, value: cdouble) {.importc, libgtk3.}
proc gtk_adjustment_set_upper*(adjustment: pointer, upper: cdouble) {.importc, libgtk3.}
proc gtk_adjustment_get_upper*(adjustment: pointer): cdouble {.importc, libgtk3.}
proc gtk_adjustment_set_page_size*(adjustment: pointer, page_size: cdouble) {.importc, libgtk3.}
proc gtk_adjustment_get_page_size*(adjustment: pointer): cdouble {.importc, libgtk3.}

proc gtk_drag_dest_set*(widget: pointer, flags: cint, targets: pointer, n_targets: cint, actions: cint) {.importc, libgtk3.}

proc gdk_keyval_to_unicode*(keyval: cint): cint {.importc, libgtk3.}

proc gdk_screen_get_default*(): pointer {.importc, libgtk3.}
proc gdk_screen_get_primary_monitor*(screen: pointer): cint {.importc, libgtk3.}
# proc gdk_screen_get_width*(screen: pointer): cint {.importc, libgtk3.}
# proc gdk_screen_get_height*(screen: pointer): cint {.importc, libgtk3.}
proc gdk_screen_get_monitor_workarea*(screen: pointer, monitor_num: cint, dest: var GdkRectangle) {.importc, libgtk3.}

proc gtk_style_context_get_padding*(context: pointer, state: cint, padding: var GtkBorder) {.importc, libgtk3.}
proc gtk_style_context_get_background_color*(context: pointer, state: cint, color: var GdkRGBA) {.importc, libgtk3.}
proc gtk_style_context_get_color*(context: pointer, state: cint, color: var GdkRGBA) {.importc, libgtk3.}
# proc gtk_style_context_get_font*(context: pointer, state: cint): pointer {.importc, libgtk3.}

proc gtk_border_new*(): pointer {.importc, libgtk3.}

proc gdk_threads_add_idle*(function, data: pointer): cint {.importc, libgtk3.}

proc gtk_scrollbar_new*(orientation: cint, adjustment: pointer): pointer {.importc, libgtk3.}

proc gtk_adjustment_new*(value, lower, upper, step_increment, page_increment, page_size: cdouble): pointer {.importc, libgtk3.}

# proc gtk_selection_data_get_length*(selection_data: pointer): cint {.importc, libgtk3.}
# proc gtk_selection_data_get_text*(selection_data: pointer): cstring {.importc, libgtk3.}

proc gtk_selection_data_get_uris*(selection_data: pointer): ptr cstring {.importc, libgtk3.}
proc g_filename_from_uri*(uri: pointer): cstring {.importc, libgtk3.}

proc gtk_clipboard_get*(selection: pointer): pointer {.importc, libgtk3.}
proc gtk_clipboard_set_text*(clipboard: pointer, text: cstring, len: cint) {.importc, libgtk3.}
proc gtk_clipboard_request_text*(clipboard, callback, user_data: pointer) {.importc, libgtk3.}
proc gtk_clipboard_store*(clipboard: pointer) {.importc, libgtk3.}

proc gtk_accelerator_get_default_mod_mask*(): cint {.importc, libgtk3.}

proc gtk_im_multicontext_new*(): pointer {.importc, libgtk3.}
proc gtk_im_context_filter_keypress*(context: pointer, event: var GdkEventKey): bool {.importc, libgtk3.}


# ----------------------------------------------------------------------------------------
#                                   Drawing Related Procs
# ----------------------------------------------------------------------------------------

proc gtk_widget_create_pango_layout*(widget: pointer, text: cstring): pointer {.importc, libgtk3.}
proc gdk_cairo_set_source_rgba*(cr: pointer, rgba: var GdkRGBA) {.importc, libgtk3.}
proc gdk_cairo_surface_create_from_pixbuf*(pixbuf: pointer, scale: cint, for_window: pointer): pointer {.importc, libgtk3.}
proc gdk_pixbuf_new_from_file*(filename: cstring, error: pointer): pointer {.importc, libgtk3.}
proc gdk_pixbuf_save*(pixbuf: pointer, filename, `type`: cstring, error: pointer, param5, param6, param7: cstring): bool {.importc, libgtk3.}
proc gdk_pixbuf_get_from_surface*(surface: pointer, src_x, src_y, width, height: cint): pointer {.importc, libgtk3.}
proc gdk_pixbuf_apply_embedded_orientation*(src: pointer): pointer {.importc, libgtk3.}
# proc gdk_pixmap_create_from_data*(drawable, data: pointer, width, height, depth: cint, fg, bg: var GdkRGBA): pointer {.importc, libgtk3.}

proc cairo_image_surface_create*(format: cint, width, height: cint): pointer {.importc, libgtk3.}
# proc cairo_image_surface_create_for_data*(data: pointer, format: cairo_format_t, width, height, stride: cint): pointer {.importc, libgtk3.}
proc cairo_image_surface_get_width*(surface: pointer): cint {.importc, libgtk3.}
proc cairo_image_surface_get_height*(surface: pointer): cint {.importc, libgtk3.}
proc cairo_image_surface_get_stride*(surface: pointer): cint {.importc, libgtk3.}
proc cairo_image_surface_get_data*(surface: pointer): ptr UncheckedArray[byte] {.importc, libgtk3.}
proc cairo_surface_flush*(surface: pointer) {.importc, libgtk3.}
proc cairo_surface_mark_dirty*(surface: pointer) {.importc, libgtk3.}
proc cairo_surface_destroy*(surface: pointer) {.importc, libgtk3.}

# proc cairo_format_stride_for_width*(format: cairo_format_t, width: cint): cint {.importc, libgtk3.}

proc cairo_create*(target: pointer): pointer {.importc, libgtk3.}
proc cairo_destroy*(cr: pointer) {.importc, libgtk3.}
proc cairo_get_target*(cr: pointer): pointer {.importc, libgtk3.}
proc cairo_set_source_rgb*(cr: pointer, red, green, blue: cdouble) {.importc, libgtk3.}
proc cairo_set_source_surface*(cr, surface: pointer, x, y: cdouble) {.importc, libgtk3.}
proc cairo_get_source*(cr: pointer): pointer {.importc, libgtk3.}
proc cairo_pattern_set_filter*(pattern: pointer, filter: cint) {.importc, libgtk3.}
proc cairo_fill*(cr: pointer) {.importc, libgtk3.}
proc cairo_stroke*(cr: pointer) {.importc, libgtk3.}
proc cairo_rectangle*(cr: pointer, x, y, width, height: cdouble) {.importc, libgtk3.}
proc cairo_arc*(cr: pointer, xc, yc, radius, angle1, angle2: cdouble) {.importc, libgtk3.}
proc cairo_line_to*(cr: pointer, x, y: cdouble) {.importc, libgtk3.}
proc cairo_move_to*(cr: pointer, x, y: cdouble) {.importc, libgtk3.}
proc cairo_set_line_width*(cr: pointer, width: cdouble) {.importc, libgtk3.}
# proc cairo_image_surface_create_from_png*(filename: cstring): pointer {.importc, libgtk3.}
proc cairo_paint*(cr: pointer) {.importc, libgtk3.}
proc cairo_scale*(cr: pointer, x, y: cdouble) {.importc, libgtk3.}
proc cairo_translate*(cr: pointer, tx, ty: cdouble) {.importc, libgtk3.}
# proc cairo_set_antialias*(cr: pointer, antialias: cint) {.importc, libgtk3.}
proc cairo_save*(cr: pointer) {.importc, libgtk3.}
proc cairo_restore*(cr: pointer) {.importc, libgtk3.}

proc pango_cairo_show_layout*(cr, layout: pointer) {.importc, libgtk3.}
proc pango_cairo_create_layout*(cr: pointer): pointer {.importc, libgtk3.}
proc pango_layout_set_text*(layout: pointer, text: cstring, length: cint) {.importc, libgtk3.}
proc pango_layout_get_pixel_size*(layout: pointer, width, height: var cint) {.importc, libgtk3.}
proc pango_layout_set_font_description*(layout, desc: pointer) {.importc, libgtk3.}
proc pango_font_description_new*(): pointer {.importc, libgtk3.}
proc pango_font_description_free*(desc: pointer) {.importc, libgtk3.}
proc pango_font_description_set_family*(desc: pointer, family: cstring) {.importc, libgtk3.}
proc pango_font_description_set_size*(desc: pointer, size: cint) {.importc, libgtk3.}
proc pango_font_description_set_weight*(desc: pointer, weight: cint) {.importc, libgtk3.}
# proc pango_font_description_get_size*(desc: pointer): cint {.importc, libgtk3.}
# proc pango_layout_set_markup*(layout: pointer, markup: cstring, length: cint) {.importc, libgtk3.}
# proc pango_layout_new*(context: pointer): pointer {.importc, libgtk3.}
