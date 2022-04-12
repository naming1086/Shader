using UnityEngine;

[ExecuteInEditMode]
public class PandaPostProcess : MonoBehaviour
{
	public Material PostProcessMat;


	public float StepFactor = 0.5F;
	public float MainAlpha=1F;	
	public float BlurFactor;
	public float LineUVScale;
	public float Chromatic;
	public float Frequency;
	public float Amplitude;
	public float VignettePower= 1.5F;
	public float VignetteScale= 1.5F;
	public float CenterU = 0.5F;
	public float CenterV = 0.5F;


	private void Awake()
	{
		if( PostProcessMat == null )
		{
			enabled = false;
		}
		else
		{
			
			PostProcessMat.mainTexture = PostProcessMat.mainTexture;
		}

	}

	//void Start()
	//{
	
	//var BlurFactor = PostProcessMat.GetFloat("_BlurFactorK");


	//}

	//void Update()
	//{
		

	
	//}

	void OnRenderImage( RenderTexture src, RenderTexture dest )
	{
		PostProcessMat.SetFloat("_StepFactorK", StepFactor);

		PostProcessMat.SetFloat("_BlurFactorK", BlurFactor);
		
		PostProcessMat.SetFloat("_LineUVScaleK", LineUVScale);

		PostProcessMat.SetFloat("_MainAlphaK", MainAlpha);

		PostProcessMat.SetFloat("_zhenpinK", Frequency);

		PostProcessMat.SetFloat("_zhenfuK", Amplitude);

		PostProcessMat.SetFloat("_RedBlueFactorK", Chromatic);

		PostProcessMat.SetFloat("_VignettePowerK", VignettePower);

		PostProcessMat.SetFloat("_VignetteScaleK", VignetteScale);

		PostProcessMat.SetFloat("_centerU", CenterU);

		PostProcessMat.SetFloat("_centerV", CenterV);



		Graphics.Blit( src, dest, PostProcessMat );
	}
}
