#version 330 core
out vec4 FragColor;

in vec3 ourColor;
in vec2 TexCoord;

// texture sampler
uniform sampler2D texture1;
uniform sampler2D texture2;
// 通过键盘监听事件来设置可见度
uniform float mixValue;

void main()
{
	FragColor = mix(texture(texture1, TexCoord), 
	                texture(texture2, TexCoord), mixValue);
}