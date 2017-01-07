#!/bin/sh

DIR=~/3d-fixes
PATH="$DIR:$PATH"

cs=$(ls *cs.txt)
ps=$(ls *ps.txt)
vs=$(ls *vs.txt)

# Filter out all confetti physics compute shaders - these must have identical
# inputs and execute the same instructions on both eyes otherwise physics will
# desync:
cs=$(grep -L Confetti $cs)

ssr_cs=$(grep -l SSPRWMirrorViewProjMatrix $cs)
cs=$(grep -L SSPRWMirrorViewProjMatrix $cs)
asmtool.py --fix-wd2-screen-space-reflections-cs -i -f --only-autofixed $ssr_cs

ssr_ps=$(grep -l 'cbuffer SSR' $ps)
ps=$(grep -L 'cbuffer SSR' $ps)
asmtool.py --fix-wd2-screen-space-reflections -i -f --only-autofixed $ssr_ps

# Sun/moon fog shaders - these need to be moved to infinity:
sun_moon_fog=$(grep -l FillVolumeTexture__VFOutputBuffer4 $cs)
cs=$(grep -L FillVolumeTexture__VFOutputBuffer4 $cs)
asmtool.py --fix-wd2-view-dir-reconstruction -i -f --only-autofixed $sun_moon_fog

# Fog fix alternate 1 (Adjusts all CS fog except sun/moon. Includes density):
fog_shaders=$(grep -l 'cbuffer VolumetricFog' $cs)
cs=$(grep -L 'cbuffer VolumetricFog' $cs)
asmtool.py --fix-wd2-volumetric-fog -i -f --only-autofixed $fog_shaders

# Fog fix alternate 2 (Adjusts all CS & PS fog except sun/moon and density. Seems less accurate in some cases?):
# asmtool.py --fix-wd2-unproject --fix-wd2-camera-pos --fix-wd2-view-dir-reconstruction --fix-wd2-camera-z-axis --fix-wd2-screen-space-reflections --fix-wd2-screen-space-reflections-cs -i -f --only-autofixed $cs

# Apply alternate 1 fog fix only to FV ("Fog Volume" as opposed to "Volumetric
# Fog" o_O ?) pixel shaders:
fv_shaders_ps=$(grep -l 'cbuffer FogVolumeRaymarch' $ps)
ps=$(grep -L 'cbuffer FogVolumeRaymarch' $ps)
asmtool.py --fix-wd2-volumetric-fog -i -f --only-autofixed $fv_shaders_ps


# Glass shaders use CameraPosition twice, but we only want to correct the first
# to fix reflections - the second will mess up sky reflections causing them to
# go out of bounds on the sky texture and show in only one eye.
glass_ps=$(grep -l 'cbuffer MaterialWD2Glass' $ps)
ps=$(grep -L 'cbuffer MaterialWD2Glass' $ps)
asmtool.py --fix-wd2-camera-pos-limit=1 -i -f --only-autofixed $glass_ps


# Lens grit shaders:
asmtool.py --fix-wd2-lens-grit=y2 -i -f --only-autofixed $(grep -l 'LensDirt' $ps)
ps=$(grep -L 'LensDirt' $ps)


# Possible fix for uniform fog that sometimes blankets the City at night? These
# shaders are Ansel exclusive and can accept a projection offset parameter -
# possibly they are designed to work in stereo? Moves the fog to the correct
# depth in Ansel, but creates a box shaped artefact in the sky.
ps_uniform_fog_cube_artefact_ansel=$(grep -l 'VFProjectionOffset.*[0-9]$' *ps.txt)
ps=$(grep -L 'VFProjectionOffset.*[0-9]$' *ps.txt)
asmtool.py --fix-wd2-camera-pos --fix-wd2-view-dir-reconstruction -i -f --only-autofixed $ps_uniform_fog_cube_artefact_ansel
# Based on the shaders that take a VFProjectionOffset in Ansel, we notice they
# write to a UAV and we might be able to assume that other pixel shaders that
# write to the same UAV might require the same pattern. Two of the shaders
# matched in the above pattern write to GIFillLightFog__VFLightOutputBuffer,
# and the third writes to FogVolumes__VFOutputBuffer1:
ps_uniform_fog_cube_artefact1=$(grep -l 'GIFillLightFog__VFLightOutputBuffer' *ps.txt)
ps=$(grep -L 'GIFillLightFog__VFLightOutputBuffer' *ps.txt)
asmtool.py --fix-wd2-camera-pos --fix-wd2-view-dir-reconstruction -i -f --only-autofixed $ps_uniform_fog_cube_artefact1
# FogVolumes__VFOutputBuffer1 shaders had no visible change (not saying they don't, just not in the current weather):
ps_uniform_fog_cube_artefact2=$(grep -l 'FogVolumes__VFOutputBuffer1' *ps.txt)
ps=$(grep -L 'FogVolumes__VFOutputBuffer1' *ps.txt)
asmtool.py --fix-wd2-camera-pos --fix-wd2-view-dir-reconstruction -i -f --only-autofixed $ps_uniform_fog_cube_artefact2


# Apply alternate 2 fog fix to *all* pixel shaders that mention fog (alternate
# 1 fix completely breaks windshield reflections, while this breaks some fog):
fog_shaders_ps=$(grep -l 'cbuffer VolumetricFog' $ps)
#asmtool.py --fix-wd2-unproject --fix-wd2-camera-pos --fix-wd2-view-dir-reconstruction --fix-wd2-camera-z-axis --fix-wd2-screen-space-reflections --fix-wd2-screen-space-reflections-cs -i -f --only-autofixed $fog_shaders_ps


# Move fake interior lights to correct depth:
fake_interiors=$(grep -l '//   float4 FakeInteriorTextureSize;    // Offset:   32 Size:    16$' $vs)
vs=$(grep -L '//   float4 FakeInteriorTextureSize;    // Offset:   32 Size:    16$' $vs)
~/3d-fixes/asmtool.py --fix-wd2-camera-pos-excluding=1 -i -f --only-autofixed $fake_interiors


# Reflections, shadows, etc. Do not force overwrite these as some shaders are
# blacklisted:
asmtool.py --fix-wd2-unproject --fix-wd2-camera-pos -i --only-autofixed $ps
