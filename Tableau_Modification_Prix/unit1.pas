unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, sqldb, db, Forms, Controls,
  Graphics, Dialogs, DBGrids, DBCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Btn_Connecter: TButton;
    Btn_Afficher: TButton;
    Btn_Nouveau_prix: TButton;
    ComboBox_Commune: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    MySQL80Connection1: TMySQL80Connection;
    SQLQuery3: TSQLQuery;
    SQLQuery4: TSQLQuery;
    SQLTransaction2: TSQLTransaction;
    ZT_Id_Bien: TEdit;
    ZT_Genre: TEdit;
    ZT_Lieu: TEdit;
    ZT_Prix: TEdit;
    ZT_Superficie: TEdit;
    ZT_Num_Bien: TEdit;
    ZT_Augmentation: TEdit;
    ZT_Diminution: TEdit;
    ZT_Prix_Moyen: TEdit;
    Label_Commune: TLabel;
    Label_Diminution: TLabel;
    Label_Prix_Moyen: TLabel;
    Label_Connected: TLabel;
    Label_Id_Bien: TLabel;
    Label_Genre: TLabel;
    Label_Lieu: TLabel;
    Label_Superficie: TLabel;
    Label_Prix: TLabel;
    Label_Num_Bien: TLabel;
    Label_Augmentation: TLabel;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Btn_AfficherClick(Sender: TObject);
    procedure Btn_ConnecterClick(Sender: TObject);
    procedure Btn_Nouveau_prixClick(Sender: TObject);
    procedure ComboBox_CommuneSelect(Sender: TObject);



    // Reuse the procedure for some requests
    procedure showAllBiens();
    procedure showOnlyCommune();
    procedure ShowTotalPrice();
    procedure SQLQuery1AfterDelete(DataSet: TDataSet);
    procedure SQLQuery1AfterPost(DataSet: TDataSet);

  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.showAllBiens();
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.TEXT := 'SELECT * FROM bien WHERE estValide = 1';
  SQLQuery1.Open;
end;

procedure TForm1.showOnlyCommune();
begin
  // Clear the comboBox
  ComboBox_Commune.Clear;

  // Create a field Tous
  ComboBox_Commune.Items.Add('Tous');

  SQLQuery2.SQL.Text := 'SELECT DISTINCT commune FROM bien WHERE estValide = 1';
  SQLQuery2.Open;
  SQLQuery2.First;

  // A do loop adds each single data in the dropdown menu
  while(NOT SQLQuery2.EOF) do
    begin
      ComboBox_Commune.Items.Add(SQLQuery2.Fields.Fields[0].AsString);
      SQLQuery2.Next;
    end;
  // Close the query and commit in DB
  SQLQuery2.Close;
  SQLTransaction2.Commit;
end;

procedure TForm1.ShowTotalPrice();
begin
  SQLQuery4.Close;
  SQLQuery4.SQL.Text := 'SELECT SUM(prix) AS TotalPrix FROM bien WHERE estValide = 1' ;
  SQLQuery4.Open;

  if Not SQLQuery4.EOF then
   begin
     ZT_Prix_Moyen.Text := SQLQuery4.FieldByName('TotalPrix').asString;
   end
  else
   begin
     ZT_Prix_Moyen.Text := '0';
   end;
  SQLQuery4.Close;
end;

procedure TForm1.SQLQuery1AfterDelete(DataSet: TDataSet);
var idBienDelete: Integer;
begin
  // Create variable with id from DBGrid
  idBienDelete := DBGrid1.Columns[0].Field.AsInteger;
  idBienDelete := idBienDelete -1;

  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'UPDATE bien SET estValide = 0 WHERE idBien ='+idBienDelete.ToString()+';';
  SQLQuery1.ExecSQL;

  // Reuse procedure
  showAllBiens;
  showOnlyCommune;

  // Update this procedure
  SQLQuery1.ApplyUpdates();
end;

procedure TForm1.SQLQuery1AfterPost(DataSet: TDataSet);
begin
  // Update This procedure
  SQLQuery1.ApplyUpdates();
    // Reuse procedure
  showOnlyCommune;
end;

