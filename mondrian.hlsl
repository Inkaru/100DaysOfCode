#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float[] vl = []

float hline(in float x, in float width){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    return 1. - (step(x + width * .5,st.x) + step(-x + width * .5,-st.x));
}

float vline(in float y, in float width){
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    return 1. - (step(y + width * .5,st.y) + step(-y + width * .5,-st.y));
}

// x, y center of the rectangle
float rect(in float x, in float y, in float width, in float height){
    return hline(x,width) * vline(y,height);
}

void main(){
    
    vec3 color = vec3(1.);
    
    float redRect = rect(0.,0.,0.576,1.244);
    redRect += rect(0.672,0.656,0.176,0.076);
    
    float yellowRect = rect(0.128,0.976,0.320,0.204);
    yellowRect += rect(0.888,0.784,0.288,0.19);
    
    float blueRect = rect(0.440,0.480,0.296,0.268);
    blueRect += rect(0.67,-0.032,0.152,0.244);
    
    float lines = hline(0.296,0.02);
    lines += rect(0.592,0.304,0.02,1.148);
    lines += hline(0.752,0.02);
    lines += rect(0.528,0.336,0.468,0.02);
    lines += rect(0.816,0.088,0.468,0.02);
    
    lines += vline(0.872,0.02);
    lines += vline(0.616,0.02);
    lines += rect(0.864,0.688,0.564,0.02);
    
    color = mix(color,vec3(1.,0.,0.),redRect);
    color = mix(color,vec3(1.000,0.952,0.126),yellowRect);
    color = mix(color,vec3(0.049,0.002,0.880),blueRect);
    color = mix(color,vec3(0.,0.,0.),lines);
    gl_FragColor = vec4(color,1.0);
}