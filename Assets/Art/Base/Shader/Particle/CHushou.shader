// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HL/Particle/ChuShou_1"
{
	Properties
	{
		[Enum(On,1,Off,0)]_Swi1("粒子控制VO随机偏移（UV2_UVW）", Float) = 0
		_AlbedoColor("AlbedoColor", Color) = (1,1,1,1)
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalScale("NormalScale", Range( -1 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_GlowTex("GlowTex", 2D) = "white" {}
		_GlowColor("GlowColor", Color) = (1,1,1,1)
		_GlowScale("GlowScale", Float) = 0
		_GlowPanner("GlowPanner", Vector) = (0,0,0,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseScale("NoiseScale", Float) = 0
		_NoisePanner("NoisePanner", Vector) = (0,0,0,0)
		_FresnelMaskPower("FresnelMaskPower", Float) = 1
		_FresnelMaskScale("FresnelMaskScale", Float) = 1
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_FresnelPower("FresnelPower", Float) = 1
		_FresnelScale("FresnelScale", Float) = 1
		_Vertex_XYZ_Tex("Vertex_XYZ_Tex", 2D) = "white" {}
		_Vertex_X_Offset("Vertex_X_Offset", Vector) = (0,0,0,0)
		_Vertex_Y_Offset("Vertex_Y_Offset", Vector) = (0,0,0,0)
		_Vertex_Z_Offset("Vertex_Z_Offset", Vector) = (0,0,0,0)
		_Vertex_X_Panner("Vertex_X_Panner", Vector) = (0,0,0,0)
		_Vertex_Y_Panner("Vertex_Y_Panner", Vector) = (0,0,0,0)
		_Vertex_Z_Panner("Vertex_Z_Panner", Vector) = (0,0,0,0)
		_Vertex_XYZ_Scale("Vertex_XYZ_Scale", Vector) = (0,0,0,0)
		_VertexMaskTex("VertexMaskTex", 2D) = "white" {}
		_VertexMaskScale("VertexMaskScale", Float) = 0
		_VertexOffsetADDScale("VertexOffsetADDScale", Float) = 0
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Vertex_XYZ_Tex;
		uniform float4 _Vertex_X_Panner;
		uniform float _Swi1;
		uniform float4 _Vertex_XYZ_Tex_ST;
		uniform float4 _Vertex_X_Offset;
		uniform float3 _Vertex_XYZ_Scale;
		uniform float4 _Vertex_Y_Panner;
		uniform float4 _Vertex_Y_Offset;
		uniform float4 _Vertex_Z_Panner;
		uniform float4 _Vertex_Z_Offset;
		uniform sampler2D _VertexMaskTex;
		uniform float4 _VertexMaskTex_ST;
		uniform float _VertexMaskScale;
		uniform float _VertexOffsetADDScale;
		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoisePanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseScale;
		uniform float4 _AlbedoColor;
		uniform sampler2D _GlowTex;
		uniform float4 _GlowPanner;
		uniform float4 _GlowTex_ST;
		uniform float4 _GlowColor;
		uniform float _GlowScale;
		uniform float _FresnelMaskPower;
		uniform float _FresnelMaskScale;
		uniform float _FresnelPower;
		uniform float _FresnelScale;
		uniform float4 _FresnelColor;
		uniform float _Metallic;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime89 = _Time.y * _Vertex_X_Panner.z;
			float lerpResult103 = lerp( 0.0 , v.texcoord1.x , _Swi1);
			float2 appendResult88 = (float2(_Vertex_X_Panner.x , _Vertex_X_Panner.y));
			float2 uv0_Vertex_XYZ_Tex = v.texcoord.xy * _Vertex_XYZ_Tex_ST.xy + _Vertex_XYZ_Tex_ST.zw;
			float2 appendResult78 = (float2(_Vertex_X_Offset.x , _Vertex_X_Offset.y));
			float2 appendResult79 = (float2(_Vertex_X_Offset.z , _Vertex_X_Offset.w));
			float2 panner84 = ( ( mulTime89 + _Vertex_X_Panner.w + lerpResult103 ) * appendResult88 + (uv0_Vertex_XYZ_Tex*appendResult78 + appendResult79));
			float mulTime92 = _Time.y * _Vertex_Y_Panner.z;
			float lerpResult105 = lerp( 0.0 , v.texcoord1.y , _Swi1);
			float2 appendResult91 = (float2(_Vertex_Y_Panner.x , _Vertex_Y_Panner.y));
			float2 appendResult80 = (float2(_Vertex_Y_Offset.x , _Vertex_Y_Offset.y));
			float2 appendResult81 = (float2(_Vertex_Y_Offset.z , _Vertex_Y_Offset.w));
			float2 panner85 = ( ( mulTime92 + _Vertex_Y_Panner.w + lerpResult105 ) * appendResult91 + (uv0_Vertex_XYZ_Tex*appendResult80 + appendResult81));
			float mulTime96 = _Time.y * _Vertex_Z_Panner.z;
			float lerpResult106 = lerp( 0.0 , v.texcoord1.z , _Swi1);
			float2 appendResult95 = (float2(_Vertex_Z_Panner.x , _Vertex_Z_Panner.y));
			float2 appendResult82 = (float2(_Vertex_Z_Offset.x , _Vertex_Z_Offset.y));
			float2 appendResult83 = (float2(_Vertex_Z_Offset.z , _Vertex_Z_Offset.w));
			float2 panner86 = ( ( mulTime96 + _Vertex_Z_Panner.w + lerpResult106 ) * appendResult95 + (uv0_Vertex_XYZ_Tex*appendResult82 + appendResult83));
			float3 appendResult60 = (float3(( (-0.5 + (tex2Dlod( _Vertex_XYZ_Tex, float4( panner84, 0, 0.0) ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * _Vertex_XYZ_Scale.x ) , ( (-0.5 + (tex2Dlod( _Vertex_XYZ_Tex, float4( panner85, 0, 0.0) ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * _Vertex_XYZ_Scale.y ) , ( (-0.5 + (tex2Dlod( _Vertex_XYZ_Tex, float4( panner86, 0, 0.0) ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * _Vertex_XYZ_Scale.z )));
			float2 uv_VertexMaskTex = v.texcoord * _VertexMaskTex_ST.xy + _VertexMaskTex_ST.zw;
			float4 tex2DNode108 = tex2Dlod( _VertexMaskTex, float4( uv_VertexMaskTex, 0, 0.0) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( appendResult60 * tex2DNode108.r * _VertexMaskScale ) + ( ase_vertexNormal * ( 1.0 - tex2DNode108.r ) * _VertexOffsetADDScale ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime22 = _Time.y * _NoisePanner.z;
			float2 appendResult24 = (float2(_NoisePanner.x , _NoisePanner.y));
			float2 uv0_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner26 = ( ( mulTime22 + _NoisePanner.w ) * appendResult24 + uv0_NoiseTex);
			float4 temp_output_18_0 = ( tex2D( _NoiseTex, panner26 ) * _NoiseScale );
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + temp_output_18_0 ).rg ), _NormalScale );
			o.Albedo = _AlbedoColor.rgb;
			float mulTime15 = _Time.y * _GlowPanner.z;
			float2 appendResult14 = (float2(_GlowPanner.x , _GlowPanner.y));
			float2 uv0_GlowTex = i.uv_texcoord * _GlowTex_ST.xy + _GlowTex_ST.zw;
			float2 panner10 = ( ( mulTime15 + _GlowPanner.w ) * appendResult14 + uv0_GlowTex);
			float UV2T125 = i.uv2_tex4coord2.w;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult31 = dot( ase_worldViewDir , ase_normWorldNormal );
			o.Emission = max( ( ( ( tex2D( _GlowTex, ( temp_output_18_0 + float4( panner10, 0.0 , 0.0 ) ).rg ) * _GlowColor * _GlowScale * UV2T125 ) * ( pow( dotResult31 , _FresnelMaskPower ) * _FresnelMaskScale ) ) + ( pow( saturate( ( 1.0 - dotResult31 ) ) , _FresnelPower ) * _FresnelScale * _FresnelColor ) ) , float4( 0,0,0,0 ) ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = i.vertexColor.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_tex4coord2;
				o.customPack2.xyzw = v.texcoord1;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_tex4coord2 = IN.customPack2.xyzw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
183.3333;651.3334;1719;1171;5396.405;-329.8266;2.925212;True;True
Node;AmplifyShaderEditor.CommentaryNode;46;-3857.231,-1490.845;Inherit;False;2970.988;1656.823;Color;42;21;22;24;13;25;23;15;26;14;19;16;17;12;10;18;20;8;9;6;7;28;29;3;37;1;44;2;35;36;33;34;38;42;39;45;41;43;40;32;30;31;133;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;21;-3807.231,-1062.761;Inherit;False;Property;_NoisePanner;NoisePanner;13;0;Create;True;0;0;False;0;False;0,0,0,0;-0.3,-1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;22;-3551.59,-970.0337;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;102;-5593.517,1429.709;Inherit;False;292;257;UV2的UVW三个通道控制偏移;1;101;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-5529.714,1479.709;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;104;-5139.837,1337.833;Inherit;False;Constant;_Float0;Float 0;30;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;76;-4033.039,1343.828;Inherit;False;Property;_Vertex_Y_Offset;Vertex_Y_Offset;25;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;94;-3366.352,1321.087;Inherit;False;Property;_Vertex_Y_Panner;Vertex_Y_Panner;28;0;Create;True;0;0;False;0;False;0,0,0,0;0,-1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;98;-3345.488,1722.498;Inherit;False;Property;_Vertex_Z_Panner;Vertex_Z_Panner;29;0;Create;True;0;0;False;0;False;0,0,0,0;0,-1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;-3412.487,-1060.015;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;87;-3369.832,976.8585;Inherit;False;Property;_Vertex_X_Panner;Vertex_X_Panner;27;0;Create;True;0;0;False;0;False;0,0,0,0;0,-1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-3570.739,-1183.399;Inherit;False;0;17;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;13;-3150.156,-790.0179;Inherit;False;Property;_GlowPanner;GlowPanner;10;0;Create;True;0;0;False;0;False;0,0,0,0;-0.3,-1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-3371.203,-951.5544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;75;-4034.35,1002.04;Inherit;False;Property;_Vertex_X_Offset;Vertex_X_Offset;24;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-4660.596,1082.382;Inherit;False;0;64;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;77;-4061.615,1720.678;Inherit;False;Property;_Vertex_Z_Offset;Vertex_Z_Offset;26;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;116;-5148.646,1741.914;Inherit;False;Property;_Swi1;粒子控制VO随机偏移（UV2_UVW）;1;1;[Enum];Create;False;2;On;1;Off;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;83;-3730.482,1833.24;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;106;-4497.103,1970.663;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;105;-4511.33,1593.471;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;80;-3736.479,1330.861;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;26;-3203.038,-1181.799;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-3733.482,1707.24;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;103;-4503.099,1262.206;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-3728.34,1024.734;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;81;-3734.781,1437.336;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;100;-4183.154,1483.89;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-3734.34,900.7336;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-3097.038,1781.6;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;89;-3137.252,1028.981;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;99;-4183.986,832.5514;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;92;-3127.568,1383.552;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-2894.515,-697.29;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2913.665,-910.6553;Inherit;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;69;-3388.332,820.0823;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-2931.775,1774.443;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2767.903,-990.8722;Inherit;False;Property;_NoiseScale;NoiseScale;12;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-2924.471,1381.1;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;32;-2649.032,-348.9826;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-2960.253,1037.981;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-3039.855,1259.387;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2714.128,-678.8109;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;70;-3393.814,1178.705;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-2755.412,-787.2715;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-3101.252,939.9805;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;30;-2633.564,-537.3035;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;17;-2904.368,-1202.037;Inherit;True;Property;_NoiseTex;NoiseTex;11;0;Create;True;0;0;False;0;False;-1;None;1a7f074f01ec95d45a96f2f6196edd36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;71;-3343.209,1557.135;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;95;-3061.038,1692.6;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;85;-2742.24,1165.852;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;86;-2733.553,1500.281;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;84;-2760.915,886.9227;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;31;-2420.271,-435.5291;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2407.6,-1210.791;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;10;-2545.963,-909.0553;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2093.498,-361.9303;Inherit;False;Property;_FresnelMaskPower;FresnelMaskPower;14;0;Create;True;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-2486.471,1026.017;Inherit;True;Property;_TextureSample1;Texture Sample 1;23;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;64;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-5256.419,1643.601;Inherit;False;UV2T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-2514.879,1323.866;Inherit;True;Property;_TextureSample0;Texture Sample 0;23;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;64;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;139;-2127.683,813.749;Inherit;False;260.8999;669.1;;3;142;141;140;偏移强度映射到有正有负;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;38;-2074.605,-243.7628;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-2239.521,-983.6337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;-2491.878,777.0795;Inherit;True;Property;_Vertex_XYZ_Tex;Vertex_XYZ_Tex;23;0;Create;True;0;0;False;0;False;-1;None;ab0e142acc0d62c4cad892f7a66b434a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;39;-1914.218,-240.8172;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;140;-2104.066,1321.101;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1946.399,-143.3059;Inherit;False;Property;_FresnelPower;FresnelPower;17;0;Create;True;0;0;False;0;False;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;67;-2023.16,1571.769;Inherit;False;Property;_Vertex_XYZ_Scale;Vertex_XYZ_Scale;30;0;Create;True;0;0;False;0;False;0,0,0;2,2,2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;33;-1885.283,-441.0646;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;142;-2100.07,1093.211;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1844.757,-339.1971;Inherit;False;Property;_FresnelMaskScale;FresnelMaskScale;15;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2073.721,-608.0052;Inherit;False;Property;_GlowScale;GlowScale;9;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-1939,-790.676;Inherit;False;Property;_GlowColor;GlowColor;8;0;Create;True;0;0;False;0;False;1,1,1,1;1,0.401022,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-2035.772,-983.1328;Inherit;True;Property;_GlowTex;GlowTex;7;0;Create;True;0;0;False;0;False;-1;None;45db4550c9596b74398792135dd62612;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;133;-2048.34,-519.3117;Inherit;False;125;UV2T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;141;-2106.553,872.4854;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1530.038,1246.146;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;41;-1727.783,-239.3404;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1542.241,986.9734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1618.239,-899.4086;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1645.443,-438.7605;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-1745.878,-46.02222;Inherit;False;Property;_FresnelColor;FresnelColor;16;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.4,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;108;-738.6362,1333.28;Inherit;True;Property;_VertexMaskTex;VertexMaskTex;31;0;Create;True;0;0;False;0;False;-1;None;7bb55bf236571dd4fa6c15814d58930a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1549.745,1102.169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1724.958,-137.4728;Inherit;False;Property;_FresnelScale;FresnelScale;18;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;114;-163.6404,1494.099;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1384.891,-621.0606;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-2128.118,-1336.057;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1525.644,-237.0362;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;112;-438.7635,1711.362;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;115;-444.8585,1851.573;Inherit;False;Property;_VertexOffsetADDScale;VertexOffsetADDScale;33;0;Create;True;0;0;False;0;False;0;0.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-1126.81,1076.876;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-678.6443,1586.814;Inherit;False;Property;_VertexMaskScale;VertexMaskScale;32;0;Create;True;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-226.3972,1072.725;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1911.679,-1164.577;Inherit;False;Property;_NormalScale;NormalScale;4;0;Create;True;0;0;False;0;False;0;0.51;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1186.007,-419.292;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1814.167,-1271.84;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;89.37752,1623.602;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-701.8218,2335.301;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-1497.251,-1440.845;Inherit;False;Property;_AlbedoColor;AlbedoColor;2;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;52;-1490.129,2325.23;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-671.6747,50.06533;Inherit;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;130;-53.49255,172.058;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-1640.252,2542.526;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-670.3356,-23.52637;Inherit;False;Property;_Metallic;Metallic;5;0;Create;True;0;0;False;0;False;1;0.401;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1565.203,-1245.365;Inherit;True;Property;_NormalMap;NormalMap;3;0;Create;True;0;0;False;0;False;-1;None;2aab2b9fb283e6646ad7f1df2f799dc1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-423.694,2265.825;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;55;-1833.252,2538.526;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;54;-1833.252,2439.526;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1861.129,2310.23;Inherit;False;0;49;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;53;-2059.253,2464.526;Inherit;False;Property;_VertexNoisePanner;VertexNoisePanner;22;0;Create;True;0;0;False;0;False;0,0,0,0;0,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;57;-900.8218,2346.301;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1144.82,2519.301;Inherit;False;Property;_VertexNoisePower;VertexNoisePower;21;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-926.1307,2533.23;Inherit;False;Property;_VertexNoiseScale;VertexNoiseScale;20;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-34.99646,1838.221;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;290.1033,915.2183;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;48;-1169.141,2176.445;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;-1241.13,2323.23;Inherit;True;Property;_VertexNoise;VertexNoise;19;0;Create;True;0;0;False;0;False;-1;None;1a7f074f01ec95d45a96f2f6196edd36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;136;-961.5883,-376.5297;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-2572.671,1900.599;Inherit;False;125;UV2T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-420.3119,1997.542;Inherit;False;125;UV2T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;316.8541,-45.54038;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HL/Particle/ChuShou_1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;21;3
WireConnection;24;0;21;1
WireConnection;24;1;21;2
WireConnection;23;0;22;0
WireConnection;23;1;21;4
WireConnection;83;0;77;3
WireConnection;83;1;77;4
WireConnection;106;0;104;0
WireConnection;106;1;101;3
WireConnection;106;2;116;0
WireConnection;105;0;104;0
WireConnection;105;1;101;2
WireConnection;105;2;116;0
WireConnection;80;0;76;1
WireConnection;80;1;76;2
WireConnection;26;0;25;0
WireConnection;26;2;24;0
WireConnection;26;1;23;0
WireConnection;82;0;77;1
WireConnection;82;1;77;2
WireConnection;103;0;104;0
WireConnection;103;1;101;1
WireConnection;103;2;116;0
WireConnection;79;0;75;3
WireConnection;79;1;75;4
WireConnection;81;0;76;3
WireConnection;81;1;76;4
WireConnection;100;0;68;0
WireConnection;78;0;75;1
WireConnection;78;1;75;2
WireConnection;96;0;98;3
WireConnection;89;0;87;3
WireConnection;99;0;68;0
WireConnection;92;0;94;3
WireConnection;15;0;13;3
WireConnection;69;0;99;0
WireConnection;69;1;78;0
WireConnection;69;2;79;0
WireConnection;97;0;96;0
WireConnection;97;1;98;4
WireConnection;97;2;106;0
WireConnection;93;0;92;0
WireConnection;93;1;94;4
WireConnection;93;2;105;0
WireConnection;90;0;89;0
WireConnection;90;1;87;4
WireConnection;90;2;103;0
WireConnection;91;0;94;1
WireConnection;91;1;94;2
WireConnection;16;0;15;0
WireConnection;16;1;13;4
WireConnection;70;0;68;0
WireConnection;70;1;80;0
WireConnection;70;2;81;0
WireConnection;14;0;13;1
WireConnection;14;1;13;2
WireConnection;88;0;87;1
WireConnection;88;1;87;2
WireConnection;17;1;26;0
WireConnection;71;0;100;0
WireConnection;71;1;82;0
WireConnection;71;2;83;0
WireConnection;95;0;98;1
WireConnection;95;1;98;2
WireConnection;85;0;70;0
WireConnection;85;2;91;0
WireConnection;85;1;93;0
WireConnection;86;0;71;0
WireConnection;86;2;95;0
WireConnection;86;1;97;0
WireConnection;84;0;69;0
WireConnection;84;2;88;0
WireConnection;84;1;90;0
WireConnection;31;0;30;0
WireConnection;31;1;32;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;10;0;12;0
WireConnection;10;2;14;0
WireConnection;10;1;16;0
WireConnection;65;1;85;0
WireConnection;125;0;101;4
WireConnection;66;1;86;0
WireConnection;38;0;31;0
WireConnection;20;0;18;0
WireConnection;20;1;10;0
WireConnection;64;1;84;0
WireConnection;39;0;38;0
WireConnection;140;0;66;1
WireConnection;33;0;31;0
WireConnection;33;1;35;0
WireConnection;142;0;65;1
WireConnection;6;1;20;0
WireConnection;141;0;64;1
WireConnection;63;0;140;0
WireConnection;63;1;67;3
WireConnection;41;0;39;0
WireConnection;41;1;42;0
WireConnection;61;0;141;0
WireConnection;61;1;67;1
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;7;2;9;0
WireConnection;7;3;133;0
WireConnection;34;0;33;0
WireConnection;34;1;36;0
WireConnection;62;0;142;0
WireConnection;62;1;67;2
WireConnection;114;0;108;1
WireConnection;37;0;7;0
WireConnection;37;1;34;0
WireConnection;40;0;41;0
WireConnection;40;1;43;0
WireConnection;40;2;45;0
WireConnection;60;0;61;0
WireConnection;60;1;62;0
WireConnection;60;2;63;0
WireConnection;109;0;60;0
WireConnection;109;1;108;1
WireConnection;109;2;110;0
WireConnection;44;0;37;0
WireConnection;44;1;40;0
WireConnection;29;0;28;0
WireConnection;29;1;18;0
WireConnection;117;0;112;0
WireConnection;117;1;114;0
WireConnection;117;2;115;0
WireConnection;58;0;57;0
WireConnection;58;1;50;0
WireConnection;52;0;51;0
WireConnection;52;2;54;0
WireConnection;52;1;56;0
WireConnection;56;0;55;0
WireConnection;56;1;53;4
WireConnection;2;1;29;0
WireConnection;2;5;3;0
WireConnection;47;0;48;0
WireConnection;47;1;58;0
WireConnection;55;0;53;3
WireConnection;54;0;53;1
WireConnection;54;1;53;2
WireConnection;57;0;49;0
WireConnection;57;1;59;0
WireConnection;113;0;112;0
WireConnection;113;1;115;0
WireConnection;113;2;132;0
WireConnection;138;0;109;0
WireConnection;138;1;117;0
WireConnection;49;1;52;0
WireConnection;136;0;44;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;136;0
WireConnection;0;3;4;0
WireConnection;0;4;5;0
WireConnection;0;9;130;0
WireConnection;0;11;138;0
ASEEND*/
//CHKSM=7CF1D4110E48FD63A7DAD9FC32D2D1DBE2951AA1