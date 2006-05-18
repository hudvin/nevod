unit aspr_api;

interface

uses
  Windows;


Type

  //' Mode status

  TModeStatus = packed record
    IsRegistered,
    IsKeyPresent,
    IsWrongHardwareID,
    IsKeyExpired,
    IsModeExpired,
    IsBlackListedKey : Boolean;
  end;


function  GetRegistrationKeys: PChar; stdcall;

function  GetRegistrationInformation   ( var Key: PChar; var Name: PChar ): Boolean; stdcall;

function  SaveKey                 ( Key: PChar; Name: PChar ): Boolean; stdcall;

function  CheckKey                ( Key: PChar; Name: PChar ): Boolean; stdcall;

function  CheckKeyAndDecrypt      ( Key: PChar; Name: PChar; SaveKey: Boolean ): Boolean; stdcall;

function  GetKeyDate              ( var Day   : WORD;
                                    var Month : WORD;
                                    var Year  : WORD ): Boolean; stdcall;

function  GetKeyExpirationDate    ( var Day   : WORD;
                                    var Month : WORD;
                                    var Year  : WORD ): Boolean; stdcall;

function  GetTrialDays            ( var Total : DWORD;
                                    var Left  : DWORD ): Boolean; stdcall;

function  GetTrialExecs           ( var Total : DWORD;
                                    var Left  : DWORD ): Boolean; stdcall;

function  GetExpirationDate       ( var Day   : WORD;
                                    var Month : WORD;
                                    var Year  : WORD ): Boolean; stdcall;

function  GetModeInformation      ( var ModeName   : PChar;
                                    var ModeStatus : TModeStatus;
                                        CurrMode   : Boolean ): Boolean; stdcall;

function  GetHardwareID : PChar; stdcall;

function  SetUserKey              ( Key     : Pointer;
                                    KeySize : DWORD ): Boolean; stdcall;


implementation


const
  aspr_ide  = 'aspr_ide.dll';


//------------------------------------------------------------------------------

function  GetRegistrationKeys: PChar; external aspr_ide name 'GetRegistrationKeys';

function  GetRegistrationInformation   ( var Key: PChar; var Name: PChar ): Boolean; external aspr_ide name 'GetRegistrationInformation';

function  SaveKey                 ( Key: PChar; Name: PChar): Boolean; external aspr_ide name 'SaveKey';

function  CheckKey                ( Key: PChar; Name: PChar ): Boolean; external aspr_ide name 'CheckKey';

function  CheckKeyAndDecrypt      ( Key: PChar; Name: PChar; SaveKey: Boolean ): Boolean; external aspr_ide name 'CheckKeyAndDecrypt';

function  GetKeyDate              ( var Day   : WORD;
                                    var Month : WORD;
                                    var Year  : WORD ): Boolean; external aspr_ide name 'GetKeyDate';

function  GetKeyExpirationDate    ( var Day   : WORD;
                                    var Month : WORD;
                                    var Year  : WORD ): Boolean; external aspr_ide name 'GetKeyExpirationDate';

function  GetTrialDays            ( var Total : DWORD;
                                    var Left  : DWORD ): Boolean; external aspr_ide name 'GetTrialDays';

function  GetTrialExecs           ( var Total : DWORD;
                                    var Left  : DWORD ): Boolean; external aspr_ide name 'GetTrialExecs';

function  GetExpirationDate       ( var Day   : WORD;
                                    var Month : WORD;
                                    var Year  : WORD ): Boolean; external aspr_ide name 'GetExpirationDate';

function  GetModeInformation      ( var ModeName   : PChar;
                                    var ModeStatus : TModeStatus;
                                        CurrMode   : Boolean ): Boolean; external aspr_ide name 'GetModeInformation';

function  GetHardwareID : PChar; external aspr_ide name 'GetHardwareID';

function  SetUserKey              ( Key     : Pointer;
                                    KeySize : DWORD ): Boolean; external aspr_ide name 'SetUserKey';

//------------------------------------------------------------------------------

end.