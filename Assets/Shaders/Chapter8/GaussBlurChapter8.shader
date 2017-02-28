Shader "Custom/ScreenEffect/GaussBlurChpater8" {
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
			
			static float4 samples[9] = {
				-1.0,    -1.0, 0,    1.0 / 16.0,
				-1.0,    1.0,    0,    1.0 / 16.0,
				1.0,    -1.0, 0,    1.0 / 16.0,
				1.0,    1.0,    0,    1.0 / 16.0,
				-1.0,    0.0,    0,    2.0 / 16.0,
				1.0,    0.0,    0,    2.0 / 16.0,
				0.0,    -1.0, 0,    2.0 / 16.0,
				0.0,    1.0,    0,    2.0 / 16.0,
				0.0,    0.0,   0,    4.0 / 16.0
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
				float4 color = float4(0,0,0,0);

				// Sample and output the averaged colors
				for (int i = 0; i < 9; i++)
				{
					float4 col = samples[i].w * tex2D(_MainTex, IN.uv +
						float2(samples[i].x * _MainTex_TexelSize.x,
							samples[i].y * _MainTex_TexelSize.y));
					color += col;
				}
				return color;
			}

			ENDCG
		}
	}
}
