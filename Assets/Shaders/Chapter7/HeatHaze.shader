Shader "Custom/ScreenEffect/HeatHaze" {
	Properties {
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_DistortionMap ("DistortionMap", 2D) = "white" {}
		_OffsetScale("Offset Scale", Float) = 1
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

			uniform sampler2D _MainTex;
			uniform sampler2D _DistortionMap;
			uniform float4 _MainTex_TexelSize;
			uniform float _OffsetScale;

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
				float2 offset = tex2D(_DistortionMap, float2(8 * IN.uv.x, 8 * IN.uv.y + _Time.y)).xy;
				offset = ((offset*2.0) - 1.0) * _OffsetScale;
				// Fetch render target with the texture offset applied
				return tex2D(_MainTex, IN.uv + offset);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
