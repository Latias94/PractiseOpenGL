#version 330 core
out vec4 FragColor;

in VS_OUT {
    vec3 FragPos;
    vec2 TexCoords;
    vec3 TangentLightPos;
    vec3 TangentViewPos;
    vec3 TangentFragPos;
} fs_in;

uniform sampler2D diffuseMap;
uniform sampler2D normalMap;
uniform sampler2D depthMap;

uniform float heightScale;

// 把fragment的纹理坐标作和切线空间中的fragment到观察者的方向向量为输入
// 这个函数返回经位移的纹理坐标
vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir)
{ 
    // 用本来的纹理坐标texCoords从高度贴图中来采样出当前fragment高度H(A)，也就是点A在高度纹理中对应的高度
    float height =  texture(depthMap, texCoords).r;  
    // 然后计算出P¯，x和y元素在切线空间中，viewDir向量除以它的z元素，用fragment的高度对它进行缩放
    // 同时引入一个height_scale的uniform，来进行一些额外的控制，因为视差效果如果没有一个缩放参数通常会过于强烈
    // 我们用P¯减去纹理坐标来获得最终的经过位移纹理坐标
    // 有一个地方需要注意，就是viewDir.xy除以viewDir.z那里，因为viewDir向量是经过了标准化的，viewDir.z会在0.0到1.0之间的某处
    // 当viewDir大致平行于表面时，它的z元素接近于0.0，除法会返回比viewDir垂直于表面的时候更大的P¯向量
    // 所以基本上我们增加了P¯的大小，当以一个角度朝向一个表面相比朝向顶部时它对纹理坐标会进行更大程度的缩放；这回在角上获得更大的真实度
    // 下面是普通的视差贴图的计算
    vec2 p = viewDir.xy / viewDir.z * (height * heightScale);
    // 有些人更喜欢在等式中不使用viewDir.z，因为普通的视差贴图会在角上产生不想要的结果；
    // 这个技术叫做有偏移量限制的视差贴图（Parallax Mapping with Offset Limiting）
//    vec2 p = viewDir.xy * (height * heightScale);
    
    return texCoords - p;        
}

void main()
{           
    // offset texture coordinates with Parallax Mapping
    vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
    vec2 texCoords = fs_in.TexCoords;
    
    texCoords = ParallaxMapping(fs_in.TexCoords,  viewDir);     
    // 在视差贴图的那个平面里你仍然能看到在边上有古怪的失真
    // 原因是在平面的边缘上，纹理坐标超出了0到1的范围进行采样，根据纹理的环绕方式导致了不真实的结果
    // 解决的方法是当它超出默认纹理坐标范围进行采样的时候就丢弃这个fragment  
    // 注意，这个技巧不能在所有类型的表面上都能工作，但是应用于平面上它还是能够是平面看起来真的进行位移了
    if(texCoords.x > 1.0 || texCoords.y > 1.0 || texCoords.x < 0.0 || texCoords.y < 0.0)
        discard;

    // 我们使用这些经位移的纹理坐标进行diffuse和法线贴图的采样
    // obtain normal from normal map
    vec3 normal = texture(normalMap, texCoords).rgb;
    normal = normalize(normal * 2.0 - 1.0);   
   
    // get diffuse color
    vec3 color = texture(diffuseMap, texCoords).rgb;
    // ambient
    vec3 ambient = 0.1 * color;
    // diffuse
    vec3 lightDir = normalize(fs_in.TangentLightPos - fs_in.TangentFragPos);
    float diff = max(dot(lightDir, normal), 0.0);
    // 最后fragment的diffuse颜色和法线向量就正确的对应于表面的经位移的位置上了
    vec3 diffuse = diff * color;
    // specular    
    vec3 reflectDir = reflect(-lightDir, normal);
    vec3 halfwayDir = normalize(lightDir + viewDir);  
    float spec = pow(max(dot(normal, halfwayDir), 0.0), 32.0);

    vec3 specular = vec3(0.2) * spec;
    FragColor = vec4(ambient + diffuse + specular, 1.0);
}