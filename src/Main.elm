module Main exposing (..)

import Html exposing (Html, text, div, span, p)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Random


---- MODEL ----


type State
    = Init
    | Drawed


type alias Fortune =
    String


type alias Model =
    { state : State, fortune : Fortune }


init : ( Model, Cmd Msg )
init =
    ( { state = Init, fortune = "吉" }, Cmd.none )



---- UPDATE ----


type Msg
    = DrawFortune
    | NewFortune String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DrawFortune ->
            ( model
            , Random.generate NewFortune <|
                Random.map
                    (\n ->
                        Maybe.withDefault "エラー" <|
                            List.head <|
                                List.drop n pattern
                    )
                <|
                    (Random.int 0 <| (List.length pattern - 1))
            )

        NewFortune fortune ->
            ( { model | state = Drawed, fortune = fortune }, Cmd.none )


pattern : List String
pattern =
    [ "大吉", "吉", "中吉", "小吉", "末吉", "凶", "大凶" ]



---- VIEW ----


view : Model -> Html Msg
view { state, fortune } =
    case state of
        Init ->
            div [ class "omikuji", onClick DrawFortune ]
                [ div [ class "omikuji-inner" ]
                    [ div
                        [ class "title-elm" ]
                        [ span [ class "title-e" ] [ text "え" ]
                        , span [ class "title-l" ] [ text "る" ]
                        , span [ class "title-m" ] [ text "む" ]
                        ]
                    , span [ class "title" ] [ text "おみくじ" ]
                    ]
                ]

        Drawed ->
            div [ class "omikuji" ]
                [ div [ class "omikuji-unsei-inner" ]
                    [ span [ class "omikuji-unsei" ] [ text "運勢" ]
                    , span [ class "omikuji-fortune" ] [ text fortune ]
                    ]
                ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
