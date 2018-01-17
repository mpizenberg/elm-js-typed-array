port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import JsArrayBuffer
import JsTypedArray
import JsUint8Array
import Json.Decode as Decode


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { answer : Maybe Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing, Cmd.none )


type Msg
    = LoadArrayBuffer Decode.Value
    | ArrayBufferLoaded Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadArrayBuffer value ->
            ( model, loadArrayBuffer value )

        ArrayBufferLoaded value ->
            let
                answer =
                    JsArrayBuffer.fromValue value
                        |> Maybe.withDefault (JsArrayBuffer.zeros 0)
                        |> JsUint8Array.fromBuffer 0 1
                        |> Result.withDefault (JsUint8Array.zeros 0)
                        |> JsTypedArray.getAt 0
            in
            ( Model answer, Cmd.none )


port loadArrayBuffer : Decode.Value -> Cmd msg


port arrayBufferLoaded : (Decode.Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    arrayBufferLoaded ArrayBufferLoaded


view : Model -> Html Msg
view model =
    let
        stringAnswer =
            model.answer
                |> Maybe.map toString
                |> Maybe.withDefault ""
    in
    div []
        [ p [] [ text "Load the file 'answer.bin' to know the answer to the ultimate question of life, the universe, and everything" ]
        , input
            [ id "file-input"
            , type_ "file"
            , Decode.at [ "target", "files", "0" ] Decode.value
                |> Decode.map LoadArrayBuffer
                |> Html.Events.on "change"
            ]
            []
        , p [] [ text <| "The answer is ... " ++ stringAnswer ]
        ]
