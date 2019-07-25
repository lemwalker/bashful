#!/bin/bash

function error { 2>&1  echo -e "$1";}

if ! which vcgencmd >/dev/null 2>&1; then
    error "vcgencmd not found. $0 will not run"
    exit 1
fi

function vcmd {
    if [[ -z "$1" || -z "$2" ]]; then
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


for a in "${config_args[@]}"; do
    #result=$(vcgencmd get_config $a)
    #result=$(vconfig "$a")
    printf "%s\t%s\n" "$a" "$(vconfig $a)"
#    if [[ "$result" =~ ^$a=(.+)$ ]]; then
#        val="${BASH_REMATCH[1]}"
#        echo "$a $val"
#    else error "## no match for $result"
#    fi
done



# vcgencmd get_config str



