﻿Shader "Custom/Unlit Day Texture White (Supports Lightmap)" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}

		SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass{
		Tags{ "LightMode" = "ForwardBase" }
		// Disable lighting, we're only using the lightmap
		Lighting Off

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

	struct appdata
	{
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		float2 texcoord1 : TEXCOORD1;
	};

	struct v2f
	{
		float4 vertex : SV_POSITION;
		half2 uv_lightmap : TEXCOORD0;
		half2 uv_main : TEXCOORD1;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;

	v2f vert(appdata i)
	{
		v2f o;
		o.vertex = mul(UNITY_MATRIX_MVP, i.vertex);
		o.uv_main = TRANSFORM_TEX(i.texcoord, _MainTex);
		o.uv_lightmap = i.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		half4 main_color = tex2D(_MainTex, i.uv_main);

		main_color.rgb += DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv_lightmap));

		return main_color;
	}

		ENDCG

	}

	}
}



