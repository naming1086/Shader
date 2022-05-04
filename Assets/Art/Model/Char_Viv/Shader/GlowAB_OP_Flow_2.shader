// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/GlowAB_OP_Flow_2"
{
	Properties
	{
		[Toggle(_UV1_WCONTORLEMISSION_ON)] _UV1_WContorlEmission("UV1_WContorlEmission", Float) = 0
		[Toggle(_UV1_TCONTORLDIS_ON)] _UV1_TContorlDis("UV1_TContorlDis", Float) = 0
		[Toggle(_UV2_WCONTORLOFFSET_ON)] _UV2_WContorlOffset("UV2_WContorlOffset", Float) = 0
		[Toggle(_UV2_TCONTORLFLOW_ON)] _UV2_TContorlFlow("UV2_TContorlFlow", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskTexPanner("MaskTexPanner", Vector) = (0,0,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexPanner("MainTexPanner", Vector) = (0,0,1,0)
		_MainColor("MainColor", Color) = (0,0,0,0)
		_NoiseTex("NoiseTex", 2D) = "black" {}
		_NoiseTexPanner("NoiseTexPanner", Vector) = (0,0,1,0)
		_NoiseEmissionStr("NoiseEmissionStr", Range( 0 , 1)) = 1
		_DisturbTex("DisturbTex", 2D) = "black" {}
		_DisturbPanner("DisturbPanner", Vector) = (0,0,1,0)
		_DisturbTex2("DisturbTex2", 2D) = "white" {}
		_Disturb2Panner("Disturb2Panner", Vector) = (0,0,1,0)
		_MainDisturbStr("MainDisturbStr", Range( 0 , 1)) = 0
		_MaskDisturbStr("MaskDisturbStr", Range( 0 , 1)) = 0
		_DissDisturbStr("DissDisturbStr", Vector) = (0,0,0,0)
		_EmissionStr("EmissionStr", Float) = 1
		_EdgeEmissStr("EdgeEmissStr", Float) = 1
		_InnerEmissRange("InnerEmissRange", Range( 0.5 , 1)) = 0.5
		_InnerEmissHardness("InnerEmissHardness", Range( 0 , 0.49)) = 0.5
		_InnerEmissStr("InnerEmissStr", Float) = 0
		_MainOpacity("MainOpacity", Range( 0 , 1)) = 1
		_DissolutionTex("DissolutionTex", 2D) = "black" {}
		_DissolutionTexPanner("DissolutionTexPanner", Vector) = (0,0,1,0)
		[Toggle(_DISSOLUTIONTEXONEMINUS_ON)] _DissolutionTexOneMinus("DissolutionTexOneMinus", Float) = 0
		_Dissolution("Dissolution", Range( 0 , 1)) = 0.15
		_DissolveHardness("DissolveHardness", Range( 0 , 0.49)) = 0.3935294
		_RampTex("RampTex", 2D) = "white" {}
		_FadeTex("FadeTex", 2D) = "white" {}
		[Toggle(_FREFADEON_ON)] _FreFadeOn("FreFadeOn", Float) = 0
		_Fre("Fre", Vector) = (0,1,2.76,0)
		[Toggle(_VFADE_ON)] _VFade("VFade", Float) = 0
		_FadeRange("FadeRange", Range( -1 , 1)) = 1
		_FadeSoft("FadeSoft", Range( 0.51 , 1)) = 1
		_VertexOffsetTex("VertexOffsetTex", 2D) = "white" {}
		_VertexOffsetTexPanner("VertexOffsetTexPanner", Vector) = (0,0,1,0)
		_VertexOffsetStr("VertexOffsetStr", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		_FlowTex("FlowTex", 2D) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull [_CullMode]
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _VFADE_ON
		#pragma shader_feature_local _UV1_TCONTORLDIS_ON
		#pragma shader_feature_local _UV2_TCONTORLFLOW_ON
		#pragma shader_feature_local _DISSOLUTIONTEXONEMINUS_ON
		#pragma shader_feature_local _UV2_WCONTORLOFFSET_ON
		#pragma shader_feature_local _FREFADEON_ON
		#pragma shader_feature_local _UV1_WCONTORLEMISSION_ON
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
			float4 uv_texcoord;
			float4 uv2_texcoord2;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			half ASEVFace : VFACE;
			INTERNAL_DATA
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

		uniform float _CullMode;
		uniform float _ZTestMode;
		uniform sampler2D _VertexOffsetTex;
		uniform float3 _VertexOffsetTexPanner;
		uniform float4 _VertexOffsetTex_ST;
		uniform float _VertexOffsetStr;
		uniform float _FadeSoft;
		uniform float _FadeRange;
		uniform sampler2D _MaskTex;
		uniform float3 _MaskTexPanner;
		uniform float4 _MaskTex_ST;
		uniform sampler2D _DisturbTex2;
		uniform float3 _Disturb2Panner;
		uniform float4 _DisturbTex2_ST;
		uniform float _Dissolution;
		uniform sampler2D _DisturbTex;
		uniform float3 _DisturbPanner;
		uniform float4 _DisturbTex_ST;
		uniform float _MaskDisturbStr;
		uniform sampler2D _FlowTex;
		uniform float4 _FlowTex_ST;
		uniform sampler2D _RampTex;
		uniform float _DissolveHardness;
		uniform sampler2D _DissolutionTex;
		uniform float3 _DissolutionTexPanner;
		uniform float4 _DissolutionTex_ST;
		uniform float2 _DissDisturbStr;
		uniform sampler2D _FadeTex;
		uniform float4 _FadeTex_ST;
		uniform float _MainOpacity;
		uniform float3 _Fre;
		uniform sampler2D _NoiseTex;
		uniform float3 _NoiseTexPanner;
		uniform float4 _NoiseTex_ST;
		uniform float _NoiseEmissionStr;
		uniform float _InnerEmissHardness;
		uniform sampler2D _MainTex;
		uniform float3 _MainTexPanner;
		uniform float4 _MainTex_ST;
		uniform float _MainDisturbStr;
		uniform float _InnerEmissRange;
		uniform float _InnerEmissStr;
		uniform float _EdgeEmissStr;
		uniform float4 _MainColor;
		uniform float _EmissionStr;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime130 = _Time.y * _VertexOffsetTexPanner.z;
			float2 appendResult128 = (float2(_VertexOffsetTexPanner.x , _VertexOffsetTexPanner.y));
			float4 uvs_VertexOffsetTex = v.texcoord;
			uvs_VertexOffsetTex.xy = v.texcoord.xy * _VertexOffsetTex_ST.xy + _VertexOffsetTex_ST.zw;
			float2 panner131 = ( mulTime130 * appendResult128 + uvs_VertexOffsetTex.xy);
			float3 ase_vertexNormal = v.normal.xyz;
			float smoothstepResult256 = smoothstep( _FadeSoft , ( 1.0 - _FadeSoft ) , saturate( ( v.texcoord.xy.y - _FadeRange ) ));
			#ifdef _VFADE_ON
				float staticSwitch51 = saturate( smoothstepResult256 );
			#else
				float staticSwitch51 = 1.0;
			#endif
			float VFade214 = staticSwitch51;
			float3 VertexOffset137 = ( tex2Dlod( _VertexOffsetTex, float4( panner131, 0, 0.0) ).r * ase_vertexNormal * 0.1 * _VertexOffsetStr * ( 1.0 - VFade214 ) );
			v.vertex.xyz += VertexOffset137;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float mulTime272 = _Time.y * _MaskTexPanner.z;
			float2 appendResult271 = (float2(_MaskTexPanner.x , _MaskTexPanner.y));
			float4 uvs_MaskTex = i.uv_texcoord;
			uvs_MaskTex.xy = i.uv_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float2 panner274 = ( mulTime272 * appendResult271 + uvs_MaskTex.xy);
			float mulTime219 = _Time.y * _Disturb2Panner.z;
			float2 appendResult220 = (float2(_Disturb2Panner.x , _Disturb2Panner.y));
			float4 uvs_DisturbTex2 = i.uv_texcoord;
			uvs_DisturbTex2.xy = i.uv_texcoord.xy * _DisturbTex2_ST.xy + _DisturbTex2_ST.zw;
			float2 panner222 = ( mulTime219 * appendResult220 + uvs_DisturbTex2.xy);
			#ifdef _UV1_TCONTORLDIS_ON
				float staticSwitch23 = i.uv_texcoord.w;
			#else
				float staticSwitch23 = _Dissolution;
			#endif
			float UV1_T83 = staticSwitch23;
			float DisturbColor2217 = ( tex2D( _DisturbTex2, panner222 ).r * UV1_T83 );
			float mulTime153 = _Time.y * _DisturbPanner.z;
			float2 appendResult154 = (float2(_DisturbPanner.x , _DisturbPanner.y));
			float4 uvs_DisturbTex = i.uv_texcoord;
			uvs_DisturbTex.xy = i.uv_texcoord.xy * _DisturbTex_ST.xy + _DisturbTex_ST.zw;
			float2 panner156 = ( mulTime153 * appendResult154 + uvs_DisturbTex.xy);
			float DisturbColor151 = ( tex2D( _DisturbTex, panner156 ).r * UV1_T83 );
			float4 uvs_FlowTex = i.uv_texcoord;
			uvs_FlowTex.xy = i.uv_texcoord.xy * _FlowTex_ST.xy + _FlowTex_ST.zw;
			float4 tex2DNode240 = tex2D( _FlowTex, uvs_FlowTex.xy );
			float2 appendResult242 = (float2(tex2DNode240.r , tex2DNode240.g));
			float2 FlowUV335 = appendResult242;
			#ifdef _UV2_TCONTORLFLOW_ON
				float staticSwitch304 = i.uv2_texcoord2.w;
			#else
				float staticSwitch304 = 0.0;
			#endif
			float UV2_T307 = staticSwitch304;
			float2 lerpResult239 = lerp( ( panner274 + ( ( DisturbColor2217 + DisturbColor151 ) * _MaskDisturbStr ) ) , FlowUV335 , UV2_T307);
			float MaskColor174 = tex2D( _MaskTex, lerpResult239 ).r;
			float mulTime122 = _Time.y * _DissolutionTexPanner.z;
			float2 appendResult121 = (float2(_DissolutionTexPanner.x , _DissolutionTexPanner.y));
			float4 uvs_DissolutionTex = i.uv_texcoord;
			uvs_DissolutionTex.xy = i.uv_texcoord.xy * _DissolutionTex_ST.xy + _DissolutionTex_ST.zw;
			float2 lerpResult317 = lerp( uvs_DissolutionTex.xy , FlowUV335 , saturate( UV2_T307 ));
			float2 panner124 = ( mulTime122 * appendResult121 + lerpResult317);
			#ifdef _UV2_WCONTORLOFFSET_ON
				float staticSwitch53 = i.uv2_texcoord2.z;
			#else
				float staticSwitch53 = 0.0;
			#endif
			float2 appendResult283 = (float2(0.0 , staticSwitch53));
			float2 UV2_W279 = appendResult283;
			float4 tex2DNode102 = tex2D( _DissolutionTex, ( panner124 + ( DisturbColor2217 * _DissDisturbStr ) + UV2_W279 ) );
			#ifdef _DISSOLUTIONTEXONEMINUS_ON
				float staticSwitch260 = ( 1.0 - tex2DNode102.r );
			#else
				float staticSwitch260 = tex2DNode102.r;
			#endif
			float smoothstepResult9 = smoothstep( ( 1.0 - _DissolveHardness ) , _DissolveHardness , saturate( ( staticSwitch260 + 1.0 + ( UV1_T83 * -2.0 ) ) ));
			float2 appendResult113 = (float2(smoothstepResult9 , 0.0));
			float4 tex2DNode114 = tex2D( _RampTex, appendResult113 );
			float DissolutionValue147 = tex2DNode114.a;
			float lerpResult112 = lerp( 0.0 , MaskColor174 , DissolutionValue147);
			float smoothstepResult256 = smoothstep( _FadeSoft , ( 1.0 - _FadeSoft ) , saturate( ( i.uv_texcoord.xy.y - _FadeRange ) ));
			#ifdef _VFADE_ON
				float staticSwitch51 = saturate( smoothstepResult256 );
			#else
				float staticSwitch51 = 1.0;
			#endif
			float VFade214 = staticSwitch51;
			float VertexColorA77 = i.vertexColor.a;
			float2 uv_FadeTex = i.uv_texcoord * _FadeTex_ST.xy + _FadeTex_ST.zw;
			float FadeTexR142 = tex2D( _FadeTex, uv_FadeTex ).r;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 break297 = ase_worldNormal;
			float3 appendResult299 = (float3(break297.x , break297.y , -break297.z));
			float3 switchResult294 = (((i.ASEVFace>0)?(ase_worldNormal):(appendResult299)));
			float3 WorldNormal300 = switchResult294;
			float fresnelNdotV233 = dot( WorldNormal300, ase_worldViewDir );
			float fresnelNode233 = ( _Fre.x + _Fre.y * pow( 1.0 - fresnelNdotV233, _Fre.z ) );
			#ifdef _FREFADEON_ON
				float staticSwitch333 = saturate( ( 1.0 - fresnelNode233 ) );
			#else
				float staticSwitch333 = 1.0;
			#endif
			float FreFade292 = staticSwitch333;
			float FinalOpacity95 = ( saturate( ( lerpResult112 * VFade214 * VertexColorA77 * FadeTexR142 ) ) * _MainOpacity * FreFade292 );
			float mulTime349 = _Time.y * _NoiseTexPanner.z;
			float2 appendResult347 = (float2(_NoiseTexPanner.x , _NoiseTexPanner.y));
			float4 uvs_NoiseTex = i.uv_texcoord;
			uvs_NoiseTex.xy = i.uv_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner57 = ( mulTime349 * appendResult347 + uvs_NoiseTex.xy);
			float3 temp_output_345_0 = (tex2D( _NoiseTex, ( panner57 + UV2_W279 ) )).rgb;
			float3 NoiseColor359 = saturate( ( temp_output_345_0 * _NoiseEmissionStr ) );
			float mulTime31 = _Time.y * _MainTexPanner.z;
			float2 appendResult30 = (float2(_MainTexPanner.x , _MainTexPanner.y));
			float4 uvs_MainTex = i.uv_texcoord;
			uvs_MainTex.xy = i.uv_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner27 = ( mulTime31 * appendResult30 + uvs_MainTex.xy);
			float4 tex2DNode1 = tex2D( _MainTex, ( ( panner27 + UV2_W279 ) + ( DisturbColor151 * _MainDisturbStr ) ) );
			float MainTexR68 = tex2DNode1.r;
			float lerpResult223 = lerp( 0.0 , MainTexR68 , MaskColor174);
			float MainTexColor198 = lerpResult223;
			float smoothstepResult186 = smoothstep( _InnerEmissHardness , ( 1.0 - _InnerEmissHardness ) , ( ( MainTexColor198 * VFade214 * FadeTexR142 ) + 1.0 + ( -2.0 * _InnerEmissRange ) ));
			float InnerEmissColor276 = saturate( ( saturate( smoothstepResult186 ) * _InnerEmissStr ) );
			float DissolutionEdgeColor323 = ( tex2DNode114.r * _EdgeEmissStr );
			float4 FinalColor91 = ( float4( NoiseColor359 , 0.0 ) + InnerEmissColor276 + DissolutionEdgeColor323 + _MainColor );
			float4 VertexColorRGB75 = i.vertexColor;
			#ifdef _UV1_WCONTORLEMISSION_ON
				float staticSwitch21 = i.uv_texcoord.z;
			#else
				float staticSwitch21 = 1.0;
			#endif
			float UV1_W82 = staticSwitch21;
			c.rgb = ( FinalColor91 * _EmissionStr * VertexColorRGB75 * UV1_W82 ).rgb;
			c.a = FinalOpacity95;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 

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
				float4 customPack1 : TEXCOORD1;
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
				o.customPack1.xyzw = customInputData.uv_texcoord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_texcoord2;
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
				surfIN.uv_texcoord = IN.customPack1.xyzw;
				surfIN.uv2_texcoord2 = IN.customPack2.xyzw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
Version=18935
111;259;1916;914;8990.169;4814.963;3.120327;True;True
Node;AmplifyShaderEditor.CommentaryNode;93;-10751.08,-7006.982;Inherit;False;1252.226;378.732;UV1;7;23;83;5;82;21;22;20;UV1;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;157;-2758.383,-6716.603;Inherit;False;2432.565;958.0535;DisturbColor;17;151;150;156;155;154;153;152;216;217;218;219;220;221;222;288;289;290;DisturbColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-10701.08,-6930.251;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;218;-2718.074,-6148.832;Inherit;False;Property;_Disturb2Panner;Disturb2Panner;16;0;Create;True;0;0;0;False;0;False;0,0,1;-0.1,0.1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;5;-10466.51,-6733.193;Inherit;False;Property;_Dissolution;Dissolution;30;0;Create;True;0;0;0;False;0;False;0.15;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;152;-2708.383,-6513.603;Inherit;False;Property;_DisturbPanner;DisturbPanner;14;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;154;-2486.387,-6498.603;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;155;-2656.388,-6666.603;Inherit;False;0;150;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;221;-2666.071,-6301.832;Inherit;False;0;216;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;219;-2510.351,-6014.045;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;23;-10055.49,-6792.749;Inherit;False;Property;_UV1_TContorlDis;UV1_TContorlDis;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;220;-2496.07,-6133.832;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;153;-2500.668,-6378.816;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;156;-2312.587,-6497.798;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-9735.853,-6790.203;Inherit;False;UV1_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;222;-2373.561,-6169.28;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;150;-1975.659,-6516.343;Inherit;True;Property;_DisturbTex;DisturbTex;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;281;-10755.17,-6493.567;Inherit;False;1220.367;507.373;UV2;8;279;53;38;54;283;304;306;307;UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;-1888.23,-6308.526;Inherit;False;83;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;216;-1972.746,-6091.697;Inherit;True;Property;_DisturbTex2;DisturbTex2;15;0;Create;True;0;0;0;False;0;False;-1;None;fbc3838bc4ef5ae41a4d28a16705f90c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-10636.56,-6443.567;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-1508.75,-6143.479;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-10705.17,-6346.06;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-1524.191,-6471.786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;337;-9083.081,-7574.223;Inherit;False;1205.293;341.0229;FlowUV;4;340;335;242;240;FlowUV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-1272.042,-6149.036;Inherit;False;DisturbColor2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;53;-10313.72,-6365.859;Inherit;False;Property;_UV2_WContorlOffset;UV2_WContorlOffset;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-1294.079,-6476.935;Inherit;False;DisturbColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-8993.868,-7501.629;Inherit;False;0;240;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;80;-6159.677,-6718.776;Inherit;False;3039.506;1382.294;MainTex;20;172;70;68;69;1;168;171;170;27;31;28;30;29;175;197;198;223;224;280;284;MainTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-10598.32,-6173.96;Inherit;False;Constant;_Float10;Float 10;45;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;176;-8774.923,-6736.54;Inherit;False;2398.331;982.6518;MaskColor;17;271;272;270;274;145;174;239;160;169;164;269;161;268;159;310;325;336;MaskColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-8623.227,-6401.376;Inherit;False;217;DisturbColor2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;29;-6149.418,-6490.255;Inherit;False;Property;_MainTexPanner;MainTexPanner;8;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;268;-8616.197,-6312.442;Inherit;False;151;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;304;-10292.77,-6175.163;Inherit;False;Property;_UV2_TContorlFlow;UV2_TContorlFlow;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;283;-10010.4,-6356.947;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;270;-8709.729,-6570.641;Inherit;False;Property;_MaskTexPanner;MaskTexPanner;6;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;240;-8709.045,-7524.223;Inherit;True;Property;_FlowTex;FlowTex;44;0;Create;True;0;0;0;False;0;False;-1;None;5b52baa476bef1d47b294bb0f4295051;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;269;-8399.198,-6358.442;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-8582.521,-6210.646;Inherit;False;Property;_MaskDisturbStr;MaskDisturbStr;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-5936.299,-6361.059;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;149;-8789.349,-3935.397;Inherit;False;4665.602;1472.834;DissolutionColor;21;147;113;114;259;243;102;207;286;208;124;121;317;206;122;319;123;120;339;318;358;361;DissolutionColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;272;-8437.477,-6468.002;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;159;-8708.65,-6696.738;Inherit;False;0;145;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-6097.821,-6626.716;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;279;-9841.972,-6360.323;Inherit;False;UV2_W;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-5923.59,-6487.35;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-9881.901,-6169.675;Inherit;False;UV2_T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;242;-8370.961,-7502.025;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;271;-8398.992,-6566.231;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;94;-8766.645,-1851.304;Inherit;False;4086.331;2762.116;Comment;24;235;236;234;233;238;201;98;95;101;6;100;89;97;112;248;215;261;148;250;249;292;301;333;334;FinalOpacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;318;-8737,-3519.597;Inherit;False;307;UV2_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-5843.898,-6196.548;Inherit;False;Property;_MainDisturbStr;MainDisturbStr;17;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;249;-8644.638,-953.2382;Inherit;False;1753.437;485.2474;VFade;12;214;51;44;40;43;39;52;49;254;255;256;257;VFade;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;27;-5727.425,-6607.735;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;-5693.478,-6461.315;Inherit;False;279;UV2_W;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-5772.662,-6302.651;Inherit;False;151;DisturbColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;335;-8101.788,-7505.58;Inherit;False;FlowUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;274;-8150.775,-6563.395;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-8234.301,-6346.617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;123;-8659.917,-3829.86;Inherit;False;0;102;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;120;-8701.295,-3408.667;Inherit;False;Property;_DissolutionTexPanner;DissolutionTexPanner;28;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;319;-8558.536,-3516.197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-7959.093,-6325.852;Inherit;False;307;UV2_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-5531.678,-6281.67;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-8608.769,-901.7766;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;336;-7887.287,-6128.442;Inherit;False;335;FlowUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;339;-8663.294,-3644.501;Inherit;False;335;FlowUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;-5451.327,-6553.955;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;160;-7885.072,-6529.539;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-8603.244,-727.4924;Inherit;False;Property;_FadeRange;FadeRange;37;0;Create;True;0;0;0;False;0;False;1;1.51;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-8251.944,-591.0356;Inherit;False;Property;_FadeSoft;FadeSoft;38;0;Create;True;0;0;0;False;0;False;1;1;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-8443.674,-3395.868;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;122;-8456.606,-3278.966;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;-8608.515,-3156.015;Inherit;False;217;DisturbColor2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;-5198.811,-6469.142;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;361;-8586.227,-3025.051;Inherit;False;Property;_DissDisturbStr;DissDisturbStr;19;0;Create;True;0;0;0;False;0;False;0,0;0,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-8211.147,-837.2479;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;317;-8380.031,-3688.221;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;239;-7671.438,-6520.953;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;286;-8043.026,-2886.189;Inherit;False;279;UV2_W;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;254;-7928.74,-839.9985;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-4864.943,-6495.388;Inherit;True;Property;_MainTex;MainTex;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;257;-7934.887,-557.6672;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-8283.225,-3137.635;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;124;-7975.405,-3564.99;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;145;-7382.15,-6547.173;Inherit;True;Property;_MaskTex;MaskTex;5;0;Create;True;0;0;0;False;0;False;-1;None;5993b1a8a23cc4a4a947ae39e2c062ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;207;-7736.256,-3531.292;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;320;-10731.22,-4629.169;Inherit;False;1191.495;397.0473;WorldNormal;7;295;298;300;294;297;293;299;WorldNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;256;-7756.789,-820.2617;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-7015.337,-6529.794;Inherit;False;MaskColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-4458.021,-6636.262;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-4131.135,-6658.667;Inherit;False;Constant;_Float4;Float 4;40;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-4133.49,-6427.227;Inherit;True;68;MainTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;295;-10681.22,-4415.122;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;255;-7527.665,-820.6756;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;243;-6847.826,-3824.337;Inherit;False;1116.599;742.8235;DissolutionControl;12;13;9;111;105;106;210;84;244;245;247;260;321;DissolutionControl;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;102;-7566.15,-3558.559;Inherit;True;Property;_DissolutionTex;DissolutionTex;27;0;Create;True;0;0;0;False;0;False;-1;None;20f56775e4c071d47ab0300da9a51cd4;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;250;-8633.091,-278.3184;Inherit;False;591.877;280;FadeTex;2;119;142;FadeTex;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-7576.542,-907.9476;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-4141.094,-6223.952;Inherit;True;174;MaskColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-6835.071,-3328.208;Inherit;False;Constant;_DisStr;DisStr;28;0;Create;True;0;0;0;False;0;False;-2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;90;-42.98927,-6699.712;Inherit;False;2960.94;1487.782;NoiseColor;22;57;179;66;211;55;199;180;67;331;345;349;347;346;348;350;352;353;354;355;359;362;363;NoiseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;297;-10449.23,-4410.122;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;84;-6866.396,-3429.86;Inherit;False;83;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;223;-3832.936,-6427.978;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;51;-7355.613,-881.5217;Inherit;False;Property;_VFade;VFade;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;119;-8564.251,-218.8987;Inherit;True;Property;_FadeTex;FadeTex;33;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;259;-7133.292,-3562.493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-6695.66,-3538.192;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;298;-10305.23,-4357.122;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;-3501.093,-6434.574;Inherit;True;MainTexColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;275;-8778.882,-5385.905;Inherit;False;2093.223;763.0426;InnerEmissColor;16;189;191;190;186;205;264;265;213;187;182;267;266;212;276;278;364;InnerEmissColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;346;-13.6645,-6369.481;Inherit;False;Property;_NoiseTexPanner;NoiseTexPanner;11;0;Create;True;0;0;0;False;0;False;0,0,1;0,0.1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-8241.664,-210.5093;Inherit;False;FadeTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;260;-6745.659,-3729.455;Inherit;False;Property;_DissolutionTexOneMinus;DissolutionTexOneMinus;29;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-6594.943,-3401.219;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;214;-7129.333,-882.0496;Inherit;False;VFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-6378.836,-3717.112;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;-8720.709,-5138.897;Inherit;False;214;VFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-6543.491,-3274.076;Inherit;False;Property;_DissolveHardness;DissolveHardness;31;0;Create;True;0;0;0;False;0;False;0.3935294;0.2;0;0.49;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-8518.732,-4987.116;Inherit;False;Constant;_Float5;Float 5;42;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;349;204.5171,-6245.342;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;267;-8620.31,-4894.557;Inherit;False;Property;_InnerEmissRange;InnerEmissRange;22;0;Create;True;0;0;0;False;0;False;0.5;0.5;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-8746.375,-5333.795;Inherit;True;198;MainTexColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;-8711.823,-5049.807;Inherit;False;142;FadeTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;299;-10167.23,-4415.122;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;347;222.4183,-6380.353;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;348;1.401584,-6570.565;Inherit;False;0;55;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;293;-10376.6,-4579.169;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;350;332.1682,-6121.295;Inherit;False;279;UV2_W;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwitchByFaceNode;294;-9966.531,-4511.371;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;-8481.272,-5321.592;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;244;-6152.104,-3564.553;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-8541.063,-4802.255;Inherit;False;Property;_InnerEmissHardness;InnerEmissHardness;23;0;Create;True;0;0;0;False;0;False;0.5;0.49;0;0.49;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;-8307.308,-4952.557;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;245;-6173.195,-3691.66;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;446.5211,-6358.498;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;-8194.638,-5241.068;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-5973.875,-3597.546;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;205;-8190.864,-4781.874;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;300;-9763.729,-4515.727;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;352;625.5955,-6312.377;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;186;-7939.218,-5099.506;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-8623.515,301.3054;Inherit;False;300;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;238;-8624.8,449.5911;Inherit;False;Property;_Fre;Fre;35;0;Create;True;0;0;0;False;0;False;0,1,2.76;0,1,5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;55;756.9398,-6338.356;Inherit;True;Property;_NoiseTex;NoiseTex;10;0;Create;True;0;0;0;False;0;False;-1;None;366d45e960c8c7c4195edae3195a2a69;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;113;-5713.753,-3599.045;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;67;819.0179,-6105.796;Inherit;False;Property;_NoiseEmissionStr;NoiseEmissionStr;12;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;191;-7639.713,-5089.501;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-5481.817,-3629.861;Inherit;True;Property;_RampTex;RampTex;32;0;Create;True;0;0;0;False;0;False;-1;None;391c4cc7e989ad340a4a005177c40824;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;233;-8349.48,324.5802;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;358;-5126.156,-3691.233;Inherit;False;906.5498;346.3657;DissolutionEdgeColor;3;323;327;328;DissolutionEdgeColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;345;1087.997,-6336.291;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-7652.725,-4853.747;Inherit;False;Property;_InnerEmissStr;InnerEmissStr;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-10751,-5806.02;Inherit;False;498.0005;281.3341;VertexColor;3;75;77;24;VertexColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;24;-10678,-5756.021;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;234;-8010.363,278.0772;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-7407.929,-5086.507;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;362;1460.167,-6367.663;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;144;-4493.381,-1831.603;Inherit;False;1891.678;1053.213;VertexOffset;17;127;129;130;128;139;131;140;143;134;126;132;136;133;137;341;342;343;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;328;-5076.625,-3493.239;Inherit;False;Property;_EdgeEmissStr;EdgeEmissStr;21;0;Create;True;0;0;0;False;0;False;1;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-4805.421,-3185.32;Inherit;True;DissolutionValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-10459.32,-5640.686;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;236;-7856.104,256.2803;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-8511.84,-1340.621;Inherit;True;147;DissolutionValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;363;1672.224,-6382.124;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;127;-4413.48,-1618.82;Inherit;False;Property;_VertexOffsetTexPanner;VertexOffsetTexPanner;40;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;364;-7181.257,-5075.84;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;261;-8511.326,-1561.156;Inherit;False;174;MaskColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;-4844.247,-3626.858;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;334;-7820.341,341.208;Inherit;False;Constant;_Float12;Float 12;47;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;248;-7734.059,-1341.153;Inherit;False;142;FadeTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-7740.26,-1561.769;Inherit;False;77;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;130;-4123.485,-1519.604;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;333;-7567.341,262.208;Inherit;False;Property;_FreFadeOn;FreFadeOn;34;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-4491.409,-3639.548;Inherit;True;DissolutionEdgeColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;276;-6990.397,-5091.84;Inherit;False;InnerEmissColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;359;1985.639,-6394.899;Inherit;False;NoiseColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;215;-7742.632,-1776.637;Inherit;False;214;VFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;128;-4128.831,-1621.255;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;112;-8007.868,-1575.084;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-4259.487,-1781.603;Inherit;False;0;126;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-7442.203,-1601.436;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;343;-3549.725,-829.7899;Inherit;True;214;VFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;360;3010.174,-6499.397;Inherit;True;359;NoiseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-10437.56,-6956.982;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;131;-3873.178,-1628.511;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;3008.138,-6270.78;Inherit;True;276;InnerEmissColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;3006.964,-6050.753;Inherit;True;323;DissolutionEdgeColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;-7271.004,251.0252;Inherit;False;FreFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;3011.352,-5828.396;Inherit;False;Property;_MainColor;MainColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;126;-3633.63,-1655.746;Inherit;True;Property;_VertexOffsetTex;VertexOffsetTex;39;0;Create;True;0;0;0;False;0;False;-1;None;efccf27a2e7dd4a4c9a7b81f565bc7df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;100;-7191.946,-1522.662;Inherit;False;Property;_MainOpacity;MainOpacity;26;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;132;-3511.646,-1437.301;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;134;-3581.084,-1277.267;Inherit;False;Constant;_Float7;Float 7;25;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-3595.084,-1170.266;Inherit;False;Property;_VertexOffsetStr;VertexOffsetStr;41;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;332;-7130.748,-1371.304;Inherit;False;292;FreFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;6;-7101.62,-1618.872;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;3455.048,-6276.91;Inherit;True;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;342;-3270.754,-912.699;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;21;-10065.96,-6951.082;Inherit;False;Property;_UV1_WContorlEmission;UV1_WContorlEmission;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-6832.32,-1634.869;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;3704.667,-6288.607;Inherit;True;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-9730.559,-6951.026;Inherit;False;UV1_W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-10461,-5747.114;Inherit;False;VertexColorRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-3155.187,-1483.367;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-2820.213,-1491.456;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;665.5414,-3057.317;Inherit;False;91;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;696.127,-2865.582;Inherit;False;Property;_EmissionStr;EmissionStr;20;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;674.0911,-2645.32;Inherit;False;75;VertexColorRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-6552.768,-1638.505;Inherit;True;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;685.8074,-2450.114;Inherit;False;82;UV1_W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-10741.43,-5352.791;Inherit;False;448;277.753;Enum;3;36;37;141;Enum;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-4455.446,-6410.005;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-8506.464,-1791.009;Inherit;True;198;MainTexColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;341;-3279.874,-1106.724;Inherit;False;-1;;1;0;OBJECT;;False;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;-7766.728,444.67;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;355;1295.786,-5744.953;Inherit;False;Constant;_Float14;Float 14;45;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;354;1110.022,-5986.793;Inherit;False;Constant;_Float13;Float 13;45;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;1268.557,-6183.536;Inherit;False;Constant;_Float6;Float 6;33;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;-7976.553,-6230.777;Inherit;False;Constant;_Float11;Float 11;45;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;1085.788,-6089.807;Inherit;False;198;MainTexColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-8357.351,-901.1706;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1498.327,-5780.967;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-3995.178,-1081.595;Inherit;False;83;UV1_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;1004.562,-3189.657;Inherit;True;95;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;1496.524,-6151.247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;179;1689.611,-6138.912;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;357;-4089.361,-5999.559;Inherit;False;-1;;1;0;OBJECT;;False;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;321;-6805.96,-3435.389;Inherit;False;Constant;_Float9;Float 9;45;0;Create;True;0;0;0;False;0;False;0.23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;140;-3749.575,-1076.902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-4454.919,-6178.32;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-8245.429,-1786.943;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-3606.794,-1023.492;Inherit;True;142;FadeTexR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;1060.667,-2639.661;Inherit;False;137;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-6853.904,-3537.241;Inherit;False;Constant;_Float8;Float 8;42;0;Create;True;0;0;0;False;0;False;0.57;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;-3360.433,-951.4795;Inherit;False;-1;;1;0;OBJECT;;False;1;OBJECT;0
Node;AmplifyShaderEditor.GetLocalVarNode;331;1701.36,-5563.344;Inherit;True;307;UV2_T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;1061.915,-2902.076;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;353;1354.858,-6033.887;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-10710.95,-5289.792;Inherit;False;Property;_CullMode;CullMode;4;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-10714.43,-5192.036;Inherit;False;Property;_ZTestMode;ZTestMode;43;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-10538.16,-5287.195;Inherit;False;Property;_ZWriteMode;ZWriteMode;42;1;[Enum];Create;True;0;2;ZWriteOn;2;ZWriteOff;1;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1513.751,-3215.427;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/GlowAB_OP_Flow_2;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;141;0;True;37;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;25;-1;-1;-1;0;False;0;0;True;36;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;154;0;152;1
WireConnection;154;1;152;2
WireConnection;219;0;218;3
WireConnection;23;1;5;0
WireConnection;23;0;20;4
WireConnection;220;0;218;1
WireConnection;220;1;218;2
WireConnection;153;0;152;3
WireConnection;156;0;155;0
WireConnection;156;2;154;0
WireConnection;156;1;153;0
WireConnection;83;0;23;0
WireConnection;222;0;221;0
WireConnection;222;2;220;0
WireConnection;222;1;219;0
WireConnection;150;1;156;0
WireConnection;216;1;222;0
WireConnection;290;0;216;1
WireConnection;290;1;288;0
WireConnection;289;0;150;1
WireConnection;289;1;288;0
WireConnection;217;0;290;0
WireConnection;53;1;54;0
WireConnection;53;0;38;3
WireConnection;151;0;289;0
WireConnection;304;1;306;0
WireConnection;304;0;38;4
WireConnection;283;1;53;0
WireConnection;240;1;340;0
WireConnection;269;0;161;0
WireConnection;269;1;268;0
WireConnection;31;0;29;3
WireConnection;272;0;270;3
WireConnection;279;0;283;0
WireConnection;30;0;29;1
WireConnection;30;1;29;2
WireConnection;307;0;304;0
WireConnection;242;0;240;1
WireConnection;242;1;240;2
WireConnection;271;0;270;1
WireConnection;271;1;270;2
WireConnection;27;0;28;0
WireConnection;27;2;30;0
WireConnection;27;1;31;0
WireConnection;335;0;242;0
WireConnection;274;0;159;0
WireConnection;274;2;271;0
WireConnection;274;1;272;0
WireConnection;169;0;269;0
WireConnection;169;1;164;0
WireConnection;319;0;318;0
WireConnection;171;0;170;0
WireConnection;171;1;172;0
WireConnection;284;0;27;0
WireConnection;284;1;280;0
WireConnection;160;0;274;0
WireConnection;160;1;169;0
WireConnection;121;0;120;1
WireConnection;121;1;120;2
WireConnection;122;0;120;3
WireConnection;168;0;284;0
WireConnection;168;1;171;0
WireConnection;44;0;39;2
WireConnection;44;1;43;0
WireConnection;317;0;123;0
WireConnection;317;1;339;0
WireConnection;317;2;319;0
WireConnection;239;0;160;0
WireConnection;239;1;336;0
WireConnection;239;2;310;0
WireConnection;254;0;44;0
WireConnection;1;1;168;0
WireConnection;257;0;49;0
WireConnection;208;0;206;0
WireConnection;208;1;361;0
WireConnection;124;0;317;0
WireConnection;124;2;121;0
WireConnection;124;1;122;0
WireConnection;145;1;239;0
WireConnection;207;0;124;0
WireConnection;207;1;208;0
WireConnection;207;2;286;0
WireConnection;256;0;254;0
WireConnection;256;1;49;0
WireConnection;256;2;257;0
WireConnection;174;0;145;1
WireConnection;68;0;1;1
WireConnection;255;0;256;0
WireConnection;102;1;207;0
WireConnection;297;0;295;0
WireConnection;223;0;224;0
WireConnection;223;1;197;0
WireConnection;223;2;175;0
WireConnection;51;1;52;0
WireConnection;51;0;255;0
WireConnection;259;0;102;1
WireConnection;298;0;297;2
WireConnection;198;0;223;0
WireConnection;142;0;119;1
WireConnection;260;1;102;1
WireConnection;260;0;259;0
WireConnection;106;0;84;0
WireConnection;106;1;210;0
WireConnection;214;0;51;0
WireConnection;111;0;260;0
WireConnection;111;1;105;0
WireConnection;111;2;106;0
WireConnection;349;0;346;3
WireConnection;299;0;297;0
WireConnection;299;1;297;1
WireConnection;299;2;298;0
WireConnection;347;0;346;1
WireConnection;347;1;346;2
WireConnection;294;0;293;0
WireConnection;294;1;299;0
WireConnection;213;0;182;0
WireConnection;213;1;278;0
WireConnection;213;2;212;0
WireConnection;244;0;13;0
WireConnection;265;0;266;0
WireConnection;265;1;267;0
WireConnection;245;0;111;0
WireConnection;57;0;348;0
WireConnection;57;2;347;0
WireConnection;57;1;349;0
WireConnection;264;0;213;0
WireConnection;264;2;265;0
WireConnection;9;0;245;0
WireConnection;9;1;244;0
WireConnection;9;2;13;0
WireConnection;205;0;187;0
WireConnection;300;0;294;0
WireConnection;352;0;57;0
WireConnection;352;1;350;0
WireConnection;186;0;264;0
WireConnection;186;1;187;0
WireConnection;186;2;205;0
WireConnection;55;1;352;0
WireConnection;113;0;9;0
WireConnection;191;0;186;0
WireConnection;114;1;113;0
WireConnection;233;0;301;0
WireConnection;233;1;238;1
WireConnection;233;2;238;2
WireConnection;233;3;238;3
WireConnection;345;0;55;0
WireConnection;234;0;233;0
WireConnection;189;0;191;0
WireConnection;189;1;190;0
WireConnection;362;0;345;0
WireConnection;362;1;67;0
WireConnection;147;0;114;4
WireConnection;77;0;24;4
WireConnection;236;0;234;0
WireConnection;363;0;362;0
WireConnection;364;0;189;0
WireConnection;327;0;114;1
WireConnection;327;1;328;0
WireConnection;130;0;127;3
WireConnection;333;1;334;0
WireConnection;333;0;236;0
WireConnection;323;0;327;0
WireConnection;276;0;364;0
WireConnection;359;0;363;0
WireConnection;128;0;127;1
WireConnection;128;1;127;2
WireConnection;112;1;261;0
WireConnection;112;2;148;0
WireConnection;89;0;112;0
WireConnection;89;1;215;0
WireConnection;89;2;97;0
WireConnection;89;3;248;0
WireConnection;131;0;129;0
WireConnection;131;2;128;0
WireConnection;131;1;130;0
WireConnection;292;0;333;0
WireConnection;126;1;131;0
WireConnection;6;0;89;0
WireConnection;65;0;360;0
WireConnection;65;1;277;0
WireConnection;65;2;324;0
WireConnection;65;3;16;0
WireConnection;342;0;343;0
WireConnection;21;1;22;0
WireConnection;21;0;20;3
WireConnection;101;0;6;0
WireConnection;101;1;100;0
WireConnection;101;2;332;0
WireConnection;91;0;65;0
WireConnection;82;0;21;0
WireConnection;75;0;24;0
WireConnection;133;0;126;1
WireConnection;133;1;132;0
WireConnection;133;2;134;0
WireConnection;133;3;136;0
WireConnection;133;4;342;0
WireConnection;137;0;133;0
WireConnection;95;0;101;0
WireConnection;69;0;1;2
WireConnection;66;1;355;0
WireConnection;211;0;180;0
WireConnection;211;1;199;0
WireConnection;179;0;211;0
WireConnection;179;1;353;0
WireConnection;179;2;199;0
WireConnection;140;0;139;0
WireConnection;70;0;1;3
WireConnection;98;0;201;0
WireConnection;15;0;92;0
WireConnection;15;1;17;0
WireConnection;15;2;78;0
WireConnection;15;3;85;0
WireConnection;353;0;345;0
WireConnection;353;1;354;0
WireConnection;353;2;67;0
WireConnection;0;9;96;0
WireConnection;0;13;15;0
WireConnection;0;11;138;0
ASEEND*/
//CHKSM=AB3B55D22057CF5904BED4966E6F686BB6007A26