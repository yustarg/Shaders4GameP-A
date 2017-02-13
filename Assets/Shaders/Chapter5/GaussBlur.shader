Shader "Custom/ScreenEffect/GaussBlur" {
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
			
			static float2 gaussFilterOffset[7] = {
				-3.0f,0.0f,
				-2.0f,0.0f,
				-1.0f,0.0f,
				0.0f,0.0f,
				1.0f,0.0f,
				2.0f,0.0f,
				3.0f,0.0f
			};

			static float gaussFilter[7] = {
				(1.0f / 64.0f),
				(6.0f / 64.0f),
				(15.0f / 64.0f),
				(20.0f / 64.0f),
				(15.0f / 64.0f),
				(6.0f / 64.0f),
				(1.0f / 64.0f)
			};

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
				fixed4 col = fixed4(0, 0, 0, 0);
				for (int i = 0; i < 7; i++)
				{
					col += tex2D(_MainTex, IN.uv + float2(gaussFilterOffset[i].x * _MainTex_TexelSize.x, 0)) * gaussFilter[i];
				}
				return col;
			}

			ENDCG
		}

		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;

			static float2 gaussFilterOffset[7] = {
				-3.0f,0.0f,
				-2.0f,0.0f,
				-1.0f,0.0f,
				0.0f,0.0f,
				1.0f,0.0f,
				2.0f,0.0f,
				3.0f,0.0f
			};

			static float gaussFilter[7] = {
				(1.0f / 64.0f),
				(6.0f / 64.0f),
				(15.0f / 64.0f),
				(20.0f / 64.0f),
				(15.0f / 64.0f),
				(6.0f / 64.0f),
				(1.0f / 64.0f)
			};

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
				fixed4 col = fixed4(0, 0, 0, 0);
				for (int i = 0; i < 7; i++)
				{
					col += tex2D(_MainTex, IN.uv + float2(0, gaussFilterOffset[i].x * _MainTex_TexelSize.y)) * gaussFilter[i];
				}
				return col;
			}

			ENDCG
		}
	}
}
