/// <summary>
/// Codeunit WebServiceGet (ID 50100).
/// </summary>
codeunit 50100 "WebServiceGet"
{
    trigger OnRun()
    var
        WebShopSetup: Record "Web Shop Setup";
        TempItem: Record Item temporary;
        httpClient: httpClient;
        HttpResponseMessage: HttpResponseMessage;
        ValueJsonToken: JsonToken;
        ItemJsonToken: JsonToken;
        BackEndWebShopTok: Label '%1/itemsAM?$top=3', Comment = '%1: base Url';
        WebErrorMsg: Label 'Something went wrong. Error Code is: %1', Comment = '%1 = Error code.';
    begin
        AddAuthorizationToHeader(httpClient);
        WebShopSetup.Get();
        if not httpClient.Get(StrSubstNo(BackEndWebShopTok, WebShopSetup."BackEnd Web Service URL"), HttpResponseMessage) then
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
        if HttpResponseMessage.IsSuccessStatusCode() then begin
            ReadBody(HttpResponseMessage, ValueJsonToken);
            foreach ItemJsonToken in ValueJsonToken.AsArray() do
                ProcessItem(ItemJsonToken, TempItem);
            Page.Run(Page::"Item List", TempItem);
        end else
            Error(WebErrorMsg, HttpResponseMessage.HttpStatusCode());
    end;

    local procedure ProcessItem(var ItemJsonToken: JsonToken; var TempItem: record Item temporary)
    var
        ItemJsonObject: JsonObject;
    begin
        ItemJsonObject := ItemJsonToken.AsObject();

        TempItem.Init();
        TempItem."No." := CopyStr(GetFiledValue(ItemJsonObject, 'number').AsCode(), 1, MaxStrLen(TempItem."No."));
        TempItem.Description := CopyStr(GetFiledValue(ItemJsonObject, 'displayName').AsText(), 1, MaxStrLen(TempItem.Description));
        TempItem.Insert();
    end;

    local procedure AddAuthorizationToHeader(var httpClient: httpClient)
    var
        Base64Convert: Codeunit "Base64 Convert";
        AuthString: Text;
        BasicTok: Label 'Basic %1', Comment = '%1 = placeholder for username and password.';
        UserPwdTok: Label '%1:%2', Comment = '%1 = username, %2 = password.';
    begin
        AuthString := StrSubstNo(UserPwdTok, 'admin', 'Pa$$w0rd!');
        httpClient.DefaultRequestHeaders().Add('Authorization',
            StrSubstNo(BasicTok,
                Base64Convert.ToBase64(AuthString)));
    end;

    local procedure ReadBody(var HttpResponseMessage: HttpResponseMessage; var ValueJsonToken: JsonToken)
    var
        ResponseJsonObject: JsonObject;
        ResponseText: Text;
    begin
        HttpResponseMessage.Content.ReadAs(ResponseText);
        ResponseJsonObject.ReadFrom(ResponseText);
        ResponseJsonObject.Get('value', ValueJsonToken);
    end;

    local procedure GetFiledValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;
}