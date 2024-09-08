using Xunit;
using Amazon.Lambda.TestUtilities;
using Moq;


namespace DotlancheAuthentication.Tests;

public class FunctionsTest
{

    public FunctionsTest()
    {
        // var mock = new Mock<ICalculatorService>();
        // mock.Setup(m => m.Add(It.IsAny<int>(), It.IsAny<int>())).Returns(12);

        // _mockCalculatorService = mock.Object;
    }

    [Fact]
    public void TestAdd()
    {
        // TestLambdaContext context = new TestLambdaContext();
        
        // var functions = new Functions(_mockCalculatorService);
        // Assert.Equal(12, functions.Add(3, 9, context));
    }
}
