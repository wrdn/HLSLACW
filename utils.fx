#define EPSILON 0.000001f
#define PI 3.1415926f
#define PIOVER180 PI/180.0f;
#define _180OVERPI 180.0f/PI

float DEGTORAD(float degs) { return degs * PIOVER180; };
float RADSTODEGS(float rads) { return rads * _180OVERPI; };

float4x4 build_rotation_matrix(float angle_in_degs, float xAxis, float yAxis, float zAxis)
{
	float3 axis = normalize(float3(xAxis,yAxis,zAxis));
	float x = axis.x, y = axis.y, z = axis.z;
	float angle = DEGTORAD(angle_in_degs);
	float c = cos(angle), s = sin(angle);
	
	return float4x4
	(
		x*x*(1-c)+c,   // m11
		x*y*(1-c)-z*s, // m12
		x*z*(1-c)+y*s, // m13
		0,			   // m14

		y*x*(1-c)+z*s, // m21
		y*y*(1-c)+c,   // m22
		y*z*(1-c)-x*s, // m23
		0,			   // m24

		x*z*(1-c)-y*s, // m31 
		y*z*(1-c)+x*s, // m32
		z*z*(1-c)+c,   // m33
		0,			   // m34

		0, 0, 0, 1     // m41, m42, m43, m44		
	);
};

float4 tex2Dlod_bilinear(sampler textureSampler, float4 uv, float textureSize, float texelSize)
{
	float height00 = tex2Dlod(textureSampler, uv);
	float height10 = tex2Dlod(textureSampler, uv + float4(texelSize,0,0,0));
	float height01 = tex2Dlod(textureSampler, uv + float4(0, texelSize,0,0));
	float height11 = tex2Dlod(textureSampler, uv + float4(texelSize,texelSize,0,0));
	
	float2 f = frac(uv.xy * textureSize);
	
	float4 tA = lerp(height00, height10, f.x);
	float4 tB = lerp(height01, height11, f.x);
	return lerp(tA, tB, f.y);
};