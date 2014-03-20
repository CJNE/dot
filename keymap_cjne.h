static const uint8_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  KEYMAP( // Layer 0
    ESC, 1, 2, 3, 4, 5, EQL, TAB, Q, W, E, R, T, LBRC, LCTL, A, S, D, F, G, LSFT, Z, X, C, V, B, LALT, CAPS, FN3, LALT, FN1, LGUI, MPLY, MUTE, VOLU, BSPC, DEL, VOLD, GRV, 6, 7, 8, 9, 0, MINS, RBRC, Y, U, I, O, P, EQL, H, J, K, L, SCLN, QUOT, BSLS, N, M, COMM, DOT, SLSH, RSFT, LALT, FN1, LBRC, RBRC, LGUI, ESC, FN2, FN1, INS, ENT, SPC),
  KEYMAP( // Layer 1
    TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, Q, W, D, F, K, TRNS, TRNS, A, S, E, T, G, TRNS, Z, X, C, V, B, TRNS, TRNS, TRNS, TRNS, FN5, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, J, U, R, L, SCLN, TRNS, Y, N, I, O, H, TRNS, TRNS, P, M, COMM, DOT, SLSH, TRNS, TRNS, FN5, TRNS, TRNS, TRNS, TRNS, FN4, TRNS, TRNS, TRNS, TRNS),
  KEYMAP( // Layer 2
    FN0, F1, F2, F3, F4, F5, TRNS, TRNS, EQL, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, FN4, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, F6, F7, F8, F9, F10, GRV, TRNS, FN7, MINS, FN6, BSLS, LBRC, FN11, LEFT, DOWN, UP, RIGHT, FN9, FN10, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS),
  KEYMAP( // Layer 3
    TRNS, NO, NO, NO, NO, PAUS, PSCR, TRNS, WH_L, WH_U, WH_D, WH_R, BTN2, TRNS, TRNS, MS_L, MS_U, MS_D, MS_R, BTN1, TRNS, NO, NO, NO, NO, BTN3, TRNS, TRNS, FN4, TRNS, TRNS, TRNS, FN4, TRNS, TRNS, TRNS, TRNS, TRNS, SLCK, NLCK, PSLS, PAST, PAST, PMNS, BSPC, TRNS, NO, P7, P8, P9, PMNS, BSPC, NO, P4, P5, P6, PPLS, PENT, TRNS, NO, P1, P2, P3, PPLS, PENT, P0, PDOT, SLSH, PENT, PENT, TRNS, TRNS, TRNS, TRNS, TRNS, TRNS)
};
enum function_id {
  TEENSY_KEY,  

};


static const uint16_t PROGMEM fn_actions[] = {
  ACTION_FUNCTION(TEENSY_KEY),
  ACTION_LAYER_MOMENTARY(2),
  ACTION_LAYER_SET(1, ON_PRESS),
  ACTION_LAYER_SET(3, ON_PRESS),
  ACTION_LAYER_SET(0, ON_PRESS),
  ACTION_LAYER_MOMENTARY(1),
  ACTION_MODS_KEY(MOD_LSFT, KC_BSLS),
  ACTION_MODS_KEY(MOD_LSFT, KC_EQL),
  ACTION_MODS_KEY(MOD_LSFT, KC_RBRC),
  ACTION_MODS_KEY(MOD_LALT, KC_SCLN),
  ACTION_MODS_KEY(MOD_LALT, KC_QUOT),
  ACTION_MODS_KEY(MOD_LALT, KC_EQL),
};






void action_function(keyrecord_t *event, uint8_t id, uint8_t opt)
{
    if (id == TEENSY_KEY) {
        clear_keyboard();
        print("\n\nJump to bootloader... ");
        _delay_ms(250);
        bootloader_jump(); // should not return
        print("not supported.\n");
    }
}