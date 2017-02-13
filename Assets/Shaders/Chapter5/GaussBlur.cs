using UnityEngine;
using System.Collections;

public class GaussBlur : MonoBehaviour
{

    public Material mat;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
    }
}
