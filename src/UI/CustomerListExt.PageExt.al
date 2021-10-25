// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

/// <summary>
/// PageExtension CustomerListExt (ID 50100) extends Record Customer List.
/// </summary>
pageextension 50100 "CustomerListExt" extends "Customer List"
{
    actions
    {
        addfirst(Action104)
        {
            action(GetWebServiceItemList)
            {
                ApplicationArea = All;
                Caption = 'Get Web Service Item List';
                RunObject = Codeunit WebServiceGet;
                Promoted = true;
                Image = NextRecord;
                PromotedCategory = Process;
                ToolTip = 'Executing Web Service for Web Shop';
            }
        }

    }
}