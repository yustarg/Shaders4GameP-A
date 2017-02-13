Shader "Custom/ScreenEffect/Sepia" {
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

			sampler2D _MainTex;

			static float4x4 color_filter = { 0.299,0.587,0.184,0.313,
				0.299,0.587,0.184,0.168,
				0.299,0.587,0.184,-0.09,
				0,0,0,1 };

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
				fixed4 original = tex2D(_MainTex, IN.uv);
				//float intensity = dot(original, color_filter[0]);
				fixed4 col = mul(color_filter, original);
				return col;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
