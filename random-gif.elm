import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import String
import Task

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { topic: String
  , gifUrl: String
  , fetchError: Maybe String
  }

type Msg
  = MorePlease
  | UpdateTopic String
  | FetchSucceed String
  | FetchFail Http.Error

init: (Model, Cmd Msg)
init =
  (Model "cats" "waiting.gif" Nothing, Cmd.none)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateTopic newTopic ->
      (Model newTopic model.gifUrl Nothing, Cmd.none)

    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl Nothing, Cmd.none)

    FetchFail error ->
      (Model model.topic model.gifUrl (generateErrorMessage error), Cmd.none)

generateErrorMessage: Http.Error -> Maybe String
generateErrorMessage error =
  case error of
    Http.Timeout ->
      Just "The remote server didn't responded in time"

    Http.NetworkError ->
      Just "Network fail, check your connection"

    Http.UnexpectedPayload responseString ->
      Just ("Invalid response from the remove server: " ++ responseString)

    Http.BadResponse code errorString ->
      Just ("Http error: [" ++ (toString code) ++ "] " ++ errorString)

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.none

view: Model -> Html Msg
view model =
  div []
    [ h2 [] [ text model.topic ]
    , p []
        [img [ src model.gifUrl ] []
        ]
    , fetchError model
    , p []
        [ select [ onInput UpdateTopic ]
          [ option [ value "cats", selected (model.topic == "cats") ] [ text "Cats" ]
          , option [ value "anime", selected (model.topic == "anime") ] [ text "Anime" ]
          , option [ value "sex", selected (model.topic == "sex")] [ text "Sex" ]
          ]
        ]
    , p []
        [button [ onClick MorePlease ] [ text "More Please!" ]
        ]
    ]

fetchError: Model -> Html Msg
fetchError model =
  case model.fetchError of
    Just error ->
      p [] [ text error ]
    Nothing ->
      p [] []