codeunit 70241761 UpdateContactFromCustomer59FDW
{
    Access = Internal;
    internal procedure InsertNewContactPersonShipToAddress(var ShipToAddressCapSetup: Record ShipToAddressCapSetup59FDW)
    var
        ContactCompany: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        MarketingSetup: Record "Marketing Setup";
        Customer: Record Customer;
    begin
        MarketingSetup.Get();
        MarketingSetup.TestField("Bus. Rel. Code for Customers");

        Customer.Get(ShipToAddressCapSetup."Customer No.");
        ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SetRange("No.", Customer."No.");
        if ContactBusinessRelation.FindFirst() then
            if ContactCompany.Get(ContactBusinessRelation."Contact No.") then begin
                Contact.Init();
                Contact."No." := '';
                Contact.Validate(Type, Contact.Type::Person);
                Contact.Insert(true);
                Contact."Company No." := ContactCompany."No.";
                Contact.Validate(Name, ShipToAddressCapSetup."Call Plan Contact Name");
                Contact.InheritCompanyToPersonData(ContactCompany);
                Contact.UpdateBusinessRelation();
                Contact.Modify(true);
                ShipToAddressCapSetup."Call Plan Contact Code" := Contact."No.";
            end;
    end;
}