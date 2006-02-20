unit Exceptions;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
  EInvalidAccountParams = class(Exception);
  EDatabaseError = class(Exception);
  EInvalidAccount = class(Exception) ;
  EUnknownError = class(Exception);
  ECorreptedAccount=class(Exception);
  EDBerror = class(Exception);

implementation


end.
