#version 330 core
out vec4 FragColor;

in VS_OUT {
    vec3 FragPos;
    vec3 Normal;
    vec2 TexCoords;
} fs_in;

uniform sampler2D floorTexture;
uniform vec3 lightPos;
uniform vec3 viewPos;
uniform bool blinn;

void main()
{           
    vec3 color = texture(floorTexture, fs_in.TexCoords).rgb;
    // ambient
    vec3 ambient = 0.05 * color;
    // diffuse
    // 通过顶点位置和光的位置计算光的向量（顶点指向光的矢量）
    vec3 lightDir = normalize(lightPos - fs_in.FragPos); 
    // 顶点法线向量
    vec3 normal = normalize(fs_in.Normal);
    // 光方向在法线上的投影 计算漫反射的强度
    float diff = max(dot(lightDir, normal), 0.0);
    vec3 diffuse = diff * color;
    // specular
    // 通过顶点位置和摄像机的位置计算摄像机的向量（顶点指向摄像机的矢量）
    vec3 viewDir = normalize(viewPos - fs_in.FragPos);
    // 计算光照的反射光方向
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = 0.0;
    if(blinn)
    {
        // Binn-Phong 模型
        // Blinn-Phong测量的是法线与半程向量之间的夹角
        // Blinn-Phong模型不再依赖于反射向量，而是采用了所谓的半程向量(Halfway Vector)，即光线与视线夹角一半方向上的一个单位向量
        vec3 halfwayDir = normalize(lightDir + viewDir);  
        // 当半程向量与法线向量越接近时，镜面光分量就越大
        // 镜面光分量的实际计算只不过是对表面法线和半程向量进行一次约束点乘(Clamped Dot Product)
        // 让点乘结果不为负，从而获取它们之间夹角的余弦值，之后我们对这个值取反光度次方
        // 32.0 为 shininess
        spec = pow(max(dot(normal, halfwayDir), 0.0), 32.0);
        // 冯氏模型与Blinn-Phong模型也有一些细微的差别：半程向量与表面法线的夹角通常会小于观察与反射向量的夹角
        // 所以，如果你想获得和冯氏着色类似的效果，就必须在使用Blinn-Phong模型时将镜面反光度设置更高一点。通常我们会选择冯氏着色时反光度分量的2到4倍。
        // 取 32.0 是为了得到和冯氏着色类似的效果
    }
    else
    {
        // Phong
        // 冯氏模型测量的是观察方向与反射向量间的夹角
        // 光的反射光方向
        vec3 reflectDir = reflect(-lightDir, normal);
        spec = pow(max(dot(viewDir, reflectDir), 0.0), 8.0);
    }
    vec3 specular = vec3(0.3) * spec; // assuming bright white light color
    FragColor = vec4(ambient + diffuse + specular, 1.0);
}