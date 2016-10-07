// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/simpleRaymarch"
{
	Properties
	{
		_Radius("Radius",float)=1
		_Centre("Centre",float)=0
		_Color1("Sphere color", Color)=(1.0, 1.0, 1.0, 1.0)
		_Color2("Cube color", Color)=(1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		Pass
	{

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

sampler2D _MainTex;
	float3 _Centre;
	float _Radius;

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

	bool sphereHit(float3 p)
	{
		return distance(p, _Centre) < _Radius;
	}
	
	fixed4 _Color1;
	fixed4 _Color2;

	/*float map(float3 p) //this commented section is to add shading to sphere
	{
		return distance(p, _Centre) - _Radius;
	}
#include "Lighting.cginc"
	fixed4 simpleLambert(fixed3 normal) 
	{
		fixed3 lightDir = _WorldSpaceLightPos0.xyz;	// Light direction
		fixed3 lightCol = _LightColor0.rgb;		// Light color

		fixed NdotL = max(dot(normal, lightDir), 0);
		fixed4 c;
		c.rgb = _Color1 * lightCol * NdotL;
		c.a = 1;
		return c;
	}


	float3 normal (float3 p)
	{
		const float eps = 0.01;
 
		return normalize
		(	float3
			(	map(p + float3(eps, 0, 0)	) - map(p - float3(eps, 0, 0)),
				map(p + float3(0, eps, 0)	) - map(p - float3(0, eps, 0)),
				map(p + float3(0, 0, eps)	) - map(p - float3(0, 0, eps))
			)
		);
	}

	fixed4 renderSurface(float3 p)
	{
		float3 n = normal(p);
		return simpleLambert(n);
	}*/
	
	//selected colors


	//raymarching function
	bool raymarch(float3 position, float3 direction)
	{
		for (int i = 0; i < STEPS; i++)
		{
			if (sphereHit(position))
				//return fixed4(1.0, 0.0, 0.0, 1.0); // Red
				return _Color1;
				//return renderSurface(position);
			position += direction * STEP_SIZE;
		}
		return _Color2;
		//return fixed4(0.0, 1.0, 0.0 ,1.0);
	}


	// Fragment function
	fixed4 frag(v2f i) : SV_Target
	{
		float3 worldPosition = i.wPos;
		float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
		return raymarch(worldPosition, viewDirection);
	}

	ENDCG
	}
	}
}