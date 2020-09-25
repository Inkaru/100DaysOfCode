#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random (in float x) {
    return fract(sin(x)*1e4);
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float noise (in float s) {
    float i = floor(s);
    float f = fract(s);

    return mix(random(i), random(i + 1.0), smoothstep(0.,1.,f));
}

float circle(in vec2 pos, float radius, float stroke){
    float r = length(pos);
    float w = stroke / radius;
    float c = step(radius - w,r) - step(radius + w,r);
    c = smoothstep(radius - w, radius, r) - smoothstep(radius, radius + w, r) ;
    return c;
}

float door(in float x, in float min, in float max){
  return step(min,x) - step(max,x);
}

float cubicPulse( float c, float w, float x ){
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;

    vec2 pos = st - vec2(.5);
    float r = length(pos);
    float a = atan(pos.y,pos.x);

    float radius = .3 +  0.01 * sin(10.*a);

    radius = .3 + 0.01 * sin(a) / a;
    radius = .3 + 0.01 * floor(3.*sin(50.*a) + 3.);


    float angle = a/PI;

    radius = .3;

    radius += 0.04 * cubicPulse( 
      2. * noise(u_time * 0.1) - 1.,
      .2,
      2. * noise(10. *a + 2. * sin(u_time * .1)) - 1.) * noise(u_time * 0.1 + 100.);
    
    radius += 0.03 * cubicPulse( 
        2. * noise(u_time * 0.01) - 1.,
        1.5, 
        2. * noise(10. * a + 2. * cos(u_time * .01)) - 1.) * noise(u_time * 0.1 + 100.);
   
    radius += 0.025 * cubicPulse(.5,2.,a);

    vec3 color = vec3(1.);
    color *= 1. - (smoothstep(.29,.29 + 0.01 * noise(st.x * u_time),r) - step(radius,r));
    color += 1. - vec3(smoothstep(.4,0.285,r));
  
    gl_FragColor = vec4(color.xyz,1.);
}
