/// <summary>
/// Page Web Shop Setup (ID 50100).
/// </summary>
page 50100 "Web Shop Setup"
{

    Caption = 'Web Shop Setup';
    PageType = Card;
    SourceTable = "Web Shop Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
    AdditionalSearchTerms = 'Web Store Setup,Online Store Setup';

    layout
    {
        area(content)
        {
            group(BackEndWebService)
            {
                Caption = 'BackEnd Web Service';
                field("BackEnd Web Service URL"; Rec."BackEnd Web Service URL")
                {
                    Caption = 'Web Service URL';
                    ToolTip = 'Specifies the value of the BackEnd Web Service URL field.';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                group(BackEndWebServiceCredentials)
                {
                    Caption = 'Credentials';
                    field("BackEnd User Name"; Rec."BackEnd User Name")
                    {
                        Caption = 'User Name';
                        ToolTip = 'Specifies the value of the BackEnd User Name field.';
                        ApplicationArea = All;
                    }
                    field("BackEnd Password"; Rec."BackEnd Password")
                    {
                        Caption = 'Password';
                        ToolTip = 'Specifies the value of the BackEnd Password field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."BackEnd Web Service URL" := 'https://<servername>/<service>/api/1.0';
            Rec.Insert();
        end;
    end;

}
