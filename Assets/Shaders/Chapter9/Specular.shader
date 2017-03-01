Shader "Custom/Lighting/Specular"
{
	Properties
	{
		_Ambient("Ambient", Color) = (1, 1, 1, 1)
		_Shininess ("Shininess", Range(0.01, 1)) = 0.5
		_SpecColor("Specular Color", Color) = (1, 1, 1, 1)
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
				float4 pos : SV_POSITION;
				float4 col : TEXCOORD0;
			};

			uniform float4 _Ambient;
			uniform float4 _SpecColor;
			uniform float _Shininess;
			
			v2f vert (appdata input)
			{
				//v2f o;
				//o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				//float3 normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				//float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				//float nDotL = max(0, dot(normalDir, lightDir));
				//float4 diffuse = unity_LightColor[0].rgba * nDotL;

				//float3 viewDir = WorldSpaceViewDir(v.vertex);
				//float3 reflectDir = reflect(-lightDir, normalDir);
				//float rDotV = max(0, dot(reflectDir, viewDir));
				//float4 specular = _SpecColor * pow(rDotV, _Shininess);
				//o.color = diffuse + specular + _Ambient;
				//return o;
				v2f output;

				float4x4 modelMatrix = _Object2World;
				float3x3 modelMatrixInverse = _World2Object;
				float3 normalDirection = normalize(
					mul(input.normal, modelMatrixInverse));
				float3 viewDirection = normalize(_WorldSpaceCameraPos
					- mul(modelMatrix, input.vertex).xyz);
				float3 lightDirection;
				float attenuation;

				if (0.0 == _WorldSpaceLightPos0.w) // directional light?
				{
					attenuation = 1.0; // no attenuation
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else // point or spot light
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz
						- mul(modelMatrix, input.vertex).xyz;
					float distance = length(vertexToLightSource);
					attenuation = 1.0 / distance; // linear attenuation 
					lightDirection = normalize(vertexToLightSource);
				}

				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb;

				float3 diffuseReflection =
					attenuation * unity_LightColor[0].rgb
					* max(0.0, dot(normalDirection, lightDirection));

				float3 specularReflection;
				if (dot(normalDirection, lightDirection) < 0.0)
					// light source on the wrong side?
				{
					specularReflection = float3(0.0, 0.0, 0.0);
					// no specular reflection
				}
				else // light source on the right side
				{
					specularReflection = attenuation * unity_LightColor[0].rgb
						* _SpecColor.rgb * pow(max(0.0, dot(
							reflect(-lightDirection, normalDirection),
							viewDirection)), _Shininess);
				}

				output.col = float4(ambientLighting + diffuseReflection
					+ specularReflection, 1.0);
				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
				return output;

			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return i.col;
			}
			ENDCG
		}
	}
}
