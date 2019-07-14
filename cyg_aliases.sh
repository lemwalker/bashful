# Set up aliases for common Win locations
if [[ -d "/mnt/c/users/Lem" ]]; then
    export WINHOME="/mnt/c/users/Lem"
    if [[ -d "${WINHOME}/Documents" ]]; then export MYDOCS="${WINHOME}/Documents"; fi
    if [[ -d "${WINHOME}/Desktop" ]]; then export DESK="${WINHOME}/Desktop"; fi

fi
[[ -d "/mnt/c/SpeedRun" ]] && export SPEED="/mnt/c/SpeedRun"

