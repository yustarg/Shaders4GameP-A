Shader "Custom/ScreenEffect/CubeHDR" {
	Properties {
		_MainTex("MainTex", Cube) = "white" {}
	}
		SubShader{
			LOD 200

			Pass{
			Tags{ "Queue" = "Background" "RenderType" = "Background" "PreviewType" = "Skybox" }
			//关闭剔除操作  
			Cull Off
			//关闭深度写入模式  
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform samplerCUBE _MainTex;

			struct v2f {
				float4 pos : SV_POSITION; 
				float3 uv: TEXCOORD0;
			};

			v2f vert(appdata_img v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.vertex.xyz;;
				return o;
			}

			fixed4 frag(v2f IN) : SV_TARGET
			{	
				return texCUBE(_MainTex, IN.uv);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
