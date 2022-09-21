using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class SwitchRenderPipelieAsset : MonoBehaviour
{
    public RenderPipelineAsset _exampleAssetA;
    public RenderPipelineAsset _exampleAssetB;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            GraphicsSettings.renderPipelineAsset = _exampleAssetA;
            Debug.Log($"DEfault render pipline asset is: {GraphicsSettings.renderPipelineAsset.name}");
        }

        if (Input.GetKeyDown(KeyCode.B))
        {
            GraphicsSettings.renderPipelineAsset = _exampleAssetB;
            Debug.Log($"DEfault render pipline asset is: {GraphicsSettings.renderPipelineAsset.name}");
        }
    }
}
