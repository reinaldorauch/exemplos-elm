import Html exposing (Html, Attribute, div, button, input, text, ol, li)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import List

main =
    App.beginnerProgram { model = modelDefault, view = view, update = update }

type alias Model = { content: String, lista: List String }

modelDefault: Model
modelDefault =
    {
        content = "",
        lista = []
    }

type Msg = Change String | Reset | AddToList

update: Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            changeContent newContent model
        Reset ->
            modelDefault
        AddToList ->
            addToList model.content model

changeContent: String -> Model -> Model
changeContent newContent model =
    { model | content = newContent }

addToList: String -> Model -> Model
addToList newContent model =
    { model | lista = (model.lista ++ [ newContent ]) }

view: Model -> Html Msg
view model =
    div [] [
        input [ placeholder "Text to reverse", onInput Change, value model.content ] [],
        div [] [ text (String.reverse model.content) ],
        div [] [ ol [] (List.map insertIntoLis model.lista) ],
        button [ onClick Reset ] [ text "Reset" ],
        button [ onClick AddToList ] [ text "Adicionar valor a lista" ]
    ]

insertIntoLis: String -> Html Msg
insertIntoLis string  =
    li [] [ text string ]
