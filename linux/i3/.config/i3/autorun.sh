function run {
	if ! pgrep $1; then
		$@ &
	fi
}

run /home/anna/.screenlayout/monitors.sh
run /home/anna/.fehbg
