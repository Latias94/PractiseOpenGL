#version 330 core
out vec4 FragColor;

float near = 0.1; 
float far = 100.0; 

// 推导过程可以参考 http://hellokenlee.tk/2017/02/24/opengl-z-buffer/
float LinearizeDepth(float depth) 
{
    float z = depth * 2.0 - 1.0; // back to NDC 
    return (2.0 * near * far) / (far + near - z * (far - near));	
}

void main()
{             
    float depth = LinearizeDepth(gl_FragCoord.z) / far; // divide by far to get depth in range [0,1] for visualization purposes
    FragColor = vec4(vec3(depth), 1.0);
//    FragColor = vec4(vec3(gl_FragCoord.z), 1.0); 
}