procedure TForm1.Btn_ConnecterClick(Sender: TObject);
begin
  // Data for DB connection
  MySQL80Connection1.DatabaseName :='locationsbiens';
  MySQL80Connection1.UserName :='root';

  // Connect on Mysql
  MySQL80Connection1.Open;

  // If fail on connection write message
  if Not MySQL80Connection1.Connected then
    begin
      ShowMessage('Connexion échouée!');
      Exit;
    end;

  // if connected show label Connected
  Label_Connected.Visible:= True;

  // Reuse procedure to select all data from table: bien
  showAllBiens;

  // Reuse procedure to select Only Commune
  showOnlyCommune;
end;

procedure TForm1.Btn_Nouveau_prixClick(Sender: TObject);
// Declare variable for the procedure
var taux_Pourcentage, nouveau_Prix, ancien_Prix : double;
var procedure_Id_Bien, procedure_prix : string;
begin
 if ZT_Num_Bien.Text = '' then
  ShowMessage('Entrez un ID du bien')
 else if (ZT_Augmentation.Text = '') and (ZT_Diminution.Text = '') then
  ShowMessage(' Entrez un nombre pour dans le champs Augmentation ou Diminution')
 else
  begin
   // Recup the value from ZT_Num_Bien
   procedure_Id_Bien := QuotedStr(ZT_Num_Bien.Text);

   SQLQuery3.Close;
   SQLQuery3.SQL.Text := 'SELECT prix FROM bien WHERE idBien = '+procedure_Id_Bien;
   SQLQuery3.Open;

   ancien_Prix := SQLQuery3.Fields.Fields[0].AsFloat;
   SQLQuery3.Close;

   if (ZT_Augmentation.Text <> '') and (ZT_Diminution.Text <> '') then
    ShowMessage('Vous ne pouvez pas augmenter et diminuer en même temps')
   else
    begin
     // calculates the price increase
     if ZT_Augmentation.Text <> '' then
      begin
       // Calculates the rate of change
       taux_Pourcentage := 1.0 + (StrToFloat(ZT_Augmentation.Text) / 100);
       // Converts the rate of evolution to a string with 2 decimal places
      end
    end;

    // Calculates the price decrease
    if ZT_Diminution.Text <> '' then
     begin
      // Calculates the rate of change
      taux_Pourcentage := 1.0 - (StrToFloat(ZT_Diminution.Text) / 100);
      // Converts the rate of evolution to a string with 2 decimal places
     end;

    // TODO
    nouveau_Prix := ancien_Prix * taux_Pourcentage;
    str(nouveau_Prix:10:2, procedure_prix);

    // procedure call stored in db
    SQLTransaction1.Rollback;

    // Start the transaction
    SQLTransaction1.StartTransaction;

    // Attribute a variable and execute the request
    MySQL80Connection1.ExecuteDirect('set @p0 =' +procedure_Id_Bien);
    MySQL80Connection1.ExecuteDirect('set @p1 =' +procedure_prix);

    // Call the stored procedure
    MySQL80Connection1.ExecuteDirect('call changer_prix(@p0, @p1)');
    SQLTransaction1.Commit;

    // Reuse procedures
    showAllBiens;
    ShowTotalPrice;
  end

end;

procedure TForm1.Btn_AfficherClick(Sender: TObject);
begin
  // Show All datas from a select inside the DBGrid
  ZT_Id_Bien.Text := DBGrid1.Columns[0].Field.Text;
  ZT_Genre.Text := DBGrid1.Columns[1].Field.Text;
  ZT_Lieu.Text := DBGrid1.Columns[2].Field.Text;
  ZT_Prix.Text := DBGrid1.Columns[3].Field.Text;
  ZT_Superficie.Text := DBGrid1.Columns[4].Field.Text;
end;

procedure TForm1.ComboBox_CommuneSelect(Sender: TObject);
begin
  // Close the request
  SQLQuery1.Close;
  // If the dropmenu is Tous select all datas
  if ComboBox_Commune.Text = 'Tous' then
    begin
      showAllBiens;
    end
  else
   begin
    // Else select only the data selected
    SQLQuery1.Close;
    SQLQuery1.SQL.TEXT := 'SELECT * FROM bien WHERE estValide = 1 AND commune ="'+ComboBox_Commune.Text+'" ';
    SQLQuery1.Open;
   end
end;

end.

