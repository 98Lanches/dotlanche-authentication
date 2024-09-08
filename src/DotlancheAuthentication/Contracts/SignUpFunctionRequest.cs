using System.Text.RegularExpressions;

namespace DotlancheAuthentication.Contracts;

public class SignUpFunctionRequest
{
    public required string Cpf { get; set; }

    public required string Password { get; set; }

    public required string Name { get; set; }

    public required string Email { get; set; }

    public bool IsValid(out IDictionary<string, string> errors)
    {
        var isValid = true;
        errors = new Dictionary<string, string>();

        bool isValidCpf = Regex.Match(Cpf, @"^\d{11}$").Success;
        if (!isValidCpf)
        {
            isValid = false;
            errors[nameof(Cpf)] = "CPF Should be 11 numbers";
        }

        if(Name.Length > 50)
        {
            isValid = false;
            errors[nameof(Name)] = "Name should be at most 50 characters long";
        }

        var isValidEmail = Regex.Match(Email, @"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").Success;
        if(!isValidEmail)
        {
            isValid = false;
            errors[nameof(Email)] = "Invalid email";
        }

        return isValid;
    }
}
