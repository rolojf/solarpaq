module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Css
import Css.Global
import DataSource
import Html as HTML
import Html.Styled as Html exposing (Html, div, text)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Events as Events
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as AttrSvg
import Tailwind.Breakpoints as TwBp
import Tailwind.Utilities as Tw
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg
    | ToggleMobileMenu
    | ToggleProfileMenu


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    , showProfileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False
      , showProfileMenu = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )

        ToggleMobileMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )

        ToggleProfileMenu ->
            ( { model | showProfileMenu = not model.showProfileMenu }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : HTML.Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        Html.div
            []
            [ Css.Global.global Tw.globalStyles
            , myNav model |> Html.map toMsg
            , Html.main_
                []
                pageView.body
            , viewFooter
            ]
            |> Html.toUnstyled
    , title = pageView.title
    }


viewFooter : Html msg
viewFooter =
    let
        ligaAlPie : String -> String -> Html msg
        ligaAlPie liga texto =
            div
                [ Attr.css [ Tw.px_5, Tw.py_2 ] ]
                [ Html.a
                    [ Attr.href liga
                    , Attr.css
                        [ Tw.text_base
                        , Tw.text_gray_600
                        , Css.hover [ Tw.text_black ]
                        ]
                    ]
                    [ text texto ]
                ]

        svgSocialIcon : String -> Html msg
        svgSocialIcon superD =
            div
                [ Attr.css [ Tw.h_6, Tw.w_6 ] ]
                [ svg
                    -- [ Svg.Attributes.Attr.css []
                    [ AttrSvg.fill "currentColor"
                    , AttrSvg.viewBox "0 0 24 24"

                    -- aria-hidden="true"
                    ]
                    [ Svg.path
                        [ AttrSvg.fillRule "evenodd"
                        , AttrSvg.d superD
                        , AttrSvg.clipRule "evenodd"
                        ]
                        []
                    ]
                ]

        svgFacebook =
            svgSocialIcon "M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z"

        svgGithub =
            svgSocialIcon "M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"

        svgTwitter =
            svgSocialIcon "M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"

        svgInstagram =
            svgSocialIcon "M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z"

        ligaIcono : String -> String -> SocialIcons -> Html msg
        ligaIcono direccion srCual iconoSocial =
            Html.a
                [ Attr.href direccion
                , Attr.css [ Tw.text_gray_400, Css.hover [ Tw.text_gray_500 ] ]
                ]
                [ Html.span
                    [ Attr.css [ Tw.sr_only ] ]
                    [ text srCual ]
                , case iconoSocial of
                    Facebook ->
                        svgFacebook

                    Instagram ->
                        svgInstagram

                    Twitter ->
                        svgTwitter

                    Github ->
                        svgGithub
                ]
    in
    Html.footer
        []
        [ div
            []
            [ div
                [ Attr.css [ Tw.bg_white, Tw.py_4 ] ]
                []
            , div
                [ Attr.css [ Tw.bg_gray_200 ] ]
                [ div
                    [ Attr.css
                        [ Tw.max_w_7xl
                        , Tw.mx_auto
                        , Tw.py_12
                        , Tw.px_4
                        , Tw.overflow_hidden
                        , TwBp.lg [ Tw.px_8 ]
                        , TwBp.sm [ Tw.px_6 ]
                        ]
                    ]
                    [ Html.nav
                        [ Attr.css
                            [ Tw.neg_mx_5
                            , Tw.neg_my_2
                            , Tw.flex
                            , Tw.flex_wrap
                            , Tw.justify_center
                            ]
                        , Aria.ariaLabel "Footer"
                        ]
                        [ ligaAlPie "#" "About"
                        , ligaAlPie "#" "Blog"
                        , ligaAlPie "#" "Jobs"
                        , ligaAlPie "#" "Press"
                        , ligaAlPie "#" "Accesibility"
                        , ligaAlPie "#" "Partners"
                        ]
                    , div
                        [ Attr.css
                            [ Tw.mt_8
                            , Tw.flex
                            , Tw.justify_center
                            , Tw.space_x_6
                            ]
                        ]
                        [ ligaIcono "facebook.com" "facebook" Facebook
                        , ligaIcono "instagram.com" "Instagram" Instagram
                        , ligaIcono "twitter.com" "Twitter" Twitter
                        , ligaIcono "github.com" "GitHub" Github
                        ]
                    , Html.p
                        [ Attr.css
                            [ Tw.mt_8
                            , Tw.text_center
                            , Tw.text_base
                            , Tw.text_gray_500
                            ]
                        ]
                        [ Html.text "&copy; 2020 Workflow, Inc. All rights reserved." ]
                    ]
                ]
            ]
        ]


type SocialIcons
    = Facebook
    | Instagram
    | Twitter
    | Github


type alias WhereTo =
    { direccion : String, queDice : String }


myNav : Model -> Html Msg
myNav modelo =
    let
        getMenu : List WhereTo
        getMenu =
            [ WhereTo "unoL" "oneM"
            , WhereTo "dosL" "twoM"
            , WhereTo "tresL" "threeM"
            , WhereTo "cuatroL" "fourM"
            ]

        myLogoAndLinks : Html msg
        myLogoAndLinks =
            div
                [ Attr.css [ Tw.flex, Tw.items_center ] ]
                [ div
                    -- EL LOGO
                    [ Attr.css [ Tw.flex_shrink_0 ] ]
                    [ Html.img
                        [ Attr.css [ Tw.h_8, Tw.w_8 ]
                        , Attr.src "https://tailwindui.com/img/logos/workflow-mark-indigo-500.svg"
                        , Attr.alt "Workflow"
                        ]
                        []
                    ]
                , div
                    -- LIGAS DE NAVEGACION
                    [ Attr.css [ Tw.hidden, TwBp.md [ Tw.block ] ] ]
                    [ div
                        [ Attr.css
                            [ Tw.ml_10
                            , Tw.flex
                            , Tw.items_baseline
                            , Tw.space_x_4
                            ]
                        ]
                        (ligasChulas False <| getMenu)
                    ]
                ]

        myHiddenBlock : Html Msg
        myHiddenBlock =
            div
                [ Attr.css
                    [ Tw.hidden
                    , TwBp.md [ Tw.block ]
                    ]
                ]
                [ div
                    [ Attr.css
                        [ Tw.ml_4
                        , Tw.flex
                        , Tw.items_center
                        , TwBp.md [ Tw.ml_6 ]
                        ]
                    ]
                    [ div
                        -- Profile dropdown --
                        [ Attr.css
                            [ Tw.ml_3
                            , Tw.relative
                            ]
                        ]
                        [ div
                            []
                            [ Html.button
                                [ Attr.css
                                    [ Tw.max_w_xs
                                    , Tw.bg_gray_800
                                    , Tw.rounded_full
                                    , Tw.flex
                                    , Tw.items_center
                                    , Tw.text_sm
                                    , Tw.text_white
                                    , Css.focus
                                        [ Tw.outline_none
                                        , Tw.ring_2
                                        , Tw.ring_offset_2
                                        , Tw.ring_offset_gray_800
                                        , Tw.ring_white
                                        ]
                                    ]
                                , Attr.id "user-menu"
                                , Aria.ariaHasPopup "true"
                                , Events.onClick ToggleProfileMenu
                                ]
                                [ Html.span
                                    [ Attr.css [ Tw.sr_only ] ]
                                    [ text "Open user menu" ]
                                , Html.img
                                    [ Attr.css
                                        [ Tw.h_8
                                        , Tw.w_8
                                        , Tw.rounded_full
                                        ]
                                    , Attr.src "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=g09zpRVLoT&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                    , Attr.alt ""
                                    ]
                                    []
                                ]
                            ]
                        , if modelo.showProfileMenu then
                            div
                                [ Attr.css
                                    [ Tw.origin_top_right
                                    , Tw.absolute
                                    , Tw.right_0
                                    , Tw.mt_2
                                    , Tw.w_48
                                    , Tw.rounded_md
                                    , Tw.shadow_lg
                                    , Tw.py_1
                                    , Tw.bg_white
                                    , Tw.ring_1
                                    , Tw.ring_black
                                    , Tw.ring_opacity_5
                                    ]
                                , Aria.role "menu"

                                -- , Aria.aria-orientation "vertical"
                                , Aria.ariaLabelledby "user-menu"
                                ]
                                (menuItems
                                    [ Tw.block
                                    , Tw.px_4
                                    , Tw.py_2
                                    , Tw.text_sm
                                    , Tw.text_gray_700
                                    , Css.hover [ Tw.bg_gray_100 ]
                                    ]
                                )

                          else
                            Html.i [] []
                        ]
                    ]
                ]

        myHiddenMenu : Html msg
        myHiddenMenu =
            div
                [ Attr.css <|
                    TwBp.md [ Tw.hidden ]
                        :: (if modelo.showMobileMenu then
                                [ Tw.block ]

                            else
                                [ Tw.hidden ]
                           )
                ]
                [ div
                    [ Attr.css
                        [ Tw.px_2
                        , Tw.pt_2
                        , Tw.pb_3
                        , Tw.space_y_1
                        , TwBp.sm [ Tw.px_3 ]
                        ]
                    ]
                    (ligasChulas True <| getMenu)
                , div
                    [ Attr.css
                        [ Tw.pt_4
                        , Tw.pb_3
                        , Tw.border_t
                        , Tw.border_gray_700
                        ]
                    ]
                    [ div
                        [ Attr.css
                            [ Tw.flex
                            , Tw.items_center
                            , Tw.px_5
                            ]
                        ]
                        [ div
                            [ Attr.css [ Tw.flex_shrink_0 ] ]
                            [ Html.img
                                [ Attr.css [ Tw.h_10, Tw.w_10, Tw.rounded_full ]
                                , Attr.src "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=g09zpRVLoT&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                                , Attr.alt ""
                                ]
                                []
                            , div
                                [ Attr.css [ Tw.ml_3 ] ]
                                [ div
                                    [ Attr.css [ Tw.text_base, Tw.font_medium, Tw.text_white ] ]
                                    [ text "Tom Cook" ]
                                , div
                                    [ Attr.css [ Tw.text_sm, Tw.font_medium, Tw.text_gray_400 ] ]
                                    [ text "tom@example.com" ]
                                ]
                            ]
                        ]
                    , div [ Attr.css [ Tw.mt_3, Tw.px_2, Tw.space_y_1 ] ]
                        (menuItems
                            [ Tw.block
                            , Tw.px_3
                            , Tw.py_2
                            , Tw.rounded_md
                            , Tw.text_base
                            , Tw.font_medium
                            , Tw.text_gray_400
                            , Css.hover [ Tw.text_white, Tw.bg_gray_700 ]
                            ]
                        )
                    ]
                ]

        ligasChulas :
            Bool
            -> List WhereTo
            -> List (Html msg)
        ligasChulas esMovil menus =
            let
                clasesBase =
                    [ Tw.text_gray_300
                    , Css.hover [ Tw.bg_gray_700, Tw.text_white ]
                    , Tw.px_3
                    , Tw.py_2
                    , Tw.rounded_md
                    , Tw.font_medium
                    ]

                claseActual =
                    [ Tw.bg_gray_900
                    , Tw.text_white
                    , Tw.px_3
                    , Tw.py_2
                    , Tw.rounded_md
                    , Tw.font_medium
                    ]

                claseActualEnMovil =
                    [ Tw.block, Tw.text_base ]

                claseActualEnDesktop =
                    [ Tw.text_sm ]

                claseExtraPaMovil =
                    [ Tw.block, Tw.text_base ]

                claseExtraPaDesktop =
                    [ Tw.text_sm ]

                clasesQueVan esParaMovil liga =
                    if "dosL" == liga.direccion then
                        case esParaMovil of
                            True ->
                                claseActual ++ claseActualEnMovil

                            False ->
                                claseActual ++ claseActualEnDesktop

                    else
                        case esParaMovil of
                            True ->
                                clasesBase ++ claseExtraPaMovil

                            False ->
                                clasesBase ++ claseExtraPaDesktop

                -- ligaChula : List Tw.Styles -> TemplateMetadata.Liga -> Html msg
                ligaChula clases liga =
                    Html.a
                        [ Attr.href liga.direccion
                        , Attr.css clases
                        ]
                        [ text liga.queDice ]
            in
            List.map
                (\algoDelMenu ->
                    ligaChula
                        (clasesQueVan esMovil algoDelMenu)
                        algoDelMenu
                )
                menus

        -- menuItems : List Styles -> List (Html msg)
        menuItems clases =
            [ Html.a
                [ Attr.href "#"
                , Attr.css clases
                , Aria.role "menuitem"
                ]
                [ text "Your Profile" ]
            , Html.a
                [ Attr.css clases
                , Aria.role "menuitem"
                ]
                [ text "Settings" ]
            , Html.a
                [ Attr.css clases
                , Aria.role "menuitem"
                ]
                [ text "Sign out" ]
            ]

        -- heroiconOutlineMenu : Html msg
        heroiconOutlineMenu =
            div
                [ Attr.css
                    [ Tw.h_6, Tw.w_6, Tw.block ]
                ]
                [ svg
                    -- [ Svg.Attributes.Attr.css [h-6 w-6 block"
                    -- , xmlns="http://www.w3.org/2000/svg"
                    [ AttrSvg.fill "none"
                    , AttrSvg.viewBox "0 0 24 24"
                    , AttrSvg.stroke "currentColor"

                    -- aria-hidden="true"
                    ]
                    [ Svg.path
                        [ AttrSvg.strokeLinecap "round"
                        , AttrSvg.strokeLinejoin "round"
                        , AttrSvg.strokeWidth "2"
                        , AttrSvg.d "M4 6h16M4 12h16M4 18h16"
                        ]
                        []
                    ]
                ]

        heroiconOutlineX : Html msg
        heroiconOutlineX =
            div
                [ Attr.css [ Tw.h_6, Tw.w_6, Tw.block ] ]
                [ svg
                    -- Svg.Attributes.Attr.css [h-6 w-6 block"
                    -- xmlns="http://www.w3.org/2000/svg"
                    [ AttrSvg.fill "none"
                    , AttrSvg.viewBox "0 0 24 24"
                    , AttrSvg.stroke "currentColor"

                    -- aria-hidden="true"
                    ]
                    [ path
                        [ AttrSvg.strokeLinecap "round"
                        , AttrSvg.strokeLinejoin "round"
                        , AttrSvg.strokeWidth "2"
                        , AttrSvg.d "M6 18L18 6M6 6l12 12"
                        ]
                        []
                    ]
                ]

        mobileMenuButton : Html Msg
        mobileMenuButton =
            div
                [ Attr.css
                    [ Tw.neg_mr_2
                    , Tw.flex
                    , TwBp.md [ Tw.hidden ]
                    ]
                ]
                [ Html.button
                    [ Attr.css
                        [ Tw.bg_gray_800
                        , Tw.inline_flex
                        , Tw.items_center
                        , Tw.justify_center
                        , Tw.p_2
                        , Tw.rounded_md
                        , Tw.text_gray_400
                        , Css.hover
                            [ Tw.text_white
                            , Tw.bg_gray_700
                            ]
                        , Css.focus
                            [ Tw.outline_none
                            , Tw.ring_2
                            , Tw.ring_offset_2
                            , Tw.ring_offset_gray_800
                            , Tw.ring_white
                            ]
                        ]
                    , Events.onClick ToggleMobileMenu
                    ]
                    [ Html.span [ Attr.css [ Tw.sr_only ] ] [ text "Open main menu" ]
                    , if modelo.showMobileMenu then
                        heroiconOutlineX

                      else
                        heroiconOutlineMenu
                    ]
                ]
    in
    Html.nav
        [ Attr.css [ Tw.bg_gray_800 ] ]
        [ div
            [ Attr.css
                [ Tw.max_w_7xl
                , Tw.mx_auto
                , Tw.px_4
                , TwBp.lg [ Tw.px_8 ]
                , TwBp.sm [ Tw.px_6 ]
                ]
            ]
            [ div
                [ Attr.css
                    [ Tw.flex
                    , Tw.items_center
                    , Tw.justify_between
                    , Tw.h_16
                    ]
                ]
                [ myLogoAndLinks
                , myHiddenBlock
                , mobileMenuButton
                ]
            ]
        , myHiddenMenu
        ]
