Shader "Custom/ScreenEffect/Blur" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		LOD 200
		
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;

			static float4 samples[4] = { 
				-1.0, 0.0, 0, 0.25,
				1.0, 0.0, 0, 0.25,
				0.0, 1.0, 0, 0.25,
				0.0, -1.0, 0, 0.25 };

			struct v2f {
				float4 pos : POSITION; 
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata_img v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			fixed4 frag(v2f IN) : COLOR
			{	
				fixed4 col = tex2D(_MainTex, IN.uv + float2(samples[0].x * _MainTex_TexelSize.x, samples[0].y * _MainTex_TexelSize.y)) * samples[0].w;
				col += tex2D(_MainTex, IN.uv + float2(samples[1].x * _MainTex_TexelSize.x, samples[1].y * _MainTex_TexelSize.y)) * samples[1].w;
				col += tex2D(_MainTex, IN.uv + float2(samples[2].x * _MainTex_TexelSize.x, samples[2].y * _MainTex_TexelSize.y)) * samples[2].w;
				col += tex2D(_MainTex, IN.uv + float2(samples[3].x * _MainTex_TexelSize.x, samples[3].y * _MainTex_TexelSize.y)) * samples[3].w;
				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
