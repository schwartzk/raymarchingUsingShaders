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
		o.wPos = mul(_Object2World, v.vertex).xyz;
		return o;
	}

	// Fragment function
	fixed4 frag(v2f i) : SV_Target
	{
		float3 worldPosition = i.wPos;
		float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
		return raymarch(worldPosition, viewDirection);
	}
}