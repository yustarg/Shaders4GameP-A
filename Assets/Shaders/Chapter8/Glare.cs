using UnityEngine;
using System.Collections;

public class Glare : MonoBehaviour {

    public Material glareMat;
    public Material blurMat;

    void OnEnable()
    {
        Camera.main.depthTextureMode |= DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        RenderTexture rt1 = new RenderTexture(64, 64, 0);
        RenderTexture rt2 = new RenderTexture(64, 64, 0);
        RenderTexture rt3 = new RenderTexture(64, 64, 0);
        RenderTexture rt4 = new RenderTexture(64, 64, 0);
        RenderTexture rt5 = new RenderTexture(32, 32, 0);
        RenderTexture rt6 = new RenderTexture(32, 32, 0);
        Graphics.Blit(src, rt1, blurMat);
        Graphics.Blit(rt1, rt2, blurMat);
        Graphics.Blit(rt2, rt3, blurMat);
        Graphics.Blit(rt3, rt4, blurMat);
        Graphics.Blit(rt4, rt5, blurMat);
        Graphics.Blit(rt5, rt6, blurMat);

        glareMat.SetTexture("_BlurTex1", rt2);
        glareMat.SetTexture("_BlurTex2", rt4);
        glareMat.SetTexture("_BlurTex3", rt6);
        glareMat.SetFloat("_GlowFactor1", 0.05f);
        glareMat.SetFloat("_GlowFactor2", 0.1f);
        glareMat.SetFloat("_GlowFactor3", 0.15f);
        Graphics.Blit(src, rt6, glareMat);
        Graphics.Blit(rt6, dest);
    }
}
