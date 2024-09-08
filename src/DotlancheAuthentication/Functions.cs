using Amazon.Lambda.Core;
using Amazon.Lambda.Annotations;
using Amazon.Lambda.Annotations.APIGateway;
using Amazon.Lambda.APIGatewayEvents;
using System.Text.Json;
using System.Net;
using DotlancheAuthentication.Core.Ports.AuthenticationService;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace DotlancheAuthentication;

public class Functions
{
    private const string DefaultRole = "arn:aws:iam::032963977760:role/LabRole";
    private readonly IAuthenticationService cognitoService;

    public Functions(IAuthenticationService cognitoService)
    {
        this.cognitoService = cognitoService;
    }

    [LambdaFunction(Role = DefaultRole)]
    [HttpApi(LambdaHttpMethod.Get, "/get-user/{cpf}")]
    public async Task<APIGatewayProxyResponse> GetUser(string cpf, ILambdaContext context)
    {
        var user = await cognitoService.GetUser(cpf);
        if(user is null)
        {
            return new APIGatewayProxyResponse()
            {
                StatusCode = (int)HttpStatusCode.NotFound,
                Body = JsonSerializer.Serialize(new { Message = "User not found" })
            };
        }

        return new APIGatewayProxyResponse()
        {
            StatusCode = (int)HttpStatusCode.OK,
            Body = JsonSerializer.Serialize(user)
        };
    }
}