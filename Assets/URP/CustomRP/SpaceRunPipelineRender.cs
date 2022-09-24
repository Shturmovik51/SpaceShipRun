using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class SpaceRunPipelineRender : RenderPipeline
{
    CameraRenderer _cameraRenderer;



    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        _cameraRenderer = new CameraRenderer();
        CamerasRender(context, cameras);
    }

    private void CamerasRender(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach (var camera in cameras)
        {
            _cameraRenderer.Render(context, camera);
        }
    }
}
