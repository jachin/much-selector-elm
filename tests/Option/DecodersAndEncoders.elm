module Option.DecodersAndEncoders exposing (suite)

import Expect
import Json.Decode
import Option
    exposing
        ( decoder
        , newDisabledOption
        , newOption
        , newSelectedOption
        , optionsDecoder
        )
import Test exposing (Test, describe, test)


simpleOptionWithJustLabelAndValue =
    """{"label": "Sup", "labelClean": "sup", "value": "Sup"}"""


simpleSelectedOption =
    """{"label": "Sup", "labelClean": "sup", "value": "Sup", "selected": true}"""


simpleSelectedOptionSelectedIsAString =
    """{"label": "Sup", "labelClean": "sup", "value": "Sup", "selected": "true"}"""


simpleNotSelectedOption =
    """{"label": "Sup", "labelClean": "sup", "value": "Sup", "selected": "false"}"""


disabledOption =
    """{"label": "Dude", "labelClean": "dude", "value": "Dude", "selected": "false", "disabled": true}"""


listOfOptions =
    """[
        {"label": "one", "labelClean": "one", "value": "1", "selected": "false"},
        {"label": "two", "labelClean": "two", "value": "2"},
        {"label": "three", "labelClean": "three", "value": "3", "selected": "true"}]"""


listOfOptionsWithDescriptions =
    """[
        {"label": "straw", "labelClean": "straw", "value": "1", "selected": "false", "description": "👒", "descriptionClean": null},
        {"label": "sticks", "labelClean": "sticks", "value": "2", "description": "🌳", "descriptionClean": null},
        {"label": "bricks", "labelClean": "bricks", "value": "3", "selected": "true", "description": "🧱", "descriptionClean": null}]
    """


listOfOptionsWithGroups =
    """[
        {"label": "straw", "labelClean": "straw", "value": "1", "selected": "false", "group": "Building Material"},
        {"label": "sticks", "labelClean": "sticks", "value": "2", "group": "Building Material"},
        {"label": "bricks", "labelClean": "bricks", "value": "3", "selected": "true", "group": "Building Material"}]
    """


listOfOptionsWithJustValues =
    """
    [
      {
        "value": "The Enormous Crocodile"
      },
      {
        "value": "James and the Giant Peach"
      },
      {
        "value": "Matilda"
      },
      {
        "value": "The BFG"
      }
    ]
    """


suite : Test
suite =
    describe "The Option modules"
        [ describe "decoding"
            [ test "an option with just a label and value" <|
                \_ ->
                    Expect.equal
                        (Ok (newOption "Sup" (Just "sup")))
                        (Json.Decode.decodeString decoder simpleOptionWithJustLabelAndValue)
            , test "an option that's selected" <|
                \_ ->
                    Expect.equal
                        (Ok (newSelectedOption "Sup" (Just "sup")))
                        (Json.Decode.decodeString decoder simpleSelectedOption)
            , test "an option that's selected (using the 'true' string)" <|
                \_ ->
                    Expect.equal
                        (Ok (newSelectedOption "Sup" (Just "sup")))
                        (Json.Decode.decodeString decoder simpleSelectedOptionSelectedIsAString)
            , test "an option that's not selected" <|
                \_ ->
                    Expect.equal
                        (Ok (newOption "Sup" (Just "sup")))
                        (Json.Decode.decodeString decoder simpleNotSelectedOption)
            , test "an option that's disabled" <|
                \_ ->
                    Expect.equal
                        (Ok (newDisabledOption "Dude" (Just "dude")))
                        (Json.Decode.decodeString decoder disabledOption)
            , test "a list of options" <|
                \_ ->
                    Expect.equal
                        (Ok
                            [ newOption "1" Nothing |> Option.setLabelWithString "one" (Just "one")
                            , newOption "2" Nothing |> Option.setLabelWithString "two" (Just "two")
                            , newSelectedOption "3" Nothing |> Option.setLabelWithString "three" (Just "three")
                            ]
                        )
                        (Json.Decode.decodeString optionsDecoder listOfOptions)
            , test "a list of options with descriptions" <|
                \_ ->
                    Expect.equal
                        (Ok
                            [ newOption "1" Nothing
                                |> Option.setLabelWithString "straw" (Just "straw")
                                |> Option.setDescriptionWithString "👒"
                            , newOption "2" Nothing
                                |> Option.setLabelWithString "sticks" (Just "sticks")
                                |> Option.setDescriptionWithString "🌳"
                            , newSelectedOption "3" Nothing
                                |> Option.setLabelWithString "bricks" (Just "bricks")
                                |> Option.setDescriptionWithString "🧱"
                            ]
                        )
                        (Json.Decode.decodeString
                            optionsDecoder
                            listOfOptionsWithDescriptions
                        )
            , test "a list of options with groups" <|
                \_ ->
                    Expect.equal
                        (Ok
                            [ newOption "1" Nothing
                                |> Option.setLabelWithString "straw" (Just "straw")
                                |> Option.setGroupWithString "Building Material"
                            , newOption "2" Nothing
                                |> Option.setLabelWithString "sticks" (Just "sticks")
                                |> Option.setGroupWithString "Building Material"
                            , newSelectedOption "3" Nothing
                                |> Option.setLabelWithString "bricks" (Just "bricks")
                                |> Option.setGroupWithString "Building Material"
                            ]
                        )
                        (Json.Decode.decodeString
                            optionsDecoder
                            listOfOptionsWithGroups
                        )
            , test "an empty option with an empty label" <|
                \_ ->
                    Expect.equal
                        (Ok [ newOption "" (Just "") ])
                        (Json.Decode.decodeString optionsDecoder """[ {"label": "", "labelClean": "", "value": "" } ]""")
            , test "an empty option with a label" <|
                \_ ->
                    Expect.equal
                        (Ok [ newOption "" Nothing |> Option.setLabelWithString "nothing" (Just "nothing") ])
                        (Json.Decode.decodeString optionsDecoder """[ {"label": "nothing", "labelClean": "nothing", "value": "" } ]""")
            , test "a list of options with just values should fail" <|
                \_ ->
                    Expect.err
                        (Json.Decode.decodeString optionsDecoder listOfOptionsWithJustValues)
            ]
        ]
