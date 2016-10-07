// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/simpleRaymarch"
{
	SubShader
	{
		Pass
	{
		Blend SrcAlpha Zero

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#define STEPS 64
#define STEP_SIZE 0.01

	struct v2f
	{
		float4 pos : SV_POSITION;	// Clip space
		float3 wPos : TEXCOORD1;	// World position
	};

	// Vertex function
	v2f vert(appdata_full v)
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		return o;
	}

	// Fragment function
	fixed4 frag(v2f i) : SV_Target
	{
		float3 worldPosition = i.wPos;
		float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
		return raymarch(worldPosition, viewDirection);
	}
	
	bool raymarch(float3 position, float3 direction)
	{
		for (int i = 0; i < STEPS; i++)
		{
			if (sphereHit(position))
				return fixed4(1, 0, 0, 1); // Red

			position += direction * STEP_SIZE;
		}

		return fixed4(0, 0, 0, 1); // White
	}

	bool sphereHit(float3 p)
	{
		return distance(p, _centre) < _Radius;
	}
	ENDCG
}