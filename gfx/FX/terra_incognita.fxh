
PixelShader = {
Code 
[[
static const float GALAXY_SIZE = 3000.f;
static const float TI_BLEND_START = 0.65f;
static const float TI_BLEND_STOP = 0.75f;
static const float TI_GRAY_BRIGHTNESS = 0.15f;

float Desaturate( float3 vColor )
{
	return dot( vColor, float3( 0.212671f, 0.715160f, 0.072169f ) );
}

float CalcTerraIncognitaValue( float2 vWorldPos2D, in sampler2D TITexture )
{
	float2 vTIUV = ( vWorldPos2D + GALAXY_SIZE * 0.5f ) / GALAXY_SIZE;
	float vTI = tex2D( TerraIncognitaTexture, vTIUV ).a;
	
	return smoothstep( TI_BLEND_START, TI_BLEND_STOP, vTI );
}

float4 ApplyTerraIncognitaValue( float4 vColor, float vBrightness, float vTI)
{
	float Grey = Desaturate( vColor.rgb ) * TI_GRAY_BRIGHTNESS * vBrightness; 
	//Grey = TI_DARK + ( ( TI_BRIGHT - TI_DARK ) * ( Grey ) ) / 1.f;
	
	vColor.rgb = lerp( vec3( Grey ), vColor.rgb, vTI );
	
	return vColor;
}

float4 ApplyTerraIncognitaValueIgnoreSaturation( float4 vColor, float vBrightness, float vTI)
{
	float Grey = TI_GRAY_BRIGHTNESS * vBrightness; 
	vColor.rgb = lerp( vec3( Grey ), vColor.rgb, vTI );
	
	return vColor;
}

float4 ApplyTerraIncognita( float4 vColor, float2 vWorldPos2D, float vBrightness, in sampler2D TITexture )
{
	float vTI = CalcTerraIncognitaValue( vWorldPos2D, TITexture );
	return ApplyTerraIncognitaValue( vColor, vBrightness, vTI);
}

float4 ApplyTerraIncognitaIgnoreSaturation( float4 vColor, float2 vWorldPos2D, float vBrightness, in sampler2D TITexture )
{
	float vTI = CalcTerraIncognitaValue( vWorldPos2D, TITexture );
	return ApplyTerraIncognitaValueIgnoreSaturation( vColor, vBrightness, vTI);
}

]]
}

