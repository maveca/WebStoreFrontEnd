page 50101 "Store Items"
{

    ApplicationArea = All;
    Caption = 'Store Items';
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the value of the Inventory field.';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(Info; "Store Info")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
            part(LedgerEntries; "Ledger Entires")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Group)
            {
                Caption = 'My group';
                action(DemoAction)
                {
                    ApplicationArea = All;
                    ToolTip = 'My Demo Action';
                    Image = PostedReceipt;
                    ShortcutKey = 'Return';
                    Scope = Repeater;


                    trigger OnAction()
                    begin
                        Message('Hello World');
                    end;
                }
            }
        }
    }
}
