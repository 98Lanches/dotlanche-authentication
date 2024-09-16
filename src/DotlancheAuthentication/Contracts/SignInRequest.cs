namespace DotlancheAuthentication.Contracts;

public class SignInRequest
{
    public required string Cpf { get; set; }

    public required string Password { get; set; }
}
