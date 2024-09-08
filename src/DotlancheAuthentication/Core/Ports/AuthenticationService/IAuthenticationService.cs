using DotlancheAuthentication.Core.Common;
using DotlancheAuthentication.Core.Entities;
using DotlancheAuthentication.Core.Ports.AuthenticationService.ResultModels;

namespace DotlancheAuthentication.Core.Ports.AuthenticationService;

public interface IAuthenticationService
{
    public Task<User?> GetUser(string cpf);
    public Task<BaseResult> SignUp(string cpf, string email, string fullName, string password);
    public Task<BaseResult> ConfirmSignUp(string username, string confirmationCode);
    public Task<SignInResult> SignIn(string username, string password);
}
