#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;

float random (in float x) {
    return fract(sin(x)*1e4);
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
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

// 1D Noise
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

//  Function from Iñigo Quiles
//  www.iquilezles.org/www/articles/functions/functions.htm
float cubicPulse( float c, float w, float x ){
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec4 color = vec4(0.);

    vec2 pos = st - vec2(.5);
    float r = length(pos);
    float a = atan(pos.y,pos.x);

    float radius = .3 +  0.01 * sin(10.*a);

    radius = .3 + 0.01 * sin(a) / a;
    radius = .3 + 0.01 * floor(3.*sin(50.*a) + 3.);


    float angle = a/PI;

    radius = .3;
    //radius += 0.05 * cubicPulse(.25,.02,angle) * noise(u_time);
    //radius += 0.02 * cubicPulse(.25,1.,angle) * noise(u_time + 100.);

    //radius += 0.05 * cubicPulse(.25,.02,noise(10.*a + u_time)) * noise(u_time);
    
    // 1 spike, varying position + height
    //radius += 0.05 * cubicPulse( 2. * noise(u_time * 0.1) - 1.,.02,angle) * noise(u_time * 0.1 + 100.);

    // 1 spike, varying position + height
    //radius += 0.02 * cubicPulse( 2. * noise(u_time * 0.1) - 1.,.2,angle) * noise(u_time * 0.1 + 100.);

    radius += 0.07 * cubicPulse( 
      2. * noise(u_time * 0.1) - 1.,
      .2,
      2. * noise(10. *a + 2. * sin(u_time * .1)) - 1.) * noise(u_time * 0.1 + 100.);

    
    
    radius += 0.05 * cubicPulse( 
        2. * noise(u_time * 0.01) - 1.,
        1., 
        2. * noise(10. * a + 2. * cos(u_time * .01)) - 1.) * noise(u_time * 0.1 + 100.);

   
    
    radius += 0.02 * cubicPulse(.5,3.,a);

    // +2 / -2 for continuity on left (-PI / +PI)

    color += circle(pos,radius,0.001);
    color += circle(pos,0.3,0.001);
    
    // display only half of the circle
    //color *= door(mod(a + u_time, TWO_PI),0.,PI);

    color = vec4(1.);
    color *= 1. - (step(.292,r) - step(radius,r));

    
    gl_FragColor = color;
}
