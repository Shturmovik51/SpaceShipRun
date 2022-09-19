Shader "Custom/StencilHole"
{
    Properties
    { 
        _Radius("Radius", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags 
        {  
            "RenderType" = "Transparent"
            "Queue" = "Geometry-1" 
            "ForceNoShadowCasting" = "True"
        }
        
        Stencil
        {
            Ref 10
            Comp Always
            Pass Replace
        }

        CGPROGRAM
       
        #pragma surface surf NoLighting alpha Lambert vertex:vert       
        #pragma target 3.0

        float _Radius;

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert (inout appdata_full v) 
        {
            v.vertex.xyz += v.normal * _Radius;            
            v.vertex.y = 0;
        }
            
        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }
        
        void surf (Input IN, inout SurfaceOutput  o) {}

        ENDCG
    }
    FallBack "Diffuse"
}
