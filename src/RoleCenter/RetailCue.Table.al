/// <summary>
/// Table Retail Cue (ID 50102).
/// </summary>
table 50102 "Retail Cue"
{
    Caption = 'Retail Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "No. of Items"; Integer)
        {
            Caption = 'All Items';
            FieldClass = FlowField;
            CalcFormula = count(Item);
        }
        field(3; "Chairs"; Integer)
        {
            Caption = 'Chairs';
            FieldClass = FlowField;
            CalcFormula = count(Item where("Item Category Code" = const('CHAIR')));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
