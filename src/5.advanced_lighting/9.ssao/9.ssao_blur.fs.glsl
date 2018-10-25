#version 330 core
out float FragColor;

in vec2 TexCoords;

uniform sampler2D ssaoInput;

// 由于平铺的随机向量纹理保持了一致的随机性，我们可以使用这一性质来创建一个简单的模糊着色器
void main() 
{
    vec2 texelSize = 1.0 / vec2(textureSize(ssaoInput, 0));
    float result = 0.0;
    // 这里我们遍历了周围在-2.0和2.0之间的SSAO纹理单元(Texel)，采样与噪声纹理维度相同数量的SSAO纹理
    // 我们通过使用返回vec2纹理维度的textureSize，根据纹理单元的真实大小偏移了每一个纹理坐标
    for (int x = -2; x < 2; ++x) 
    {
        for (int y = -2; y < 2; ++y) 
        {
            vec2 offset = vec2(float(x), float(y)) * texelSize;
            result += texture(ssaoInput, TexCoords + offset).r;
        }
    }
    FragColor = result / (4.0 * 4.0);
}  