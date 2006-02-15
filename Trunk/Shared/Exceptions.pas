unit Exceptions;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
  EInvalidAccountParams = class(Exception)
  private
    FMessage: string;
  public
    constructor Create(ErrorMessage: string); 
    property Message: string read FMessage write FMessage;
  end;

  EDatabaseError = class(Exception)
  end;

  EInvalidAccount = class(Exception)
  end;

  EUnknownError = class(Exception)
  end;

implementation

{
**************************** EInvalidAccountParams *****************************
}
constructor EInvalidAccountParams.Create(ErrorMessage: string);
begin
  FMessage:=ErrorMessage; 
  inherited Create(ErrorMessage);
end;


end.
