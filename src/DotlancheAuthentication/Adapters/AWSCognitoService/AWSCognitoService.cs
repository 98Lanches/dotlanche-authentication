using System.Security.Cryptography;
using System.Text;
using Amazon.CognitoIdentityProvider;
using Amazon.CognitoIdentityProvider.Model;
using Amazon.Extensions.CognitoAuthentication;
using DotlancheAuthentication.Core.Common;
using DotlancheAuthentication.Core.Entities;
using DotlancheAuthentication.Core.Ports.AuthenticationService;
using DotlancheAuthentication.Core.Ports.AuthenticationService.ResultModels;
using Microsoft.Extensions.Configuration;

namespace DotlancheAuthentication.Adapters.AWSCognitoService;

public class AWSCognitoService : IAuthenticationService
{
    private readonly AmazonCognitoIdentityProviderClient providerClient;
    private readonly CognitoUserPool cognitoUserPool;
    private readonly string? userPoolId;
    private readonly string? clientId;
    private readonly string? clientSecret;

    public AWSCognitoService(IConfiguration configuration)
    {
        var awsCredentialConfigs = configuration.GetSection("Aws:Credentials");

        var awsAccessKeyId = awsCredentialConfigs.GetValue<string>("awsAccessKeyId");
        var awsSecretAccessKey = awsCredentialConfigs.GetValue<string>("awsSecretAccessKey");
        var awsSessionToken = awsCredentialConfigs.GetValue<string>("awsSessionToken");

        var cognitoConfigs = configuration.GetSection("Cognito");

        userPoolId = cognitoConfigs.GetValue<string>("userPoolId");
        clientId = cognitoConfigs.GetValue<string>("clientId");
        clientSecret = cognitoConfigs.GetValue<string>("clientSecret");

        providerClient = new AmazonCognitoIdentityProviderClient(awsAccessKeyId, awsSecretAccessKey, awsSessionToken, Amazon.RegionEndpoint.USEast1);
        cognitoUserPool = new CognitoUserPool(userPoolId, clientId, providerClient, clientSecret);
    }

    public async Task<User?> GetUser(string cpf)
    {
        var cognitoUser = await cognitoUserPool.FindByIdAsync(cpf);

        if (cognitoUser == null)
            return null;

        return new User
        {
            Cpf = cognitoUser.UserID,
            Name = cognitoUser.Attributes["name"],
            Email = cognitoUser.Attributes["email"]
        };
    }

    public async Task<BaseResult> SignUp(string cpf, string email, string fullName, string password)
    {
        var username = cpf;

        var signUpRequest = new SignUpRequest
        {
            ClientId = clientId,
            Username = username,
            Password = password,
            SecretHash = GetSecretHash(username),
            UserAttributes = {
                new AttributeType() {Name = "email", Value = email },
                new AttributeType() {Name = "name", Value = fullName },
            }
        };

        try
        {
            var response = await providerClient.SignUpAsync(signUpRequest);
            return new BaseResult() { Success = response.HttpStatusCode == System.Net.HttpStatusCode.OK, Message = "SignUp Successful" };
        }
        catch (System.Exception e)
        {
            return new BaseResult() { Success = false, Message = e.Message };
        }
    }

    public async Task<BaseResult> ConfirmSignUp(string username, string confirmationCode)
    {
        var request = new ConfirmSignUpRequest()
        {
            ClientId = clientId,
            Username = username,
            SecretHash = GetSecretHash(username),
            ConfirmationCode = confirmationCode
        };

        var response = await providerClient.ConfirmSignUpAsync(request);
        return new BaseResult() { Success = response.HttpStatusCode == System.Net.HttpStatusCode.OK };
    }

    public async Task<SignInResult> SignIn(string username, string password)
    {
        var user = new CognitoUser(
            userID: username,
            clientID: clientId,
            clientSecret: clientSecret,
            pool: cognitoUserPool,
            provider: providerClient,
            username: username
        );

        var request = new InitiateSrpAuthRequest()
        {
            Password = password,
        };

        try
        {
            var authResponse = await user.StartWithSrpAuthAsync(request);

            return new SignInResult()
            {
                Success = true,
                AccessToken = authResponse.AuthenticationResult.AccessToken,
                IdToken = authResponse.AuthenticationResult.IdToken,
                ExpiresIn = authResponse.AuthenticationResult.ExpiresIn,
                TokenType = authResponse.AuthenticationResult.TokenType,
                RefreshToken = authResponse.AuthenticationResult.RefreshToken,
            };

        }
        catch (System.Exception)
        {
            return new SignInResult()
            {
                Success = false,
            };
        }
    }

    private string GetSecretHash(string username)
    {
        var dataToHash = Encoding.UTF8.GetBytes(username + clientId);
        var hashed = HMACSHA256.HashData(Encoding.UTF8.GetBytes(clientSecret!), dataToHash);
        return Convert.ToBase64String(hashed);
    }
}
