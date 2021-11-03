
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
        // HttpRequestMessage: HttpRequestMessage;
        HttpHeaders: HttpHeaders;
        ResponseText: Text;
        WebErrorMsg: Label 'Something went wrong. Error Code is: %1', Comment = '%1 = Error code.';
        WebError2Msg: Label 'Error on server side. Error Code is: %1, Error Text is: %2', Comment = '%1 = Error code., %2 = Error text.';
    begin
        WebServiceGet.AddAuthorizationToHeader(HttpClient);
        HttpContent.GetHeaders(HttpHeaders);
        HttpContent.WriteFrom(SoapContentBody());
        SoapContentHeader(HttpHeaders, 'Calc');

        if not HttpClient.Post('https://bc-webshop.westeurope.cloudapp.azure.com:7047/BC/WS/CRONUS International Ltd./Codeunit/AMSoapWS', HttpContent, HttpResponseMessage) then
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Message('SOAP request responded with: \\' + ParseResponse(ResponseText));
        end else begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Error(WebError2Msg, HttpResponseMessage.HttpStatusCode(), ParseResponseError(ResponseText));
        end;
    end;

    local procedure SoapContentBody() returnValue: Text
    begin
        returnValue := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ams="urn:microsoft-dynamics-schemas/codeunit/AMSoapWS">'
                            + '<soapenv:Header/>'
                            + '<soapenv:Body>'
                                + '<ams:Calc>'
                                    + '<ams:name>Ugy</ams:name>'
                                + '</ams:Calc>'
                            + '</soapenv:Body>'
                            + '</soapenv:Envelope>';
    end;

    local procedure SoapContentHeader(var HttpHeaders: HttpHeaders; Operation: Text)
    begin
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'text/xml');
        HttpHeaders.Add('SOAPAction', '"urn:microsoft-dynamics-schemas/codeunit/AMSoapWS:' + Operation + '"');
    end;

    local procedure ParseResponse(ResponseText: Text): Text
    var
        ResponseXMLDocument: XMLDocument;
        RootXmlElement: XMLElement;
        BodyXMLNode: XMLNode;
        OperationResultXMLNode: XMLNode;
        ResultXMLNode: XMLNode;
    begin
        XMLDocument.ReadFrom(ResponseText, ResponseXMLDocument);
        ResponseXMLDocument.GetRoot(RootXmlElement);
        RootXmlElement.GetChildNodes().Get(1, BodyXMLNode);
        BodyXMLNode.AsXmlElement().GetChildNodes().Get(1, OperationResultXMLNode);
        OperationResultXMLNode.AsXmlElement().GetChildNodes().Get(1, ResultXMLNode);
        if ResultXMLNode.IsXmlElement() then
            exit(ResultXMLNode.AsXmlElement().InnerText)
        else
            exit('');
    end;

    local procedure ParseResponseError(ResponseText: Text): Text
    var
        ResponseXMLDocument: XMLDocument;
        RootXmlElement: XMLElement;
        BodyXMLNode: XMLNode;
        OperationResultXMLNode: XMLNode;
        ResultXMLNode: XMLNode;
        ResultsXMLNodeList: XMLNodeList;
    begin
        XMLDocument.ReadFrom(ResponseText, ResponseXMLDocument);
        ResponseXMLDocument.GetRoot(RootXmlElement);
        RootXmlElement.GetChildNodes().Get(1, BodyXMLNode);
        BodyXMLNode.AsXmlElement().GetChildNodes().Get(1, OperationResultXMLNode);
        ResultsXMLNodeList := OperationResultXMLNode.AsXmlElement().GetChildNodes();
        foreach ResultXMLNode in ResultsXMLNodeList do
            if ResultXMLNode.AsXmlElement().Name() = 'detail' then
                exit(ResultXMLNode.AsXmlElement().InnerText);

        exit('Something went wrong.');
    end;

}
