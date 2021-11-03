/// <summary>
/// Codeunit Web Service-SendInvoice (ID 50105).
/// </summary>
codeunit 50104 "Web Service-SendInvoice"
{
    trigger OnRun()
    var
        SalesDocumentJsonObject: JsonObject;
        SalesLineJsonObject: JsonObject;
        OrderLinePath: Text;
    begin
        SalesDocumentJsonObject := CallODataService('salesOrders', CreateSalesOrder());
        OrderLinePath := GetOrderLinePath(GetFieldValue('id', SalesDocumentJsonObject).AsText());

        SalesLineJsonObject := CallODataService(OrderLinePath, CreateSalesLine(10000, '1320', 3, 50));
        SalesLineJsonObject := CallODataService(OrderLinePath, CreateSalesLine(20000, '1310', 1, 40));
        SalesLineJsonObject := CallODataService(OrderLinePath, CreateSalesLine(30000, '1300', 2, 60));

        Message('Your document number is: %1', GetFieldValue('number', SalesDocumentJsonObject).AsCode());
    end;

    local procedure CallODataService(OperationName: Text; ContentBody: Text): JsonObject;
    var
        WebServiceGet: Codeunit WebServiceGet;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        ResponseJsonToken: JsonToken;
        ResponseText: Text;
    begin
        WebServiceGet.AddAuthorizationToHeader(HttpClient);

        HttpContent.WriteFrom(ContentBody);

        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        if not HttpClient.Post(GetServicePath(OperationName), HttpContent, HttpResponseMessage) then
            Error('Something went wrong. Error status code is %1.', HttpResponseMessage.HttpStatusCode);
        if HttpResponseMessage.IsSuccessStatusCode() then BEGIN
            HttpResponseMessage.Content.ReadAs(ResponseText);
            ResponseJsonToken.ReadFrom(ResponseText);
            exit(ResponseJsonToken.AsObject());
        end else begin
            HttpResponseMessage.Content.ReadAs(ResponseText);
            Error('Error: %1\from request: %2', ResponseText, ContentBody);
        end;
    end;

    local procedure GetServicePath(OperationName: Text): Text
    begin
        //exit('https://ptsv2.com/t/mvyld-1635848575/post');
        exit('https://bc-webshop.westeurope.cloudapp.azure.com:7048/bc/api/v2.0/companies(3adc449e-8621-ec11-bb76-000d3a29933c)/' + OperationName);
    end;

    local procedure GetOrderLinePath(id: Text): text
    begin
        exit('salesOrders(' + id + ')/salesOrderLines');
    end;

    local procedure GetFieldValue(FieldName: Text; JsonObject: JsonObject): JsonValue
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;

    local procedure CreateSalesOrder() Result: Text
    var
        SalesOrderJsonObject: JsonObject;
    begin
        SalesOrderJsonObject.Add('number', '');
        SalesOrderJsonObject.Add('orderDate', format(System.Today(), 0, 9));
        SalesOrderJsonObject.Add('customerNumber', '01121212');
        SalesOrderJsonObject.WriteTo(Result);
    end;

    local procedure CreateSalesLine(LineNo: Integer; ItemNo: Code[20]; Qty: Decimal; Price: Decimal) Result: Text
    var
        SalesLineJsonObject: JsonObject;
    begin
        SalesLineJsonObject.Add('sequence', LineNo);
        SalesLineJsonObject.Add('lineType', 'Item');
        SalesLineJsonObject.Add('lineObjectNumber', ItemNo);
        SalesLineJsonObject.Add('quantity', Qty);
        SalesLineJsonObject.Add('unitPrice', Price);
        SalesLineJsonObject.Add('shipQuantity', Qty);
        SalesLineJsonObject.WriteTo(Result);
    end;
}