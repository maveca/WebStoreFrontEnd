/// <summary>
/// Page Retail Headline (ID 50106).
/// </summary>
page 50106 "Retail Headline"
{

    Caption = 'Retail Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            //group(Control1)
            //{
            // ShowCaption = false;
            field(GreetingText; 'Hi customer!')
            {
                ApplicationArea = All;
                Caption = 'Greeting headline';
                Editable = false;
            }
            field(GreetingText2; 'Please pick your Item Group.')
            {
                ApplicationArea = All;
                Caption = 'Greeting headline';
                Editable = false;
            }
            //}
        }
    }

}
