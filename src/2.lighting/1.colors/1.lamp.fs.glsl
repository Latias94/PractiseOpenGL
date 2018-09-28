#version 330 core

uniform vec3 lightColor;
out vec4 FragColor;

void main()
{
    FragColor = vec4(lightColor, 1.0); // 让光源发射的光和cube接受的光颜色一样.
}