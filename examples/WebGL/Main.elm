port module Main exposing (..)

import AnimationFrame
import JsFloat32Array
import JsTypedArray exposing (Float32, JsTypedArray)
import Json.Encode as Encode
import Time exposing (Time)


-- import Json.Encode as Encode


main : Program Flags Model Msg
main =
    Platform.programWithFlags
        { init = init
        , update = update
        , subscriptions = \_ -> AnimationFrame.diffs DrawNewFrame
        }


type alias Flags =
    { canvasSize : ( Int, Int ) }


type alias Model =
    { projectionMatrix : JsTypedArray Float32 Float
    , motionMatrix : JsTypedArray Float32 Float
    , rotationAngle : Float
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( width, height ) =
            flags.canvasSize

        aspectRatio =
            toFloat width / toFloat height
    in
    ( { projectionMatrix = projectionMatrix aspectRatio
      , motionMatrix = motionMatrix ( 0, 0, -6 ) 0
      , rotationAngle = 0
      }
    , initWebGl
        { vertexShaderSource = vertexShaderSource
        , fragmentShaderSource = fragmentShaderSource
        , positions = JsTypedArray.encode positions
        , colors = JsTypedArray.encode colors
        , vertexCount = vertexCount
        }
    )


type Msg
    = DrawNewFrame Time


update : Msg -> Model -> ( Model, Cmd Msg )
update (DrawNewFrame deltaTime) model =
    let
        rotationAngle =
            model.rotationAngle + rotationSpeed * deltaTime

        newMotionMatrix =
            motionMatrix ( 0, 0, -6 ) rotationAngle
    in
    ( { model
        | rotationAngle = rotationAngle
        , motionMatrix = newMotionMatrix
      }
    , drawScene
        { projection = JsTypedArray.encode model.projectionMatrix
        , motion = JsTypedArray.encode newMotionMatrix
        }
    )


projectionMatrix : Float -> JsTypedArray Float32 Float
projectionMatrix aspectRatio =
    let
        focal =
            1 / tan (fieldOfView / 2)

        zRatio =
            1 / (zNear - zFar)
    in
    JsFloat32Array.fromList
        [ focal / aspectRatio
        , 0
        , 0
        , 0
        , 0
        , focal
        , 0
        , 0
        , 0
        , 0
        , (zFar + zNear) * zRatio
        , -1
        , 0
        , 0
        , (2 * zFar * zNear) * zRatio
        , 0
        ]


motionMatrix : ( Float, Float, Float ) -> Float -> JsTypedArray Float32 Float
motionMatrix ( x, y, z ) rotationAngle =
    let
        ( c, s ) =
            ( cos rotationAngle, sin rotationAngle )
    in
    JsFloat32Array.fromList
        [ c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, x, y, z, 1 ]



-- PORTS #############################################################


port initWebGl : InitialWebGlValues -> Cmd msg


type alias InitialWebGlValues =
    { vertexShaderSource : String
    , fragmentShaderSource : String
    , positions : Encode.Value
    , colors : Encode.Value
    , vertexCount : Int
    }


port drawScene : Camera -> Cmd msg


type alias Camera =
    { projection : Encode.Value
    , motion : Encode.Value
    }



-- CONSTANTS #########################################################


rotationSpeed : Float
rotationSpeed =
    2 * pi / (5 * Time.second)


fieldOfView : Float
fieldOfView =
    45 * pi / 180


zNear : Float
zNear =
    0.1


zFar : Float
zFar =
    100


vertexCount : Int
vertexCount =
    4


{-| square corner positions
-}
positions : JsTypedArray Float32 Float
positions =
    JsFloat32Array.fromList
        [ 1, 1, -1, 1, 1, -1, -1, -1 ]


{-| white, red, green, blue
-}
colors : JsTypedArray Float32 Float
colors =
    JsFloat32Array.fromList
        [ 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1 ]


vertexShaderSource : String
vertexShaderSource =
    """
attribute vec4 aVertexPosition;
attribute vec4 aVertexColor;

uniform mat4 uMotionMatrix;
uniform mat4 uProjectionMatrix;

varying lowp vec4 vColor;

void main(void) {
    gl_Position = uProjectionMatrix * uMotionMatrix * aVertexPosition;
    vColor = aVertexColor;
}
    """


fragmentShaderSource : String
fragmentShaderSource =
    """
varying lowp vec4 vColor;

void main(void) {
    gl_FragColor = vColor;
}
    """
