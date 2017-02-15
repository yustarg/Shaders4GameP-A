Shader "Custom/ScreenEffect/DepthOfField" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		LOD 200
		
		Pass{
			//关闭剔除操作  
			Cull Off
			//关闭深度写入模式  
			ZWrite Off
			//设置深度测试模式:渲染所有像素.等同于关闭透明度测试（AlphaTestOff）  
			ZTest Always
			//Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
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

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_TexelSize;
			uniform sampler2D _CameraDepthTexture;

			struct v2f {
				float4 pos : SV_POSITION; 
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata_img v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv.xy = v.texcoord.xy;
				return o;
			}

			fixed4 frag(v2f IN) : SV_TARGET
			{	
				fixed4 col = tex2D(_MainTex, IN.uv);
				fixed4 blur = fixed4(0, 0, 0, 0);
				for (int i = 0; i < 7; i++)
				{
					blur += tex2D(_MainTex, IN.uv + float2(gaussFilterOffset[i].x * _MainTex_TexelSize.x, 0)) * gaussFilter[i];
				}
				#if UNITY_UV_STARTS_AT_TOP
					if (_MainTex_TexelSize.y < 0)
						IN.uv.xy = IN.uv.xy * half2(1, -1) + half2(0, 1);
				#endif
				float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, IN.uv.xy);
				d = Linear01Depth(d);
				float blurFactor = saturate(abs(d - 0.5));
				return lerp(col, blur, blurFactor);
				//return col.rgba * d;
				return blur;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
