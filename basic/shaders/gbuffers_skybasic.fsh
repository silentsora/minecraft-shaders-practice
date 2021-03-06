#version 120

uniform int fogMode;
varying vec4 color;

const int GL_LINEAR = 9729;
const int GL_EXP = 2048;

void main () {
    gl_FragData[0] = color;

    if (fogMode == GL_LINEAR) {
        gl_FragData[0].rgb = mix(gl_Fog.color.rgb, gl_FragData[0].rgb, clamp((gl_Fog.end - gl_FogFragCoord) / (gl_Fog.end - gl_Fog.start), 0.0, 1.0));
    } else if (fogMode == GL_EXP) {
        gl_FragData[0].rgb = mix(gl_Fog.color.rgb, gl_FragData[0].rgb, clamp(exp(-gl_FogFragCoord * gl_Fog.density), 0.0, 1.0));
    }
}