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

void main(){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    vec4 color = vec4(1.);

    float rad1 = 0.;
    
    // Beating circle
    //rad1 = sin(u_time) * 0.05 + 0.2;

    // Beating blob / water
    //rad1 = sin(u_time) * 0.05 + 0.2 + noise(st * 100.) * 0.1;

    // Beating particles
    //rad1 = 0.2 + noise(st * 100.) * 0.2 + noise(vec2(u_time)) * 0.1;

    // Beating / random blob
    //rad1 = 0.1 + noise(st * 15.) * 0.2 + noise(vec2(u_time * 0.1)) * 0.2 * sin(u_time);
    
    // ??
    //rad1 = noise2D(st * 100.) * noise(vec2(u_time)) ;

    // color *= circle(st - vec2(.5),rad1,.0005);


    color = vec4(0.);
    vec2 pos = st - vec2(.5);
    float r = length(st - vec2(.5));
    float a = atan(pos.y,pos.x);

    rad1 = 0.1 + noise(st.x) * 0.2 + noise(st.y) * 0.2;

    rad1 = 0.3 + 0.01 * sin(15.*a + noise(30. * st.x + 2. * u_time)) * sin(TWO_PI * noise( 0.1 * u_time));
    
    // flash / waves effect
    //float rad2 = 0.01 * sin(15.*a + noise(30. * st.x + 2. * u_time)) * sin(TWO_PI * noise( 0.1 * u_time));

    //float rad2 = 0.3 * (sin(1.*a + noise(30. * st.x + 2. * u_time))+1.1);
    //float rad2 = 0.3 + abs(.1 * noise(20. * a) + .1 * noise(st * u_time * 0.5));
    //rad2 = rad2 * .5 + abs(.5 * (0.3 + .1 * noise( 40. * a )));

    //color += circle(pos,rad1,0.001);
    //color += circle(pos,rad2,0.001);

    rad1 = 0.3 + 0.01 * sin(15.*a + noise(30. * st.x + 2. * u_time)) * sin(TWO_PI * noise( 0.1 * u_time));
    color += circle(pos,rad1,0.001);

    float rad2 = 0.3 + 0.02 * cos(15.*a + noise(12. * st.y - 3. * u_time)) ;
    color += circle(pos,rad2,0.001);

    gl_FragColor = color;
}
