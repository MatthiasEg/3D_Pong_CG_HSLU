precision mediump float;

// we use 4 light sources here

uniform vec3 uLightPosition1;
uniform vec3 uLightPosition2;
uniform vec3 uLightPosition3;
uniform vec3 uLightPosition4;
uniform vec3 uLightColor1;
uniform vec3 uLightColor2;
uniform vec3 uLightColor3;
uniform vec3 uLightColor4;
uniform bool uEnableLight1;
uniform bool uEnableLight2;
uniform bool uEnableLight3;
uniform bool uEnableLight4;

uniform bool uEnableLighting;

varying vec3 vColor;
varying vec3 vNormalEye;
varying vec3 vPositionEye3;

const float ambientFactor = 0.3;
const float shininess = 2.0;
const vec3 specularMaterialColor = vec3(0.8, 0.8, 0.8);

const float att1 = 0.0;
const float att2 = 0.5;
const float att3 = 0.2;


vec3 calculateLighting(vec3 lightColor, vec3 lightPosition) {
    // calculate light direction as seen from the vertex position
    vec3 lightVectorEye = lightPosition - vPositionEye3;
    vec3 lightDirectionEye = normalize(lightVectorEye);
    vec3 normal = normalize(vNormalEye);

    // calculate light attenuation
    float distance = length(lightVectorEye);
    float attenuationFactor = 1.0 / (att1 + att2*distance + att3*distance*distance);

    // diffuse lighting
    float diffuseFactor = max(dot(normal,lightDirectionEye),0.0);
    vec3 diffuseColor = diffuseFactor * vColor * lightColor * attenuationFactor;

    // specular lighting
    vec3 specularColor = vec3(0, 0, 0);
    if (diffuseFactor > 0.0) {
       vec3 reflectionDir = normalize(reflect(-lightDirectionEye, normal));
       vec3 eyeDir = -normalize(vPositionEye3);
       float cosPhi = max(dot(reflectionDir, eyeDir), 0.0);
       float specularFactor = pow(cosPhi, shininess);
       specularColor = specularFactor * specularMaterialColor * lightColor * attenuationFactor;
    }
    return diffuseColor + specularColor;
}

void main() {
    if (uEnableLighting) {
            // ambient lighting
            vec3 ambientColor = ambientFactor * vColor;
            vec3 color = ambientColor;

            if (uEnableLight1) {
                color += calculateLighting(uLightColor1, uLightPosition1);
            }
            if (uEnableLight2) {
                color += calculateLighting(uLightColor2, uLightPosition2);
            }
            if (uEnableLight3) {
                color += calculateLighting(uLightColor3, uLightPosition3);
            }
            if (uEnableLight4) {
                color += calculateLighting(uLightColor4, uLightPosition4);
            }

        gl_FragColor = vec4(color, 1.0);
    } else {
        gl_FragColor = vec4(vColor, 1.0);
    }
}

