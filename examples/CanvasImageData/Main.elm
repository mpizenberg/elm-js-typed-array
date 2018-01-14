port module Main exposing (..)

import AnimationFrame
import Color
import Color.Colormaps exposing (Colormap)
import JsTypedArray
import JsUint8Array
import Json.Encode as Encode
import Time exposing (Time)


-- import Json.Encode as Encode


main : Program Flags Model Msg
main =
    Platform.programWithFlags
        { init = init
        , update = update
        , subscriptions = \_ -> AnimationFrame.diffs TimeToUpdateCanvas
        }


type alias Flags =
    { canvasSize : ( Int, Int ) }


type alias Model =
    { dataLength : Int
    , colorIndex : Float
    , direction : Direction
    }


type Direction
    = Forward
    | Backward


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( width, height ) =
            flags.canvasSize
    in
    ( Model (4 * width * height) 0 Forward
    , Cmd.none
    )


type Msg
    = TimeToUpdateCanvas Time


port setCanvasData : Encode.Value -> Cmd msg


colormap : Colormap
colormap =
    Color.Colormaps.viridis


colormapLoopDuration : Time
colormapLoopDuration =
    2 * Time.second


update : Msg -> Model -> ( Model, Cmd Msg )
update (TimeToUpdateCanvas timeDiff) model =
    let
        newColorIndex =
            case model.direction of
                Forward ->
                    min 1 (model.colorIndex + timeDiff / colormapLoopDuration)

                Backward ->
                    max 0 (model.colorIndex - timeDiff / colormapLoopDuration)

        direction =
            case newColorIndex of
                0 ->
                    Forward

                1 ->
                    Backward

                _ ->
                    model.direction

        color =
            Color.toRgb (colormap newColorIndex)

        canvasData =
            JsUint8Array.initialize model.dataLength <|
                \id ->
                    case id % 4 of
                        0 ->
                            color.red

                        1 ->
                            color.green

                        2 ->
                            color.blue

                        _ ->
                            255
    in
    ( { model | colorIndex = newColorIndex, direction = direction }
    , setCanvasData (JsTypedArray.encode canvasData)
    )
