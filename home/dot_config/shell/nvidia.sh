#!/usr/bin/env sh

export VDPAU_DRIVER=nvidia
export LIBVA_DRIVER_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia

export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json

export WLR_RENDERER=vulkan
export __GL_GSYNC_ALLOWED=0
export __GL_VRR_ALLOWED=0

export WLR_NO_HARDWARE_CURSORS=1

export XWAYLAND_NO_GLAMOR=1

# Firefox temporary VA-API fixes; requires libva-nvidia-driver
export MOZ_DISABLE_RDD_SANDBOX=1
export NVD_BACKEND=direct
