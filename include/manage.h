/*
 * vim:ts=4:sw=4:expandtab
 *
 * i3 - an improved tiling window manager
 * © 2009 Michael Stapelberg and contributors (see also: LICENSE)
 *
 * manage.c: Initially managing new windows (or existing ones on restart).
 *
 */
#pragma once

#include <config.h>

#include "data.h"

/**
 * Go through all existing windows (if the window manager is restarted) and
 * manage them
 *
 */
void manage_existing_windows(xcb_window_t root);

/**
 * Set by cmd_split() to override smart_split_target() for the next managed
 * window: HORIZ or VERT means "use this direction instead of the aspect-ratio
 * heuristic"; NO_ORIENTATION means "no override, use smart splitting normally."
 * When smart_splitting is enabled, cmd_split() sets this instead of calling
 * tree_split(), so the manual split command doesn't create unnecessary nesting.
 *
 */
extern orientation_t smart_split_override;

/**
 * Restores the geometry of each window by reparenting it to the root window
 * at the position of its frame.
 *
 * This is to be called *only* before exiting/restarting i3 because of evil
 * side-effects which are to be expected when continuing to run i3.
 *
 */
void restore_geometry(void);

/**
 * Do some sanity checks and then reparent the window.
 *
 */
void manage_window(xcb_window_t window,
                   xcb_get_window_attributes_cookie_t cookie,
                   bool needs_to_be_mapped);

/**
 * Remanages a window: performs a swallow check and runs assignments.
 * Returns con for the window regardless if it updated.
 *
 */
Con *remanage_window(Con *con);
