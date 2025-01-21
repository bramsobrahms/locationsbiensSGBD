unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, sqldb, db, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Btn_Connecte: TButton;
    Btn_Disconnect: TButton;
    Btn_Add: TButton;
    Btn_Delete: TButton;
    Btn_Search: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    MySQL80Connection1: TMySQL80Connection;
    SQLTransaction2: TSQLTransaction;
    ZT_2_Name: TEdit;
    ZT_2_Residence: TEdit;
    ZT_2_Communal: TEdit;
    ZT_2_Price: TEdit;
    ZT_2_Area: TEdit;
    Label_2_Name: TLabel;
    Label_2_Residence: TLabel;
    Label_2_Communal: TLabel;
    Label_2_Price: TLabel;
    Label_2_Area: TLabel;
    ZT_Id: TEdit;
    ZT_Name: TEdit;
    ZT_Firstname: TEdit;
    ZT_Residence: TEdit;
    ZT_BirthYear: TEdit;
    Label_Connected: TLabel;
    Label_Id: TLabel;
    Label_Nom: TLabel;
    Label_Firstname: TLabel;
    Label_Residence: TLabel;
    Label_BirthYear: TLabel;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ConnecteClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_SearchClick(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);

    // Reuse many time the procedure
    procedure ShowAllProprietaire();
    procedure ShowAllProprietaireWithBiens();

  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

// Reuse the procedure ShowAllProprietaire;
procedure TForm1.ShowAllProprietaire();
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.TEXT := 'SELECT * FROM propriétaire WHERE estValide = 1;';
  SQLQuery1.Open;
end;

// Reuse the procedure ShowAllProprietaireWithBiens;
procedure TForm1.ShowAllProprietaireWithBiens();
begin
  SQLQuery2.Close;
  SQLQuery2.SQL.TEXT := 'SELECT p.nom, p.domicile, b.commune, b.prix, b.superficie FROM propriétaire p, bien b WHERE p.idPropriétaire = b.idPropriétaire AND p.estValide = 1 AND b.estValide = 1;';
  SQLQuery2.Open;
end;

procedure TForm1.Btn_ConnecteClick(Sender: TObject);
begin
  try
    // Data for connect to DB
    MySQL80Connection1.DatabaseName := 'locationsbiens';
    MySQL80Connection1.UserName := 'root';

  // Connect at the DB
  MySQL80Connection1.Open;

  // Active the labecl connecté
  Label_Connected.Visible := True;
  Label_Connected.Caption := 'connecté';

  // Show all propriétaires
  ShowAllProprietaire;

  // Show all propriétaires with biens
  ShowAllProprietaireWithBiens;
  except
    // Show label with message no connected
    Label_Connected.Caption := 'Non connecté';
    Label_Connected.Visible := True;

    if NOT MySQL80Connection1.Connected then
      ShowMessage('Connection failed');
  end;
end;


procedure TForm1.Btn_DeleteClick(Sender: TObject);
begin
  SQLQuery1.Close;
  // Create a request to update
  SQLQuery1.SQL.Text := 'UPDATE propriétaire SET estValide = 0 WHERE idPropriétaire = '+ZT_id.Text+';';
  // Execut the request
  SQLQuery1.ExecSQL;
  // Commit the transaction
  SQLTransaction1.Commit;

  //Update the DBGrid
  ShowAllProprietaire;
  ShowAllProprietaireWithBiens;

end;

procedure TForm1.Btn_SearchClick(Sender: TObject);
begin
  // Show the data from Select on DBGrid 2
  ZT_2_Name.Text := DBGrid2.Columns[0].Field.Text;
  ZT_2_Residence.Text := DBGrid2.Columns[1].Field.Text;
  ZT_2_Communal.Text := DBGrid2.Columns[2].Field.Text;
  ZT_2_Price.Text := DBGrid2.Columns[3].Field.Text;
  ZT_2_Area.Text := DBGrid2.Columns[4].Field.Text;
end;

procedure TForm1.Btn_AddClick(Sender: TObject);
// Declare variables for the query inserted in the DB
var nom, prenom, adresse, anneeNaissance, estActive: string;
begin
 // All variables with "" a round the zt_Text
 nom := QuotedStr(ZT_Name.Text);
 prenom := QuotedStr(ZT_Firstname.Text);
 adresse := QuotedStr(ZT_Residence.Text);
 anneeNaissance := ZT_BirthYear.Text;
 estActive := '1';

 SQLTransaction1.StartTransaction;

 // Requete to insert new data
 MySQL80Connection1.ExecuteDirect('INSERT INTO propriétaire (prénom, nom, annéeNaissance, domicile, estValide) VALUES ('+prenom+', '+nom+', '+anneeNaissance+', '+adresse+', '+estActive+')');
 SQLTransaction1.Commit;

 // Update the DBGrid
 ShowAllProprietaire;
 ShowAllProprietaireWithBiens;
end;

procedure TForm1.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
var idProprietaireDelete: Integer;
begin
 if Button = nbDelete then
   begin
   // Create variable with id from DBGrid
  idProprietaireDelete := DBGrid1.Columns[0].Field.AsInteger;
  idProprietaireDelete := idProprietaireDelete -1;

  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'UPDATE propriétaire SET estValide = 0 WHERE idPropriétaire ='+idProprietaireDelete.ToString()+';';
  SQLQuery1.ExecSQL;
  SQLTransaction1.Commit;

  // Reuse procedure
  ShowAllProprietaire;
  ShowAllProprietaireWithBiens;

  // Update this procedure
  SQLQuery1.ApplyUpdates();
   end;
end;

end.

