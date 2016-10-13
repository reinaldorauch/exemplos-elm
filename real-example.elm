import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Random

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
  }

-- Model

type alias Model =
  { dieFace: Int
  }

init: (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)

type Msg
  = Roll
  | NewFace Int

-- Update

update: Msg -> Model -> (Model, Cmd Msg)
update msg model=
  case msg of
    Roll ->
      ( model, Random.generate NewFace (Random.int 1 6) )

    NewFace newFace ->
      ({ model | dieFace = newFace }, Cmd.none)

-- Subscriptions

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.none

-- View

view: Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.dieFace)]
    , img [ class ( "dice dice-" ++ (toString model.dieFace) ), src "Die_Faces.png" ] []
    , button [ onClick Roll ] [ text "Roll" ]
    ]
