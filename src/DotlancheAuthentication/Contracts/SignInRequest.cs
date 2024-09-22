#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.
namespace DotlancheAuthentication.Contracts;

public class SignInRequest
{
    public bool Anonymous { get; set; }

    public string Cpf { get; set; }

    public string Password { get; set; }
}
