/// <summary>
/// Page Retail RC (ID 50104).
/// </summary>
page 50104 "Retail RC"
{

    Caption = 'Retail RC';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Retail Headline")
            {
                ApplicationArea = All;
            }
            part(RetailQueue; "Retail Queue")
            {
                ApplicationArea = All;
            }
        }
    }

}
