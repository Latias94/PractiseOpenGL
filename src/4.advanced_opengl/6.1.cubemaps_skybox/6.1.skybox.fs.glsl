#version 330 core
out vec4 FragColor;

// 代表3D纹理坐标的方向向量
in vec3 TexCoords;

// 立方体贴图的纹理采样器，使用 vec3 的 TexCoords 来采样，而不是 vec2
uniform samplerCube skybox;

void main()
{    
    FragColor = texture(skybox, TexCoords);
}