﻿using UnityEngine;
using System.Collections;

public class HeatHaze : MonoBehaviour {

    public Material mat;

    void OnEnable()
    {
        Camera.main.depthTextureMode |= DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, mat);
    }
}
