/// <summary>
/// Page Store Info (ID 50102).
/// </summary>
page 50102 "Store Info"
{

    Caption = 'Store Info';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Picture; Rec.Picture)
                {
                    ToolTip = 'Specifies the value of the Picture field.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
