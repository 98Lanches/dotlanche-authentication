using System.Text.RegularExpressions;

namespace DotlancheAuthentication.Contracts;

public class ConfirmSignUpFunctionRequest
{
    public required string Cpf { get; set; }

    public required string ConfirmationCode { get; set; }

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

        return isValid;
    }
}
