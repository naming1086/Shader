// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/HalfLambertGroundLMP"
{
	Properties
	{
		[Toggle(_ACES_ON)] _ACES("ACES", Float) = 0
		_DiffuseTex("DiffuseTex", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_ShaowColor("ShaowColor", Color) = (0,0,0,0)
		_Power("Power", Float) = 1
		_Mul("Mul", Float) = 1
		[Toggle(_USELMP_ON)] _UseLmp("UseLmp", Float) = 0
		_LmpColor("LmpColor", Color) = (1,1,1,1)
		_LmpIntensity("LmpIntensity", Float) = 1
		_LightMul("LightMul", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _ACES_ON
		#pragma shader_feature_local _USELMP_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _ShaowColor;
		uniform sampler2D _DiffuseTex;
		uniform float4 _DiffuseTex_ST;
		uniform float4 _BaseColor;
		uniform float _Power;
		uniform float _Mul;
		uniform float _LmpIntensity;
		uniform float4 _LmpColor;
		uniform float _LightMul;


		float3 ACESTonemap107( float3 LinearColor )
		{
			float a = 2.51f;
			float b = 0.03f;
			float c = 2.43f;
			float d = 0.59f;
			float e = 0.14f;
			return
			saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e));
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_71_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float3 temp_cast_0 = (1.0).xxx;
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch84 = temp_cast_0;
			#else
				float3 staticSwitch84 = temp_output_71_0;
			#endif
			float3 LightColor78 = staticSwitch84;
			float2 uv_DiffuseTex = i.uv_texcoord * _DiffuseTex_ST.xy + _DiffuseTex_ST.zw;
			float4 ShaowColor93 = ( _ShaowColor * tex2D( _DiffuseTex, uv_DiffuseTex ) );
			float4 BaseColor96 = ( _BaseColor * tex2D( _DiffuseTex, uv_DiffuseTex ) );
			float3 break72 = temp_output_71_0;
			float LightAtten56 = max( max( break72.x , break72.y ) , break72.z );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 WorldNormal22 = ase_normWorldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g1 = dot( WorldNormal22 , ase_worldlightDir );
			float temp_output_114_0 = ( pow( ( LightAtten56 * (dotResult5_g1*0.5 + 0.5) ) , _Power ) * _Mul );
			float4 temp_cast_2 = (saturate( temp_output_114_0 )).xxxx;
			float4 temp_cast_3 = (temp_output_114_0).xxxx;
			UnityGI gi119 = gi;
			float3 diffNorm119 = WorldNormalVector( i , WorldNormal22 );
			gi119 = UnityGI_Base( data, 1, diffNorm119 );
			float3 indirectDiffuse119 = gi119.indirect.diffuse + diffNorm119 * 0.0001;
			float3 LightMap151 = indirectDiffuse119;
			#ifdef _USELMP_ON
				float4 staticSwitch132 = ( saturate( min( temp_cast_3 , ( _LmpIntensity * float4( LightMap151 , 0.0 ) * _LmpColor ) ) ) + float4( ( max( (LightMap151*0.3 + -0.3) , float3( 0,0,0 ) ) * _LightMul ) , 0.0 ) );
			#else
				float4 staticSwitch132 = temp_cast_2;
			#endif
			float4 lerpResult5 = lerp( ShaowColor93 , BaseColor96 , staticSwitch132);
			float4 temp_output_105_0 = max( ( float4( LightColor78 , 0.0 ) * lerpResult5 ) , float4( 0,0,0,0 ) );
			float3 LinearColor107 = ( temp_output_105_0 * temp_output_105_0 ).rgb;
			float3 localACESTonemap107 = ACESTonemap107( LinearColor107 );
			#ifdef _ACES_ON
				float4 staticSwitch110 = float4( sqrt( localACESTonemap107 ) , 0.0 );
			#else
				float4 staticSwitch110 = temp_output_105_0;
			#endif
			c.rgb = staticSwitch110.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
-1701;69;1595;907;3065.404;321.8489;1.9;True;False
Node;AmplifyShaderEditor.CommentaryNode;89;-4605.708,-695.1089;Inherit;False;1513.141;690.5745;LightAtten;10;56;78;85;84;73;74;72;71;69;70;LightAtten;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;70;-4568.668,-409.4142;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;69;-4539.42,-199.4548;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-4285.965,-333.7692;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;72;-3972.364,-314.8084;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;103;-4618.97,-1901.393;Inherit;False;504.303;432.5138;WorldNormal&ViewDir;4;37;36;22;21;WorldNormal&ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;74;-3732.461,-335.9161;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;21;-4580.688,-1839.904;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-4358.93,-1843.281;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;73;-3602.448,-316.5994;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-3319.547,-310.9016;Inherit;False;LightAtten;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2326.067,434.7483;Inherit;False;22;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-2521.508,-26.84355;Inherit;False;22;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-2271.129,-126.6467;Inherit;False;56;LightAtten;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;119;-2113.223,439.3763;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;1;-2313.352,-23.64051;Inherit;False;Half Lambert Term;-1;;1;86299dc21373a954aa5772333626c9c1;0;1;3;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1954.754,-42.57423;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1899.42,186.6232;Inherit;False;Property;_Power;Power;4;0;Create;True;0;0;False;0;False;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-1848.682,434.9766;Inherit;False;LightMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-1880.518,331.5341;Inherit;False;Property;_LmpIntensity;LmpIntensity;8;0;Create;True;0;0;False;0;False;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-1620.284,198.5722;Inherit;False;Property;_Mul;Mul;5;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;127;-1889.581,532.0842;Inherit;False;Property;_LmpColor;LmpColor;7;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;144;-1956.17,872.6122;Inherit;False;Constant;_Scale;Scale;10;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-1956.17,951.6128;Inherit;False;Constant;_Offset;Offset;11;0;Create;True;0;0;False;0;False;-0.3;-0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;112;-1696.724,-16.07341;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-2034.589,784.9277;Inherit;False;151;LightMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-1448.42,-8.950319;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;92;-4618.395,-1365.605;Inherit;False;1009.513;513.5418;ShaowColor;4;61;4;60;93;ShaowColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;143;-1719.852,799.96;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;95;-3519.517,-1368.414;Inherit;False;919.8992;508.5779;BaseColor;4;3;63;62;96;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-1569.127,405.6723;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;150;-1464.364,800.9363;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;62;-3477.179,-1102.064;Inherit;True;Property;_DiffuseTex;DiffuseTex;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;-4570.395,-1125.605;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;62;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-3443.39,-1318.414;Inherit;False;Property;_BaseColor;BaseColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;131;-1197.751,223.0507;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;4;-4506.395,-1317.605;Inherit;False;Property;_ShaowColor;ShaowColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.735849,0.7254003,0.7115521,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-1517.629,953.3797;Inherit;False;Property;_LightMul;LightMul;9;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-1262.105,800.701;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-4125.359,-569.867;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-3118.807,-1183.998;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;116;-1025.85,227.2808;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-4186.395,-1141.605;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;154;-985.2825,5.562972;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-2889.51,-1170.921;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-838.4562,224.2216;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;84;-3883.779,-588.4216;Inherit;True;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-3978.395,-1141.605;Inherit;False;ShaowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;132;-630.6313,1.997591;Inherit;False;Property;_UseLmp;UseLmp;6;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-777.9813,-104.5099;Inherit;False;96;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-779.747,-201.4086;Inherit;False;93;ShaowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-3528.762,-591.5405;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-346.5485,-374.2229;Inherit;True;78;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;5;-401.8225,-146.0803;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;23.90306,-193.2225;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;105;330.4021,-125.9091;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;518.0461,-60.46124;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;107;783.2668,-5.645473;Inherit;False;float a = 2.51f@$float b = 0.03f@$float c = 2.43f@$float d = 0.59f@$float e = 0.14f@$return$saturate((LinearColor*(a*LinearColor+b))/(LinearColor*(c*LinearColor+d)+e))@;3;False;1;True;LinearColor;FLOAT3;0,0,0;In;;Inherit;False;ACESTonemap;True;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;108;1004.584,-0.395175;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-4354.889,-1641.443;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;110;1179.547,-83.76404;Inherit;False;Property;_ACES;ACES;0;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;36;-4567.021,-1644.783;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1445.28,-273.9578;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ASE/HalfLambertGroundLMP;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;71;0;70;0
WireConnection;71;1;69;1
WireConnection;72;0;71;0
WireConnection;74;0;72;0
WireConnection;74;1;72;1
WireConnection;22;0;21;0
WireConnection;73;0;74;0
WireConnection;73;1;72;2
WireConnection;56;0;73;0
WireConnection;119;0;120;0
WireConnection;1;3;24;0
WireConnection;77;0;57;0
WireConnection;77;1;1;0
WireConnection;151;0;119;0
WireConnection;112;0;77;0
WireConnection;112;1;113;0
WireConnection;114;0;112;0
WireConnection;114;1;115;0
WireConnection;143;0;152;0
WireConnection;143;1;144;0
WireConnection;143;2;145;0
WireConnection;121;0;122;0
WireConnection;121;1;151;0
WireConnection;121;2;127;0
WireConnection;150;0;143;0
WireConnection;131;0;114;0
WireConnection;131;1;121;0
WireConnection;137;0;150;0
WireConnection;137;1;138;0
WireConnection;63;0;3;0
WireConnection;63;1;62;0
WireConnection;116;0;131;0
WireConnection;61;0;4;0
WireConnection;61;1;60;0
WireConnection;154;0;114;0
WireConnection;96;0;63;0
WireConnection;136;0;116;0
WireConnection;136;1;137;0
WireConnection;84;1;71;0
WireConnection;84;0;85;0
WireConnection;93;0;61;0
WireConnection;132;1;154;0
WireConnection;132;0;136;0
WireConnection;78;0;84;0
WireConnection;5;0;94;0
WireConnection;5;1;97;0
WireConnection;5;2;132;0
WireConnection;86;0;79;0
WireConnection;86;1;5;0
WireConnection;105;0;86;0
WireConnection;106;0;105;0
WireConnection;106;1;105;0
WireConnection;107;0;106;0
WireConnection;108;0;107;0
WireConnection;37;0;36;0
WireConnection;110;1;105;0
WireConnection;110;0;108;0
WireConnection;0;13;110;0
ASEEND*/
//CHKSM=3CC2EE5169EC825BB89398C1D7EDAC0E889691C5