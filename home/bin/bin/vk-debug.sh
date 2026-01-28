#!/usr/bin/env bash

# Mesa Vulkan Overlay Debug Wrapper
# GPU: AMD Radeon 740M (RADV PHOENIX2)
# WM: Hyprland (Wayland)

export VK_INSTANCE_LAYERS=VK_LAYER_MESA_overlay,VK_LAYER_KHRONOS_validation 

export VK_LAYER_MESA_OVERLAY_STATS=fps,frame-time,submit,draw,pipeline-graphics
export VK_LAYER_MESA_OVERLAY_POSITION=top-right
export VK_LAYER_MESA_OVERLAY_SCALE=1.25

# Optional: reduce visual spam
export VK_LAYER_MESA_OVERLAY_SUBMIT_MODE=per-frame

export VK_INSTANCE_LAYERS=VK_LAYER_MESA_overlay:VK_LAYER_MESA_device_select
export MESA_VK_DEVICE_SELECT=integrated

# export VK_INSTANCE_LAYERS=VK_LAYER_KHRONOS_validation 
export VK_VALIDATION_FEATURES=VK_VALIDATION_FEATURE_ENABLE_BEST_PRACTICES_EXT 
# MESA_VK_WSI_PRESENT_MODE=fifo \



exec "$@"
