#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;

mat2 scale(vec2 _scale){
    return mat2(_scale.x,0.0,
                0.0,_scale.y);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float box(in vec2 _st, in vec2 _size){
    _size = vec2(0.5) - _size*0.5;
    vec2 uv = smoothstep(_size,
                        _size+vec2(0.001),
                        _st);
    uv *= smoothstep(_size,
                    _size+vec2(0.001),
                    vec2(1.0)-_st);
    return uv.x*uv.y;
}

float cross(in vec2 _st, float _size){
    return  box(_st, vec2(_size,_size/4.)) +
            box(_st, vec2(_size/4.,_size));
}

float sonar(in vec2 pos,in float radius){
    vec2 p = rotate2d(u_time) * pos;
    float r = length(p)*2.0;
    float a = atan(p.y,p.x);

    float c = 1. - step(radius,r);
    c *= smoothstep(0.,PI,a + PI);
    c *= 1.-step(PI/2.,a+PI);

    return c;
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
    vec4 color = vec4(0.0,0.,0.,1.);

    vec4 darkblue = vec4(0.2667, 0.3176, 1.0, 1.0);

    // Add the shape on the foreground
    color += sonar(st - vec2(.5),.7) * vec4(0.302, 0.9529, 1.0, 1.0);
    color += circle(st - vec2(.5), .2,0.001) * darkblue;
    color += box(st - vec2(0.,.2),vec2(.005,.04)) *  darkblue;
    color += box(st - vec2(0.,-.2),vec2(.005,.04)) *  darkblue;
    color += box(st - vec2(.2,0.),vec2(.04,.005)) *  darkblue;
    color += box(st - vec2(-.2,0.),vec2(.04,.005)) *  darkblue;

    gl_FragColor = color;
}
