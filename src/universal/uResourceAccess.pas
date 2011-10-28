unit uResourceAccess;

interface

uses
  Windows, SysUtils, Classes, Graphics, GIFImg, JPEG, PNGImage;

type
  TImgType = (iBitmap, iIcon, iGIF, iJPEG, iPNG);

  function IsSupportedImg(FileExt: String): Boolean;
  function GetImgType(FileExt: String): TImgType;
  function CreateGraphic(ImgType: TImgType): TGraphic; overload;
  function CreateGraphic(FileExt: String): TGraphic; overload;
  function GetImageFromResource(ResID: Integer; ImgType: TImgType): TGraphic;

const
  SupportedImages: array[0..5] of String = ('bmp', 'ico', 'jpeg', 'jpg', 'gif', 'png');


implementation


function IsSupportedImg(FileExt: String): Boolean;
var i: Integer;
begin
  Result := false;
  for i := 0 to High(SupportedImages) do
  begin
    if (FileExt = SupportedImages[i]) then
    begin
      Result := true;
      Break;
    end;
  end;
end;

function GetImgType(FileExt: String): TImgType;
begin
  FileExt := LowerCase(FileExt);
  if FileExt = 'bmp' then
    Result := iBitmap
  else if FileExt = 'ico' then
    Result := iIcon
  else if (FileExt = 'jpg') or (FileExt = 'jpeg') then
    Result := iJPEG
  else if FileExt = 'gif' then
    Result := iGIF
  else if FileExt = 'png' then
    Result := iPNG
  else Result := iBitmap;
end;

function CreateGraphic(ImgType: TImgType): TGraphic;
begin
  case ImgType of
    iIcon: Result := TIcon.Create;
    iGIF: Result := TGIFImage.Create;
    iJPEG: Result := TJPEGImage.Create;
    iPNG: Result := TPNGObject.Create;
    else Result := TBitmap.Create;
  end;
end;

function CreateGraphic(FileExt: String): TGraphic;
begin
  Result := CreateGraphic(GetImgType(FileExt));
end;

function GetImageFromResource(ResID: Integer; ImgType: TImgType): TGraphic;
var ResStream: TResourceStream;
begin
  case ImgType of
    iIcon: ResStream := TResourceStream.CreateFromID(HInstance, ResID, 'ICO');
    iGIF: ResStream := TResourceStream.CreateFromID(HInstance, ResID, 'GIF');
    iJPEG: ResStream := TResourceStream.CreateFromID(HInstance, ResID, 'JPEG');
    iPNG: ResStream := TResourceStream.CreateFromID(HInstance, ResID, 'PNG');
    else ResStream := TResourceStream.CreateFromID(HInstance, ResID, RT_BITMAP);
  end;

  try
    Result := CreateGraphic(ImgType);
    Result.LoadFromStream(ResStream);
  finally
    ResStream.Free;
  end;
end;

end.
