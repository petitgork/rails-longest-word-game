require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "filling input, click on button and get a message erreur" do
    visit new_url
    fill_in "word", with: "unconditional"
    click_on "Play"
    string = selector "#answer"
    assert_match /^Sorry but UNCONDITIONAL can't be built out of.*$/, string
    # assert_selector "p", text: /^Sorry but UNCONDITIONAL can't be built out of.*$/
  end
end
