
/// <summary>
/// Codeunit Web Service-Post (ID 50103).
/// </summary>
codeunit 50103 "Web Service-Post"
{
    trigger OnRun()
    var
        WebServiceGet: Codeunit WebServiceGet;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
    begin
        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Add('Header1', 'Value1');

        HttpContent.WriteFrom('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ams="urn:microsoft-dynamics-schemas/codeunit/AMSoapWS">'
                            + '<soapenv:Header/>'
                            + '<soapenv:Body>'
                                + '<ams:Calc>'
                                    + '<ams:name>Aleksander</ams:name>'
                                + '</ams:Calc>'
                            + '</soapenv:Body>'
                            + '</soapenv:Envelope>');
        WebServiceGet.AddAuthorizationToHeader(HttpClient);
        HttpClient.Post('https://ptsv2.com/t/mvyld-1635848575/post', HttpContent, HttpResponseMessage);
        Message('SOAP was successfully sent.');
    end;
}
