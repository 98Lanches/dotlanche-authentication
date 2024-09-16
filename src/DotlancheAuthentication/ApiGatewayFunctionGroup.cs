using System.Net;
using System.Text.Json;
using Amazon.Lambda.APIGatewayEvents;

namespace DotlancheAuthentication;

public abstract class ApiGatewayFunctionGroup
{
    protected static APIGatewayProxyResponse Ok(object body) => StatusCodeResponse(HttpStatusCode.OK, body);

    protected static APIGatewayProxyResponse BadRequest(object body) => StatusCodeResponse(HttpStatusCode.BadRequest, body);

    protected static APIGatewayProxyResponse NotFound(object body) => StatusCodeResponse(HttpStatusCode.NotFound, body);

    protected static APIGatewayProxyResponse InternalServerError(object? body = null)
    {
        body ??= new { Message = "An error occurred while processing the request. Please try again later" };
        return StatusCodeResponse(HttpStatusCode.InternalServerError, body);
    }

    protected static APIGatewayProxyResponse StatusCodeResponse(HttpStatusCode statusCode, object body)
    {
        return new APIGatewayProxyResponse()
        {
            StatusCode = (int)statusCode,
            Body = JsonSerializer.Serialize(body)
        };
    }
}
