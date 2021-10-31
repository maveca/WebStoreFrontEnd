/// <summary>
/// Codeunit Password (ID 50102).
/// </summary>
codeunit 50102 Password
{
    SingleInstance = true;

    trigger OnRun()
    begin
        StorePassword('admin', 'Pa$$word');
        if HasUser('admin') then
            Message('%1', GetPassword('admin'))
        else
            Message('admin user does not exists');
    end;

    local procedure HasUser(User: Text): boolean
    begin
        exit(IsolatedStorage.Contains(User));
    end;

    local procedure StorePassword(User: Text; Pwd: Text): boolean
    begin
        // https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-encrypting-data
        if EncryptionEnabled() then
            exit(IsolatedStorage.SetEncrypted(User, Pwd))
        else
            exit(IsolatedStorage.Set(User, Pwd));
    end;

    local procedure GetPassword(User: Text) Pwd: Text
    begin
        IsolatedStorage.Get(User, Pwd);
        exit(Pwd);
    end;

}