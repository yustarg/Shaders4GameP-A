Shader "Custom/Lighting/Diffuse"
{
	Properties
	{
		_Ambient ("Ambient", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 color : TEXCOORD0;
			};

			uniform fixed4 _Ambient;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				float3 normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float nDotL = max(0, dot(normalDir, lightDir));
				o.color = unity_LightColor[0].rgba * nDotL + _Ambient;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
		}
	}
}
