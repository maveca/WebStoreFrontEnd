/// <summary>
/// Page Retail Queue (ID 50105).
/// </summary>
page 50105 "Retail Queue"
{

    Caption = 'Retail Queue';
    PageType = CardPart;
    SourceTable = "Retail Cue";

    layout
    {
        area(content)
        {
            cuegroup(Transport)
            {
                Caption = 'Transport';
                field("No. of Items"; Rec."No. of Items")
                {
                    ToolTip = 'Specifies the value of the No. of Items field.';
                    ApplicationArea = All;
                    DrillDownPageID = "Store Items";
                }
                field("No. of Chairs"; Rec."Chairs")
                {
                    ToolTip = 'Specifies the value of the No. of Chairs field.';
                    ApplicationArea = All;
                    DrillDownPageID = "Store Items";
                }
            }

            cuegroup(Furniture)
            {
                Caption = 'Furniture';
                field("No. of Items2"; Rec."No. of Items")
                {
                    ToolTip = 'Specifies the value of the No. of Items field.';
                    ApplicationArea = All;
                    DrillDownPageID = "Store Items";
                }
                field("No. of Chairs2"; Rec."Chairs")
                {
                    ToolTip = 'Specifies the value of the No. of Chairs field.';
                    ApplicationArea = All;
                    DrillDownPageID = "Store Items";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}
