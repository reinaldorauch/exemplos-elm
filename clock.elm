import Html exposing (Html, p, div, button)
import Html.App as App
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model
  = { currentTime: Time
    , ticking: Bool
    }

init : (Model, Cmd Msg)
init =
  (Model 0 True, Cmd.none)


-- UPDATE

type Msg
  = Tick Time
  | StopClock


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (Model newTime True, Cmd.none)
    StopClock ->
      (Model model.currentTime False, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.ticking then
    Time.every second Tick
  else
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  let
    angle =
      turns (Time.inMinutes model.currentTime)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    div []
      [ p []
          [ svg [ viewBox "0 0 100 100", width "300px" ]
            [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
            , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
            ]
          ]
      , p []
          [ button [ onClick StopClock ] [ text "Stop!!" ]
          ]
      ]