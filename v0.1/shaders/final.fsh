#version 120

varying vec4 texcoord;

uniform sampler2D gcolor;

// RADIUS of our vignette, where 0.5 results in a circle fitting the screen
// 晕影半径
const float RADIUS = 0.65f;

// softness of our vignette, between 0.0 and RADIUS
// 晕影过渡区域大小
const float SOFTNESS = 0.35f;

// grayscale weights
// 彩色转灰色标准权重
const vec3 GRAY = vec3(0.299, 0.587, 0.114);

// sepia colour, adjust to taste
// const vec3 SEPIA = vec3(1.2, 1.0, 0.8); 

// 强化绿色弱化蓝色
const vec3 FRESH = vec3(0.95, 1.0, 0.8); 

// 增加整体亮度
const float BRIGHTNESS = 1.4f;

// 过度曝光
const float OVEREXPOSED = 1.3f;

// 曝光buzu
const float UNDEREXPOSED = 1.8f;

// 视野晕影效果
void vignette (inout vec3 color) {
    float dist = distance(texcoord.st, vec2(0.5f));

    float vign = smoothstep(RADIUS, RADIUS - SOFTNESS, dist);

    // //apply the vignette with opacity
    color.rgb = mix(color.rgb, color.rgb * vign, 0.55f);
}

void grayscale (inout vec3 color) {
    float gray = dot(color.rgb, GRAY);
    color = mix(color.rgb, color.rgb * gray, 0.5f);
}

void fresh (inout vec3 color) {
    color = color * FRESH;
}

// 使亮的地方更亮，暗的地方更暗
void convertToHRD (inout vec3 color) {
    vec3 overExposed = color * OVEREXPOSED;
    vec3 underExposed = color / UNDEREXPOSED;

    color = mix(underExposed, overExposed, color);
}

void main () {
    vec3 color = texture2D(gcolor, texcoord.st).rgb;

    vignette(color);
    // grayscale(color);
    fresh(color);
    convertToHRD(color);

    gl_FragData[0] = vec4(color.rgb * BRIGHTNESS, 1.0f);
}