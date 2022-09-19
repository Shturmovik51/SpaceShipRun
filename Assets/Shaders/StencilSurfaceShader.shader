Shader "Custom/StencilSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Radius("Radius", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"
            "RenderType"="Opaque"
        }        
               
        Stencil
        {
            Ref 10
            Comp NotEqual
        }

        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows BlinnPhong alpha Lambert vertex:vert       
        #pragma target 3.0

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Radius;
        sampler2D _MainTex;                

        //UNITY_INSTANCING_BUFFER_START(Props)      
        //UNITY_INSTANCING_BUFFER_END(Props)

        struct Input
        {
            float2 uv_MainTex;
        };
        
        void vert (inout appdata_full v) 
        {
            v.vertex.xyz += v.normal * _Radius;            
            v.vertex.y = 0;
            v.texcoord.x += _Time.x;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            
            o.Albedo = c.rgb;            
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
