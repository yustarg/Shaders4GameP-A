using UnityEngine;
using System.Collections;

public class MotionBlur : MonoBehaviour {

    public Material mat;
    public RenderTexture accumTexture;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (accumTexture == null || accumTexture.width != src.width || accumTexture.height != src.height)
        {
            DestroyImmediate(accumTexture);
            accumTexture = new RenderTexture(src.width, src.height, 0);
            accumTexture.hideFlags = HideFlags.HideAndDontSave;
            Graphics.Blit(src, accumTexture);
        }
        //mat.SetTexture("_MainTex", src);
        Graphics.Blit(src, accumTexture, mat);
        Graphics.Blit(accumTexture, dest);
    }
}
