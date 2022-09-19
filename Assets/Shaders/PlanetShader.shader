Shader "Custom/PlanetShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Emission("Emission", Color) = (1,1,1,1)
		_Height("Height", Range(-1,1)) = 0
		_Seed("Seed", Range(0,10000)) = 10
		_ColorMinHeight ("ColorMinHeight", Color) = (0.1, 0.3, 0.5, 1)
		_ColorMidlHeight ("ColorMidlHeight", Color) = (0.1, 0.6, 0.3, 1)
		_ColorMaxHeight ("ColorMaxHeight", Color) = (0.6, 0.3, 0.3, 1)
		_FirstStepDistortion ("FirstStepDistortion", Range(0, 0.45)) = 0.4
		_SecondStepDistortion ("FirstStepDistortion", Range(0.45, 1)) = 0.7
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert noforwardadd noshadow vertex:vert
		#pragma target 3.0
		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
			float4 color: COLOR;
		};

		fixed4 _Color;
		fixed4 _ColorMinHeight;
		fixed4 _ColorMidlHeight;
		fixed4 _ColorMaxHeight;
		float4 _Emission;
		float _Height;
		float _Seed;
		float _FirstStepDistortion;
		float _SecondStepDistortion;

		float hash(float2 st) 
		{
			return frac(sin(dot(st.xy, float2(12.9898, 78.233))) * 43758.5453123);
		}
		
		float noise(float2 p, float size)
		{
			float result = 0;
			p *= size;
			float2 i = floor(p + _Seed);
			float2 f = frac(p + _Seed / 739);
			float2 e = float2(0, 1);
			float z0 = hash((i + e.xx) % size);
			float z1 = hash((i + e.yx) % size);
			float z2 = hash((i + e.xy) % size);
			float z3 = hash((i + e.yy) % size);
			float2 u = smoothstep(0, 1, f);
			result = lerp(z0, z1, u.x) + (z2 - z0) * u.y * (1.0 - u.x) + (z3 - z1) * u.x * u.y;
			return result;
		}

		void vert(inout appdata_full v)
		{
			float height = noise(v.texcoord, 5) * 0.75 + noise(v.texcoord, 30) * 0.125 + noise(v.texcoord, 50) * 0.125;
			v.color.r = height + _Height;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 color = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float height = IN.color.r;
			if (height < _FirstStepDistortion)
			{
				color *= _ColorMinHeight;
			}
			else if (height > _FirstStepDistortion && height < _SecondStepDistortion)
			{
				color *= _ColorMidlHeight;
			}
			else
			{
				color *= _ColorMaxHeight;
			}
			o.Albedo = color.rgb;
			o.Emission = _Emission.xyz;
			o.Alpha = color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}