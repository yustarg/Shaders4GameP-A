Shader "Custom/ScreenEffect/Glare" {
	Properties {
		_MainTex("MainTex", 2D) = "white" {}
		_BlurTex1("BlurTex1", 2D) = "white" {}
		_BlurTex2("BlurTex2", 2D) = "white" {}
		_BlurTex3("BlurTex3", 2D) = "white" {}
		_GlowFactor1("_GlowFactor1", Range(0, 1)) = 0
		_GlowFactor2("_GlowFactor2", Range(0, 1)) = 0
		_GlowFactor3("_GlowFactor3", Range(0, 1)) = 0
	}
		SubShader{
			LOD 200

			Pass{
			//关闭剔除操作  
			Cull Off
			//关闭深度写入模式  
			ZWrite Off
			//设置深度测试模式:渲染所有像素.等同于关闭透明度测试（AlphaTestOff）  
			ZTest Always
			Blend SrcAlpha Zero
			//Blend One One
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _BlurTex1;
			uniform sampler2D _BlurTex2;
			uniform sampler2D _BlurTex3;
			uniform float _GlowFactor1;
			uniform float _GlowFactor2;
			uniform float _GlowFactor3;

			struct v2f {
				float4 pos : SV_POSITION; 
				float2 uv: TEXCOORD0;
			};

			v2f vert(appdata_img v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			fixed4 frag(v2f IN) : SV_TARGET
			{	
				return	float4((tex2D(_BlurTex1, float2(IN.uv.x, 1 - IN.uv.y)).xyz) * _GlowFactor1, 1.0) +
						float4((tex2D(_BlurTex2, float2(IN.uv.x, 1 - IN.uv.y)).xyz) * _GlowFactor2, 0) +
						float4((tex2D(_BlurTex3, float2(IN.uv.x, 1 - IN.uv.y)).xyz) * _GlowFactor3, 0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
