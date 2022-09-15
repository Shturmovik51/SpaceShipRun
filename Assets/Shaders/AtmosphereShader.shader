Shader "Custom/AtmosphereShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _AlphaScale ("Alpha Scale", Range(0, 1)) = 1
        _Radius("Radius", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }       

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
                       
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;            
            fixed _AlphaScale;
            float _Radius;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };


            v2f vert (a2v v)
            {       
                v2f o;

                v.vertex.xyz += v.normal * _Radius;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {  
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldPos = normalize(i.worldPos);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos)); 
                fixed4 texColor = tex2D(_MainTex, i.uv); 
                fixed3 albedo =  texColor.rgb * _Color.rgb; 
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo; 
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir)); 
                return fixed4(ambient + diffuse, texColor.a * _AlphaScale);
            }
            ENDCG
        }
    }
}
