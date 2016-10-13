import Html exposing (Html, button, div, text)
import Html.App as App
import Html.Events exposing (onClick)

main =
    App.beginnerProgram { model = modelDefault, view = view, update = update }

type alias Model = Int

modelDefault: Model
modelDefault =
    0

type Msg = Increment | Decrement | Reset

update: Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        Reset ->
            modelDefault

view: Model -> Html Msg
view model =
    div []
        [
            button [ onClick Decrement ] [ text "-" ],
            div [] [ text ( toString model ) ],
            button [ onClick Increment ] [ text "+"],
            button [ onClick Reset ] [ text "Reset"]
        ]

