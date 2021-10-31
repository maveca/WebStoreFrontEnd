page 50103 "Ledger Entires"
{

    Caption = 'Ledger Entires';
    PageType = ListPart;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
