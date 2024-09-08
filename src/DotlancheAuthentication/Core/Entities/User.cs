namespace DotlancheAuthentication.Core.Entities;

public class User
{
    public required string Cpf { get; set; }

    public required string Name { get; set; }

    public required string Email { get; set; }
}
