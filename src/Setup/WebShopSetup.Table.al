table 50100 "Web Shop Setup"
{
    Caption = 'Web Shop Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "BackEnd Web Service URL"; Text[250])
        {
            Caption = 'BackEnd Web Service URL';
            DataClassification = CustomerContent;
        }
        field(3; "BackEnd User Name"; Text[100])
        {
            Caption = 'BackEnd User Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "BackEnd Password"; Text[100])
        {
            Caption = 'BackEnd Password';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = Masked;
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
