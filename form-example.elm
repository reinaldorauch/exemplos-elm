import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Regex exposing (..)
import String exposing (..)
import Basics exposing (not)

main =
  App.beginnerProgram
    { model = model
    , view = view
    , update = update
    }

-- MODEL

type alias Model =
  { name : String
  , age : String
  , password : String
  , passwordAgain : String
  , showValidation : Bool
  }


model : Model
model =
  Model "" "" "" "" False


-- UPDATE

type Msg
  = Name String
  | Age String
  | Password String
  | PasswordAgain String
  | ShowValidation


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = age }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    ShowValidation ->
      { model | showValidation = True }

-- VIEW

view : Model -> Html Msg
view model =
  bootstrapContainer [ stylesheet
                     , bootstrapPageHeader "Example with bootstrap"
                     , Html.form [ class "form" ]
                        [ bootstrapInput [ type' "text", placeholder "Name", onInput Name ]
                        , bootstrapInput [ type' "number", placeholder "Age", onInput Age ]
                        , bootstrapInput [ type' "password", placeholder "Password", onInput Password ]
                        , bootstrapInput [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ]
                        , viewValidation model
                        , button [ class "btn btn-primary pull-right", type' "submit", onClick ShowValidation ] [ text "Save!" ]
                        ]
                     ]

bootstrapContainer: List (Html Msg) -> Html Msg
bootstrapContainer content =
  div [ class "container" ] content

bootstrapPageHeader: String -> Html Msg
bootstrapPageHeader content =
  div [ class "page-header" ]
    [ h1 [] [ text content]
    ]

bootstrapInput: List (Html.Attribute Msg) -> Html Msg
bootstrapInput extraAttributes =
  div [ class "form-group" ]
    [ input (extraAttributes ++ [ class "form-control" ]) []
    ]

stylesheet: Html Msg
stylesheet =
  let
    tag = "link"
    attrs =
      [ attribute "rel"       "stylesheet"
      , attribute "property"  "stylesheet"
      , attribute "href"      "bootstrap.min.css"
      ]
    children = []
  in
    node tag attrs children

viewValidation : Model -> Html Msg
viewValidation model =
  let
    (color, message) =
      if not (passwordMatches model) then
        ("red", "Passwords do not match!")
      else if not (passwordHasMinLength model) then
        ("red", "Password has less than 8 characters")
      else if not (passowordHaveNeededCharacters model) then
        ("red", "Password must have at least one lower case upper case and numeric character")
      else if not (ageIsNumeric model) then
        ("red", "Age must be a numeric value")
      else
        ("green", "OK")
  in
    if model.showValidation then
      div [ style [ ("color", color) ] ] [ text message ]
    else
      div [] []

passwordMatches: Model -> Bool
passwordMatches model =
  model.password == model.passwordAgain

passwordHasMinLength: Model -> Bool
passwordHasMinLength model =
  length model.password >= 8

passowordHaveNeededCharacters: Model -> Bool
passowordHaveNeededCharacters model =
  Regex.contains (regex "[a-z]") model.password
    && Regex.contains (regex "[A-Z]") model.password
    && Regex.contains (regex "\\d") model.password

ageIsNumeric: Model -> Bool
ageIsNumeric model =
  Regex.contains (regex "^\\d+$") model.age