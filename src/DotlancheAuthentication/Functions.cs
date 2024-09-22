using Amazon.Lambda.Core;
using Amazon.Lambda.Annotations;
using Amazon.Lambda.Annotations.APIGateway;
using Amazon.Lambda.APIGatewayEvents;
using DotlancheAuthentication.Core.Ports.AuthenticationService;
using DotlancheAuthentication.Contracts;
using System.Runtime.InteropServices;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace DotlancheAuthentication;

public class Functions : ApiGatewayFunctionGroup
{
    private readonly IAuthenticationService cognitoService;
    public Functions(IAuthenticationService cognitoService)
    {
        this.cognitoService = cognitoService;
    }

    [LambdaFunction(ResourceName = "GetUser")]
    [HttpApi(LambdaHttpMethod.Get, "/get-user/{cpf}")]
    public async Task<APIGatewayProxyResponse> GetUser(string cpf, ILambdaContext context)
    {
        var user = await cognitoService.GetUser(cpf);

        if (user is null)
            return NotFound(new { Message = "User not found" });

        return Ok(user);
    }

    [LambdaFunction(ResourceName = "SignUp")]
    [HttpApi(LambdaHttpMethod.Post, "/sign-up")]
    public async Task<APIGatewayProxyResponse> SignUp([FromBody] SignUpFunctionRequest request, ILambdaContext context)
    {
        var requestIsValid = request.IsValid(out var errors);
        if (!requestIsValid)
            return BadRequest(errors);

        var signUpResponse = await cognitoService.SignUp(request.Cpf, request.Email, request.Name, request.Password);
        return signUpResponse.Success ? Ok(signUpResponse) : BadRequest(signUpResponse);
    }

    [LambdaFunction(ResourceName = "SignIn")]
    [HttpApi(LambdaHttpMethod.Post, "/sign-in")]
    public async Task<APIGatewayProxyResponse> SignIn([FromBody] SignInRequest request, ILambdaContext context)
    {
        if (request.Anonymous)
        {
            request.Cpf = Environment.GetEnvironmentVariable("ANONYMOUS_USERNAME") ??
                throw new Exception("Invalid anonymous configuration");

            request.Password = Environment.GetEnvironmentVariable("ANONYMOUS_PASSWORD") ??
                throw new Exception("Invalid anonymous configuration");
        }

        var signInResponse = await cognitoService.SignIn(request.Cpf, request.Password);
        return signInResponse.Success ? Ok(signInResponse) : BadRequest(signInResponse);
    }
}