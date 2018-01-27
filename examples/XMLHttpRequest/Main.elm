port module Main exposing (..)

import Html exposing (..)
import Html.Events
import JsArrayBuffer exposing (JsArrayBuffer)
import JsDataView
import Json.Decode as Decode


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Model
    = NotAskedYet
    | WaitingForAnswer
    | ErrorReceived
    | Answered String


init : ( Model, Cmd Msg )
init =
    ( NotAskedYet, Cmd.none )


type Msg
    = Ask
    | WoopsError
    | TheAnswer Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Ask ->
            ( WaitingForAnswer, ask () )

        WoopsError ->
            ( ErrorReceived, Cmd.none )

        TheAnswer arrayBufferJsValue ->
            let
                arrayBuffer =
                    JsArrayBuffer.fromValue arrayBufferJsValue
                        |> Maybe.withDefault (JsArrayBuffer.zeros 0)

                dataView =
                    JsDataView.fromBuffer 0 1 arrayBuffer
                        |> Result.withDefault JsDataView.empty

                answer =
                    JsDataView.getUint8 0 dataView
                        |> Result.map toString
                        |> Result.withDefault "Error reading answer ..."
            in
            ( Answered answer, Cmd.none )


port ask : () -> Cmd msg


port theAnswer : (Decode.Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    theAnswer TheAnswer


view : Model -> Html Msg
view model =
    let
        stringAnswer =
            case model of
                NotAskedYet ->
                    ""

                WaitingForAnswer ->
                    "waiting for answer ..."

                ErrorReceived ->
                    "Woops there was an error"

                Answered answer ->
                    answer
    in
    div []
        [ p [] [ text "Ask the network to know the answer to the ultimate question of life, the universe, and everything" ]
        , button [ Html.Events.onClick Ask ] [ text "Ask" ]
        , p [] [ text <| "The answer is ... " ++ stringAnswer ]
        ]
