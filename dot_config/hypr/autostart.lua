-- Extra autostart processes.
o.exec_on_start(os.getenv("SCRIPTS_DIR") .. "/kbd_backlight.sh restore")
