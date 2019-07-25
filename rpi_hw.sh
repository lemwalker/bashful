#!/bin/bash

function error { 2>&1  echo -e "$1";}

if ! which vcgencmd >/dev/null 2>&1; then
    error "vcgencmd not found. $0 will not run"
    exit 1
fi

function vcmd {
    if [[ -z "$1" ]]; then
        return
    fi
    # TODO: make sure $1 is a valid argument

    # TODO: check if $2 is required based on $1

    vcgencmd "$1" "$2"

}
function vconfig {
    [[ -z "$1" ]] && return
    # parse the result
    result=$(vcmd get_config "$1")

    if [[ "$result" =~ ^$a=(.+)$ ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        echo "$result"
    fi
}


clock_args=(
    'arm'
    'core'
    'h264'
    'isp'
    'v3d'
    'uart'
    'pwm'
    'emmc'
    'pixel'
    'vec'
    'hdmi'
    'dpi'
)

#printf "\nclocks:\n"
#for a in "${clock_args[@]}"; do
#    printf "%s\t%s\n" "$a" "$(vcgencmd measure_clock $a)"
#done

volt_args=(
    'core'
    'sdram_c'
    'sdram_i'
    'sdram_p'
)

#printf "\nvolts:\n"
#for a in "${volt_args[@]}"; do
#    printf "%s\t%s\n" "$a" "$(vcgencmd measure_volts $a)"
#done

#vcgencmd get_config int>~/vcgen_ints.txt
printf "config\n\n"

config_args=(
    'arm_freq'
    'audio_pwm_mode'
    'config_hdmi_boost'
    'core_freq'
    'core_freq_min'
    'disable_commandline_tags'
    'disable_l2cache'
    'disable_splash'
    'display_hdmi_rotate'
    'display_lcd_rotate'
    'enable_gic'
    'force_eeprom_read'
    'force_pwm_open'
    'framebuffer_ignore_alpha'
    'framebuffer_swap'
    'gpu_freq'
    'gpu_freq_min'
    'init_uart_clock'
'lcd_framerate'
    'mask_gpu_interrupt0'
    'mask_gpu_interrupt1'
    'max_framebuffers'
    'pause_burst_frames'
    'program_serial_random'
    'second_boot'
)
#'hdmi_force_cec_address:0'
#'hdmi_force_cec_address:1'
#'hdmi_force_hotplug:0'
#'hdmi_pixel_freq_limit:0'
#'hdmi_pixel_freq_limit:1'

error "\n\nconfig arguments:\n"
for a in "${config_args[@]}"; do
    printf "%-24s %32s\n" "$a" "$(vconfig $a)"
done

error "\nsingle commands...\n"
single_cmds=(
    'get_lcd_info'
    'get_camera'
    'measure_temp'
    'measure_volts'
)

#printf "%30s\n" "${single_cmds[@]}"
for c in "${single_cmds[@]}"; do
    printf "%-24s %32s\n" "$c" "$(vcmd $c)"
done

error  "\n\n\nget_config int:\n"
vconfig int | column -t -s = | sort



# get_config      get_config [config|int|str]
# get_lcd_info    1920 1080 24
# get_camera      supported=0 detected=0
# get_hvs_asserts hvs_asserts=0
# get_rsts        get_rsts=1034
# get_throttled   throttled=0x0
# measure_temp    temp=43.0'C
# measure_volts   volt=0.8455V
# 
# read_ring_osc	read_ring_osc(2)=2.394MHz (@0.8455V) (43.0'C)
# get_mem         error=2 error_msg="Invalid arguments"
# measure_clock   error=2 error_msg="Invalid arguments"
# 

