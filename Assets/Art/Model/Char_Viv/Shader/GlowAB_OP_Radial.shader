// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Whl/Viv/GlowAB_OP_Radial"
{
	Properties
	{
		[Toggle(_UV_WCONTORLEMISSION_ON)] _UV_WContorlEmission("UV_WContorlEmission", Float) = 0
		[Toggle(_UV2_WCONTORLOFFSET_ON)] _UV2_WContorlOffset("UV2_WContorlOffset", Float) = 0
		[Toggle(_UV2_TCONTORLOFFSET_ON)] _UV2_TContorlOffset("UV2_TContorlOffset", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_EmissionStr("EmissionStr", Float) = 1
		_MainColor("MainColor", Color) = (0,0,0,0)
		_Ramp("Ramp", 2D) = "white" {}
		_RampScale("RampScale", Vector) = (1,0.5,0,0)
		_Noise("Noise", 2D) = "white" {}
		_NoiseScale("NoiseScale", Vector) = (1,0.5,0,0)
		_NoiseTexPanner("NoiseTexPanner", Vector) = (0,0,1,0)
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTestMode("ZTestMode", Float) = 8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" }
		Cull [_CullMode]
		ZWrite Off
		ZTest [_ZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 4.0
		#pragma shader_feature_local _UV2_WCONTORLOFFSET_ON
		#pragma shader_feature_local _UV2_TCONTORLOFFSET_ON
		#pragma shader_feature_local _UV_WCONTORLEMISSION_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
			float4 uv2_texcoord2;
			float4 vertexColor : COLOR;
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
		uniform sampler2D _Ramp;
		uniform float2 _RampScale;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Noise;
		uniform float3 _NoiseTexPanner;
		uniform float2 _NoiseScale;
		uniform float4 _MainColor;
		uniform float _EmissionStr;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uvs_TexCoord63 = i.uv_texcoord;
			uvs_TexCoord63.xy = i.uv_texcoord.xy * float2( 2,2 );
			float2 temp_output_55_0 = ( uvs_TexCoord63.xy - float2( 1,1 ) );
			float2 appendResult66 = (float2(frac( ( atan2( (temp_output_55_0).x , (temp_output_55_0).y ) / 6.28318548202515 ) ) , length( temp_output_55_0 )));
			float2 RadialUV70 = appendResult66;
			#ifdef _UV2_WCONTORLOFFSET_ON
				float staticSwitch37 = i.uv2_texcoord2.z;
			#else
				float staticSwitch37 = 1.0;
			#endif
			float UV2W35 = staticSwitch37;
			float2 appendResult12 = (float2(0.0 , UV2W35));
			float2 temp_cast_0 = (0.5).xx;
			float2 appendResult93 = (float2(_RampScale.x , saturate( _RampScale.y )));
			float4 tex2DNode27 = tex2D( _Ramp, ( ( ( ( RadialUV70 + appendResult12 ) - temp_cast_0 ) * appendResult93 ) + 0.5 ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode47 = tex2D( _MainTex, uv_MainTex );
			float MainTexG25 = tex2DNode47.g;
			float mulTime99 = _Time.y * _NoiseTexPanner.z;
			float2 appendResult98 = (float2(_NoiseTexPanner.x , _NoiseTexPanner.y));
			#ifdef _UV2_TCONTORLOFFSET_ON
				float staticSwitch36 = i.uv2_texcoord2.w;
			#else
				float staticSwitch36 = 1.0;
			#endif
			float UV2T34 = staticSwitch36;
			float2 appendResult43 = (float2(0.0 , UV2T34));
			float2 panner101 = ( mulTime99 * ( appendResult98 + appendResult43 ) + ( RadialUV70 * _NoiseScale ));
			float EmissionColor82 = ( ( tex2DNode27.r * ( tex2DNode27.r + MainTexG25 ) ) * saturate( tex2D( _Noise, ( panner101 + float2( 0,0 ) ) ).r ) );
			float VertexColorA17 = i.vertexColor.a;
			float FinalOpacity80 = ( EmissionColor82 * VertexColorA17 );
			float3 VertexColorRGB3 = (i.vertexColor).rgb;
			#ifdef _UV_WCONTORLEMISSION_ON
				float staticSwitch10 = i.uv_texcoord.z;
			#else
				float staticSwitch10 = 1.0;
			#endif
			float UV1W30 = staticSwitch10;
			float4 FinalBaseColor8 = ( _MainColor * float4( VertexColorRGB3 , 0.0 ) * UV1W30 * _EmissionStr * EmissionColor82 );
			c.rgb = FinalBaseColor8.rgb;
			c.a = FinalOpacity80;
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
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
20;15;1359;725;-2778.1;140.89;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;54;-1463.078,-2204.57;Inherit;False;2072.726;509.4896;Radial Math;13;70;66;59;56;62;60;65;57;58;55;61;63;64;Radial Math;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;64;-1398.84,-2061.047;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;61;-1182.667,-1905.581;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-1238.84,-2077.047;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-904.5867,-2060.822;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;58;-695.0788,-2140.57;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;57;-695.0788,-2060.57;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;7;-2861.403,-1103.05;Inherit;False;1489.423;1051.603;UV1;12;49;48;38;37;36;35;34;33;31;30;20;10;UV1&UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.TauNode;60;-445.7274,-2027.075;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;65;-450.5394,-2141.591;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-286.9084,-2138.413;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2270.24,-418.5173;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-2797.677,-409.7033;Inherit;True;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;56;-149.6855,-2092.459;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;59;-633.1985,-1896.199;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;37;-2062.239,-402.5173;Inherit;False;Property;_UV2_WContorlOffset;UV2_WContorlOffset;3;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;66;110.3372,-1992.847;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1726.31,-396.4583;Inherit;False;UV2W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1113.366,-838.7717;Inherit;False;35;UV2W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1100.287,-946.2982;Inherit;False;Constant;_Float6;Float 6;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;349.8529,-1986.537;Inherit;False;RadialUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;36;-2046.261,-210.6144;Inherit;False;Property;_UV2_TContorlOffset;UV2_TContorlOffset;4;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1733.67,-191.0974;Inherit;False;UV2T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-864.5385,-918.0412;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;89;-766.8511,-670.5894;Inherit;False;Property;_RampScale;RampScale;9;0;Create;True;0;0;0;False;0;False;1,0.5;2,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;71;-848.8124,-1037.321;Inherit;False;70;RadialUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1397.519,3.747845;Inherit;False;34;UV2T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1381.352,-115.0801;Inherit;False;Constant;_Float7;Float 7;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;97;-1381.061,-313.7356;Inherit;False;Property;_NoiseTexPanner;NoiseTexPanner;12;0;Create;True;0;0;0;False;0;False;0,0,1;0,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-612.1501,-987.3662;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-484.5145,-807.4431;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;91;-594.778,-599.0747;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-384.7777,-691.0747;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;76;-1019.408,-403.3297;Inherit;False;Property;_NoiseScale;NoiseScale;11;0;Create;True;0;0;0;False;0;False;1,0.5;3,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;72;-1015.418,-521.9896;Inherit;False;70;RadialUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2917.095,-16.17688;Inherit;False;749.6489;404.8277;Comment;4;25;45;24;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1061.062,-283.9814;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-1176.965,-65.94484;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;-332.5145,-990.4431;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-737.3943,-327.7477;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-155.6734,-969.2523;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-688.323,-443.1257;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;47;-2867.095,113.2701;Inherit;True;Property;_MainTex;MainTex;5;0;Create;True;0;0;0;False;0;False;-1;None;a8beafa0480a8a84fba299e845076ff1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;99;-1028.241,-182.7987;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;101;-484.3104,-376.4528;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;23.48547,-953.4431;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-2394.423,155.7869;Inherit;False;MainTexG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;264.5349,-632.5951;Inherit;False;25;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;213.8229,-927.1851;Inherit;True;Property;_Ramp;Ramp;8;0;Create;True;0;0;0;False;0;False;-1;da2150fdbd9743b4a9ce23c537eeb33b;194e817d005ce234f83b30adad0ac55a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-92.94946,-382.3827;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;480.2862,-654.081;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;63.1778,-455.2132;Inherit;True;Property;_Noise;Noise;10;0;Create;True;0;0;0;False;0;False;-1;None;88644092a973e7243934ef4deb86738d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-2811.403,-898.0566;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;21;381.9764,-482.8634;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2350.528,-1053.05;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;618.4838,-712.6281;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1;-2803.47,615.8677;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;2;-2621.51,612.9016;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;804.5762,-637.2386;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;10;-2027.991,-1011.969;Inherit;False;Property;_UV_WContorlEmission;UV_WContorlEmission;1;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;1035.52,-636.2312;Inherit;False;EmissionColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;3;-2453.51,615.9016;Inherit;False;VertexColorRGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-2539.511,709.4283;Inherit;False;VertexColorA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1720.577,-1000.125;Inherit;False;UV1W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;1342.826,-664.8566;Inherit;True;Property;_EmissionStr;EmissionStr;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;1296.826,-1299.202;Inherit;False;Property;_MainColor;MainColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;74;1816.457,-187.5066;Inherit;False;17;VertexColorA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;5;1305.216,-1101.932;Inherit;True;3;VertexColorRGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;1683.252,-608.5128;Inherit;False;82;EmissionColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;1302.437,-894.738;Inherit;True;30;UV1W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;1726.146,-299.1119;Inherit;False;82;EmissionColor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;2060.94,-243.9621;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;1996.928,-886.8641;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;2205.357,-237.7746;Inherit;False;FinalOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;2281.959,-606.3765;Inherit;True;FinalBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;9;-2068.204,57.8026;Inherit;False;235;263.753;Comment;2;32;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;341.1606,412.5841;Inherit;False;25;MainTexG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2018.203,205.5547;Inherit;False;Property;_ZTestMode;ZTestMode;14;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;3139.18,175.085;Inherit;False;80;FinalOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-2392.778,272.6509;Inherit;False;MainTexB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2014.724,107.8007;Inherit;False;Property;_CullMode;CullMode;13;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;92;-182.3843,-505.5028;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;50;3127.219,288.7192;Inherit;True;8;FinalBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-972.1142,239.7582;Inherit;False;31;UV1T;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-2391.446,33.82312;Inherit;False;MainTexR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-248.0343,-162.8813;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1714.577,-739.1254;Inherit;False;UV1T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;33;-2027.139,-739.9558;Inherit;False;Property;_UV_TContorlOffset;UV_TContorlOffset;2;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-823.8495,29.48901;Inherit;False;Constant;_Float3;Float 3;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-597.6549,240.0212;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;104;211.0424,115.7491;Inherit;False;RadialUVDistortion;-1;;1;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;0.0;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-435.1494,20.38909;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-610.5564,14.1845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3474.454,12.88848;Float;False;True;-1;4;ASEMaterialInspector;0;0;CustomLighting;Whl/Viv/GlowAB_OP_Radial;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;True;32;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;28;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;64;0
WireConnection;55;0;63;0
WireConnection;55;1;61;0
WireConnection;58;0;55;0
WireConnection;57;0;55;0
WireConnection;65;0;58;0
WireConnection;65;1;57;0
WireConnection;62;0;65;0
WireConnection;62;1;60;0
WireConnection;56;0;62;0
WireConnection;59;0;55;0
WireConnection;37;1;20;0
WireConnection;37;0;49;3
WireConnection;66;0;56;0
WireConnection;66;1;59;0
WireConnection;35;0;37;0
WireConnection;70;0;66;0
WireConnection;36;1;20;0
WireConnection;36;0;49;4
WireConnection;34;0;36;0
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;67;0;71;0
WireConnection;67;1;12;0
WireConnection;91;0;89;2
WireConnection;93;0;89;1
WireConnection;93;1;91;0
WireConnection;98;0;97;1
WireConnection;98;1;97;2
WireConnection;43;0;19;0
WireConnection;43;1;44;0
WireConnection;94;0;67;0
WireConnection;94;1;95;0
WireConnection;69;0;98;0
WireConnection;69;1;43;0
WireConnection;90;0;94;0
WireConnection;90;1;93;0
WireConnection;75;0;72;0
WireConnection;75;1;76;0
WireConnection;99;0;97;3
WireConnection;101;0;75;0
WireConnection;101;2;69;0
WireConnection;101;1;99;0
WireConnection;96;0;90;0
WireConnection;96;1;95;0
WireConnection;25;0;47;2
WireConnection;27;1;96;0
WireConnection;102;0;101;0
WireConnection;87;0;27;1
WireConnection;87;1;86;0
WireConnection;39;1;102;0
WireConnection;21;0;39;1
WireConnection;88;0;27;1
WireConnection;88;1;87;0
WireConnection;2;0;1;0
WireConnection;29;0;88;0
WireConnection;29;1;21;0
WireConnection;10;1;38;0
WireConnection;10;0;48;3
WireConnection;82;0;29;0
WireConnection;3;0;2;0
WireConnection;17;0;1;4
WireConnection;30;0;10;0
WireConnection;73;0;84;0
WireConnection;73;1;74;0
WireConnection;6;0;23;0
WireConnection;6;1;5;0
WireConnection;6;2;26;0
WireConnection;6;3;4;0
WireConnection;6;4;83;0
WireConnection;80;0;73;0
WireConnection;8;0;6;0
WireConnection;45;0;47;3
WireConnection;24;0;47;1
WireConnection;31;0;33;0
WireConnection;33;1;38;0
WireConnection;33;0;48;4
WireConnection;105;1;106;0
WireConnection;107;0;108;0
WireConnection;107;1;106;0
WireConnection;0;9;81;0
WireConnection;0;13;50;0
ASEEND*/
//CHKSM=41B7B6CC057E2E18BDC2B1DE3B95A1671D299BB3