using DotlancheAuthentication.Adapters.AWSCognitoService;
using DotlancheAuthentication.Core.Ports.AuthenticationService;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace DotlancheAuthentication;

[Amazon.Lambda.Annotations.LambdaStartup]
public class Startup
{
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton<IAuthenticationService, AWSCognitoService>();

        var configuration = new ConfigurationBuilder()
                        .AddEnvironmentVariables()
                        .AddJsonFile("appsettings.json", false)
                        .Build();

        services.AddSingleton<IConfiguration>(configuration);
    }
}
