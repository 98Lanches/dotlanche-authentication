using DotlancheAuthentication.Core.Common;

namespace DotlancheAuthentication.Core.Ports.AuthenticationService.ResultModels;

public class SignInResult : BaseResult
{
    public string? IdToken { get; set; }

    public string? AccessToken { get; set; }

    public int? ExpiresIn { get; set; }

    public string? TokenType { get; set; }

    public string? RefreshToken { get; set; }
}
