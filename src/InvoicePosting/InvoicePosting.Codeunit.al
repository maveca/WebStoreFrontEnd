/// <summary>
/// Codeunit InvoicePosting (ID 50101).
/// </summary>
codeunit 50101 "InvoicePosting"
{
    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateOrder(SalesHeader);
        PostOrder(SalesHeader);
        CreatePayment(SalesHeader);
        OpenPostedSalesInvoice(SalesHeader);
    end;

    local procedure CreateOrder(var SalesHeader: Record "Sales Header")
    begin
        CreateSalesHeader(SalesHeader, '21245278');

        CreateSalesLine(SalesHeader, 10000, '1001', 3, 100);
        CreateSalesLine(SalesHeader, 20000, '1100', 2, 200);
        CreateSalesLine(SalesHeader, 30000, '1110', 5, 300);
    end;

    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        SalesHeader.Validate("Posting Date", Today());
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; NewLineNo: Integer; ItemNo: Code[20]; Qty: Integer; UnitPrice: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Validate("Unit Price", UnitPrice);
        SalesLine.Validate("Qty. to Ship", Qty);

        SalesLine.Modify(true);
    end;

    local procedure PostOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        Codeunit.Run(CODEUNIT::"Sales-Post", SalesHeader);
    end;

    local procedure OpenPostedSalesInvoice(var SalesHeader: Record "Sales Header")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then
            Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHeader);
    end;

    local procedure CreatePayment(var SalesHeader: Record "Sales Header")
    var
        GenJournalLine: Record "Gen. Journal Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if FindPostedSalesInvoice(SalesHeader, SalesInvoiceHeader) then begin

            SalesInvoiceHeader.CalcFields("Amount Including VAT");
            GenJournalLine.Init();

            GenJournalLine.Validate("Posting Date", Today());
            GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.Validate("Document No.", CopyStr('PAY-' + SalesInvoiceHeader."No.", 1, MaxStrLen(GenJournalLine."Document No.")));
            GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
            GenJournalLine.Validate("Account No.", SalesHeader."Sell-to Customer No.");
            GenJournalLine.Validate("Currency Code", SalesInvoiceHeader."Currency Code");
            GenJournalLine.Validate("Payment Method Code", 'CASH');
            GenJournalLine.Validate("Amount", -SalesInvoiceHeader."Amount Including VAT");
            GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
            GenJournalLine.Validate("Applies-to Doc. No.", SalesInvoiceHeader."No.");
            GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
            GenJournalLine.Validate("Bal. Account No.", 'WWB-OPERATING');

            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Line", GenJournalLine);
        end;
    end;

    local procedure FindPostedSalesInvoice(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    begin
        SalesInvoiceHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesInvoiceHeader.SetRange("Order No.", SalesHeader."No.");
        SalesInvoiceHeader.SetRange("Posting Date", SalesHeader."Posting Date");
        exit(SalesInvoiceHeader.FindFirst());
    end;
}
