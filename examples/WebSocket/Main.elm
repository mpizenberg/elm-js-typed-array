port module Main exposing (..)

import Html exposing (..)
import Html.Events
import JsArrayBuffer exposing (JsArrayBuffer)
import JsDataView exposing (JsDataView)
import Json.Decode as Decode
import MutableJsDataView


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Model
    = QuestionNotSentYet
    | QuestionSent
    | QuestionReceived String
    | AnswerSent
    | AnswerReceived String


init : ( Model, Cmd Msg )
init =
    ( QuestionNotSentYet, Cmd.none )


type Msg
    = SendQuestion
    | Question String
    | SendAnswer
    | Answer Decode.Value


question : String
question =
    "What is the answer to the ultimate question of life, the universe, and everything?"


answer : JsDataView
answer =
    JsArrayBuffer.zeros 1
        |> JsDataView.fromBuffer 0 1
        |> Result.withDefault JsDataView.empty
        |> MutableJsDataView.setUint8 0 42


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendQuestion ->
            ( QuestionSent, sendQuestion question )

        Question theQuestion ->
            ( QuestionReceived theQuestion, Cmd.none )

        SendAnswer ->
            ( AnswerSent, sendAnswer (answer |> JsDataView.buffer |> JsArrayBuffer.encode) )

        Answer arrayBufferJsValue ->
            let
                arrayBuffer =
                    JsArrayBuffer.fromValue arrayBufferJsValue
                        |> Maybe.withDefault (JsArrayBuffer.zeros 0)

                dataView =
                    JsDataView.fromBuffer 0 1 arrayBuffer
                        |> Result.withDefault JsDataView.empty

                answerText =
                    JsDataView.getUint8 0 dataView
                        |> Result.map toString
                        |> Result.withDefault "Error reading answer ..."
            in
            ( AnswerReceived answerText, Cmd.none )


port sendQuestion : String -> Cmd msg


port theQuestion : (String -> msg) -> Sub msg


port sendAnswer : Decode.Value -> Cmd msg


port theAnswer : (Decode.Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ theQuestion Question
        , theAnswer Answer
        ]


view : Model -> Html Msg
view model =
    case model of
        QuestionNotSentYet ->
            div []
                [ p [] [ text question ]
                , button [ Html.Events.onClick SendQuestion ] [ text "send question" ]
                ]

        QuestionSent ->
            div []
                [ p [] [ text question ]
                , p [] [ text "Question sent ..." ]
                ]

        QuestionReceived questionText ->
            div []
                [ p [] [ text "The question received:" ]
                , p [] [ text questionText ]
                , button [ Html.Events.onClick SendAnswer ] [ text "send answer" ]
                ]

        AnswerSent ->
            div []
                [ p [] [ text "Answer sent ..." ]
                ]

        AnswerReceived answerText ->
            div []
                [ p [] [ text "The answer is:" ]
                , p [] [ text answerText ]
                ]
