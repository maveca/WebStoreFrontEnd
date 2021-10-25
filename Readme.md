# Topic 1

This is my first topic.

## Topic level 2

This is my first topic.

### Topic level 3

This is my first topic.

> This is very important.

[Google](www.google.com)

```pas
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
```

[Index](.\help\Index.md)