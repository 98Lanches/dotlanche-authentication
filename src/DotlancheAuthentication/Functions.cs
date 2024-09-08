using Amazon.Lambda.Core;
using Amazon.Lambda.Annotations;
using Amazon.Lambda.Annotations.APIGateway;
using Amazon.Lambda.APIGatewayEvents;
using System.Text.Json;
using System.Net;
using DotlancheAuthentication.Core.Ports.AuthenticationService;
using DotlancheAuthentication.Contracts;

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

    [LambdaFunction(ResourceName ="GetUser", Role = DefaultRole)]
    [HttpApi(LambdaHttpMethod.Get, "/get-user/{cpf}")]
    public async Task<APIGatewayProxyResponse> GetUser(string cpf, ILambdaContext context)
    {
        var user = await cognitoService.GetUser(cpf);
        if (user is null)
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

    [LambdaFunction(ResourceName = "SignUp", Role = DefaultRole)]
    [HttpApi(LambdaHttpMethod.Post, "/sign-up")]
    public async Task<APIGatewayProxyResponse> SignUp([FromBody] SignUpFunctionRequest request, ILambdaContext context)
    {
        var requestIsValid = request.IsValid(out var errors);
        if(!requestIsValid)
        {
            return new APIGatewayProxyResponse()
            {
                StatusCode = (int)HttpStatusCode.BadRequest,
                Body = JsonSerializer.Serialize(errors)
            };
        }

        var signUpResponse = await cognitoService.SignUp(request.Cpf, request.Email, request.Name, request.Password);

        return new APIGatewayProxyResponse()
        {
            StatusCode = (int)(signUpResponse.Success ? HttpStatusCode.OK : HttpStatusCode.BadRequest),
            Body = JsonSerializer.Serialize(signUpResponse)
        };
    }
}