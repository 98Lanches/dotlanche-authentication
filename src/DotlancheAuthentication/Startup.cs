using DotlancheAuthentication.Adapters.AWSCognitoService;
using DotlancheAuthentication.Core.Ports.AuthenticationService;
using Microsoft.Extensions.DependencyInjection;

namespace DotlancheAuthentication;

[Amazon.Lambda.Annotations.LambdaStartup]
public class Startup
{
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton<IAuthenticationService, AWSCognitoService>();
    }
}
