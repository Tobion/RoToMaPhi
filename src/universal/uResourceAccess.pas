unit uResourceAccess;

interface

uses
  Windows, Classes, Graphics, GIFImg, JPEG;

type
  TImgType = (iBitmap, iGIF, iJPEG);

function GetImageFromResource(ResID: Integer; ImgType: TImgType): TGraphic;

implementation

function GetImageFromResource(ResID: Integer; ImgType: TImgType): TGraphic;
var ResStream: TResourceStream;
begin
  if (ImgType = iGIF) then
    ResStream := TResourceStream.CreateFromID(HInstance, ResID, 'GIF')
  else if (ImgType = iJPEG) then
    ResStream := TResourceStream.CreateFromID(HInstance, ResID, 'JPEG')
  else
    ResStream := TResourceStream.CreateFromID(HInstance, ResID, RT_BITMAP);

  try
    if (ImgType = iGIF) then
      Result := TGIFImage.Create
    else if (ImgType = iJPEG) then
      Result := TJPEGImage.Create
    else
      Result := TBitmap.Create;

    Result.LoadFromStream(ResStream);
  finally
    ResStream.Free;
  end;
end;

end.
