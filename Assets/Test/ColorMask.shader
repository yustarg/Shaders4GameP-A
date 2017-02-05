Shader "Test/ColorMask" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		LOD 200
		
		Pass{
			//关闭深度写入模式  
			ZWrite Off
			//设置深度测试模式:渲染所有像素.等同于关闭透明度测试（AlphaTestOff）  
			ZTest Always
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

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
				fixed4 col = tex2D(_MainTex, IN.uv);
				return fixed4(col.rgba);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
