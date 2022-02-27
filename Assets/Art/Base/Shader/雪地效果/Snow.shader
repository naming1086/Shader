// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Snow"
{
	Properties
	{
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Tessellation("Tessellation", Float) = 5
		_MinDist("Min Dist", Float) = 0
		_MaxDist("Max Dist", Float) = 10
		_VertexOffset("VertexOffset", Float) = 1
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_MainColor("MainColor", Color) = (0,0,0,0)
		_OffsetStr("Offset Str", Vector) = (0.1,1,0,0)
		_RenderTex("RenderTex", 2D) = "white" {}
		_RenderTex2("RenderTex2", 2D) = "white" {}
		_StepMul("StepMul", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _VertexOffset;
		uniform sampler2D _RenderTex;
		uniform float _StepMul;
		uniform sampler2D _RenderTex2;
		uniform float4 _RenderTex2_ST;
		uniform float2 _OffsetStr;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _MainColor;
		uniform float _MinDist;
		uniform float _MaxDist;
		uniform float _Tessellation;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _MinDist,_MaxDist,_Tessellation);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv0_NoiseTex = v.texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float temp_output_32_0 = ( tex2Dlod( _RenderTex, float4( v.texcoord.xy, 0, 0.0) ).r * _StepMul );
			float2 uv_RenderTex2 = v.texcoord * _RenderTex2_ST.xy + _RenderTex2_ST.zw;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( ( (tex2Dlod( _NoiseTex, float4( uv0_NoiseTex, 0, 0.0) ).r*-1.0 + 0.5) * _VertexOffset ) - ( temp_output_32_0 - ( tex2Dlod( _RenderTex2, float4( uv_RenderTex2, 0, 0.0) ).r * 0.4 ) ) ) * ase_vertexNormal );
			float2 temp_output_2_0_g1 = uv0_NoiseTex;
			float2 break6_g1 = temp_output_2_0_g1;
			float temp_output_25_0_g1 = ( pow( _OffsetStr.x , 3.0 ) * 0.1 );
			float2 appendResult8_g1 = (float2(( break6_g1.x + temp_output_25_0_g1 ) , break6_g1.y));
			float4 tex2DNode14_g1 = tex2Dlod( _NoiseTex, float4( temp_output_2_0_g1, 0, 0.0) );
			float temp_output_4_0_g1 = _OffsetStr.y;
			float3 appendResult13_g1 = (float3(1.0 , 0.0 , ( ( tex2Dlod( _NoiseTex, float4( appendResult8_g1, 0, 0.0) ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float2 appendResult9_g1 = (float2(break6_g1.x , ( break6_g1.y + temp_output_25_0_g1 )));
			float3 appendResult16_g1 = (float3(0.0 , 1.0 , ( ( tex2Dlod( _NoiseTex, float4( appendResult9_g1, 0, 0.0) ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float3 normalizeResult22_g1 = normalize( cross( appendResult13_g1 , appendResult16_g1 ) );
			v.normal = ( ase_vertexNormal + normalizeResult22_g1 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 color56 = IsGammaSpace() ? float4(1,0.01919135,0,0) : float4(1,0.001485399,0,0);
			float temp_output_32_0 = ( tex2D( _RenderTex, i.uv_texcoord ).r * _StepMul );
			float4 lerpResult41 = lerp( ( tex2D( _MainTex, uv_MainTex ) * _MainColor ) , ( color56 * 3.0 ) , ( temp_output_32_0 * 10.0 ));
			o.Albedo = lerpResult41.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
51.33334;330;1682;814;729.2543;-670.7188;1.6;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-1826.805,757.0976;Inherit;False;0;14;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-2046.966,577.9705;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;14;-2236.182,186.8372;Inherit;True;Property;_NoiseTex;NoiseTex;8;0;Create;True;0;0;False;0;False;None;d2dc50a65ebdc9040be8b43b3272daf4;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;54;-1581.743,844.5956;Inherit;True;Property;_RenderTex2;RenderTex2;13;0;Create;True;0;0;False;0;False;-1;None;9fb54ca9457fd084aa66c1213f999924;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-1540.162,310.9924;Inherit;True;Property;_Noise;Noise;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-1570.764,545.8295;Inherit;True;Property;_RenderTex;RenderTex;12;0;Create;True;0;0;False;0;False;-1;None;a641c28b63110f348ad800515254d7b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1418.589,761.8173;Inherit;False;Property;_StepMul;StepMul;14;0;Create;True;0;0;False;0;False;1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1162.648,570.6064;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;12;-1189.283,319.0904;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1218.884,466.6367;Inherit;False;Property;_VertexOffset;VertexOffset;7;0;Create;True;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1191.62,755.9078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;-1005.635,189.5541;Inherit;False;Constant;_Color2;Color2;14;0;Create;True;0;0;False;0;False;1,0.01919135,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-793.007,136.9052;Inherit;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1046.27,-373.3658;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-986.3229,293.2835;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-967.9894,571.6996;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-1051.136,-165.1952;Inherit;False;Property;_MainColor;MainColor;10;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-967.9359,357.0977;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-1198.555,1019.267;Inherit;False;Property;_OffsetStr;Offset Str;11;0;Create;True;0;0;False;0;False;0.1,1;0.1,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-591.3964,59.11276;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-358.9362,1238.117;Inherit;False;Property;_MinDist;Min Dist;5;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;8;-879.0717,719.201;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-744.6964,-234.3712;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;21;-707.7692,810.0468;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-380.9362,1150.117;Inherit;False;Property;_Tessellation;Tessellation;4;0;Create;True;0;0;False;0;False;5;500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-833.7084,446.2159;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-758.7438,340.559;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-354.9362,1319.117;Inherit;False;Property;_MaxDist;Max Dist;6;0;Create;True;0;0;False;0;False;10;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;13;-846.3839,964.196;Inherit;True;NormalCreate;1;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-2458.465,774.3676;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;41;-353.4576,-54.58707;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;22;-428.4243,613.745;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-73.70012,387.9335;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-313.34,735.2972;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1952.948,831.5361;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;4;-142.936,1182.117;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-557.5016,497.9663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;47;-959.2755,16.17936;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-2175.304,1003.436;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-611.2516,278.5136;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1148.486,203.625;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2186.218,913.1683;Inherit;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-2271.497,802.0668;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;957.8611,304.8929;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Whl/Snow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;15;10;25;True;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;14;0
WireConnection;7;1;37;0
WireConnection;30;1;35;0
WireConnection;32;0;30;1
WireConnection;32;1;33;0
WireConnection;12;0;7;1
WireConnection;52;0;54;1
WireConnection;55;0;32;0
WireConnection;55;1;52;0
WireConnection;10;0;12;0
WireConnection;10;1;11;0
WireConnection;48;0;56;0
WireConnection;48;1;49;0
WireConnection;24;0;1;0
WireConnection;24;1;23;0
WireConnection;36;0;10;0
WireConnection;36;1;55;0
WireConnection;44;0;32;0
WireConnection;44;1;43;0
WireConnection;13;1;14;0
WireConnection;13;2;37;0
WireConnection;13;3;26;1
WireConnection;13;4;26;2
WireConnection;41;0;24;0
WireConnection;41;1;48;0
WireConnection;41;2;44;0
WireConnection;27;0;21;0
WireConnection;27;1;13;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;18;2;20;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;4;2;6;0
WireConnection;9;0;36;0
WireConnection;9;1;8;0
WireConnection;17;0;16;1
WireConnection;17;1;16;3
WireConnection;0;0;41;0
WireConnection;0;1;2;0
WireConnection;0;11;9;0
WireConnection;0;12;27;0
WireConnection;0;14;4;0
ASEEND*/
//CHKSM=08FC7FF084094E9E7222018528FBA000339F9395