port module Main exposing (..)

import AnimationFrame
import Color
import Color.Colormaps exposing (Colormap)
import JsTypedArray exposing (JsTypedArray, Uint8)
import JsUint8Array
import Json.Encode as Encode
import MutableJsTypedArray
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
    { canvasData : Encode.Value }


type alias Model =
    { canvasData : JsTypedArray Uint8 Int
    , colorIndex : Float
    , direction : Direction
    }


type Direction
    = Forward
    | Backward


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        data =
            JsUint8Array.fromValue flags.canvasData
                |> Maybe.withDefault (JsUint8Array.zeros 0)
    in
    ( Model data 0 Forward
    , Cmd.none
    )


type Msg
    = TimeToUpdateCanvas Time


port setCanvasData : () -> Cmd msg


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
            model.canvasData
                |> MutableJsTypedArray.unsafeSet dataColorSetter

        dataColorSetter id =
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
    ( { model | canvasData = canvasData, colorIndex = newColorIndex, direction = direction }
    , setCanvasData ()
    )
