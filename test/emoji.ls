should = require \chai .should!

Emoji = require '../src/emoji'

suite \Emoji !->
  
  test 'should turn :valid_emoji: into an image' !->
    Emoji ':coffee:' .should.equal """
    <img class='emoji' title=':coffee:' alt=':coffee:' src=
    'https://a248.e.akamai.net/assets.github.com/images/icons/emoji/coffee.png'
    width='20' height='20' align='absmiddle'>
    """

  test 'should not touch :invalid_emoji:' !->
    Emoji ':test:' .should.equal ':test:'

  test 'should not touch emoji codes inside code blocks' !->
    Emoji """
    test
    ```
    :coffee:
    ```
    test

        :coffee:

    test

    \t:coffee:

    test

    :coffee:

    test
    """ .should.equal """
    test
    ```
    :coffee:
    ```
    test

        :coffee:

    test

    \t:coffee:

    test

    <img class='emoji' title=':coffee:' alt=':coffee:' src=
    'https://a248.e.akamai.net/assets.github.com/images/icons/emoji/coffee.png'
    width='20' height='20' align='absmiddle'>

    test
    """

  test 'should deal with multiple instances properly' !->
    Emoji ':test: :coffee: :tea: :test:' .should.equal """
    :test: <img class='emoji' title=':coffee:' alt=':coffee:' src=
    'https://a248.e.akamai.net/assets.github.com/images/icons/emoji/coffee.png'
    width='20' height='20' align='absmiddle'> <img class='emoji' title=':tea:' alt=':tea:' src=
    'https://a248.e.akamai.net/assets.github.com/images/icons/emoji/tea.png'
    width='20' height='20' align='absmiddle'> :test:
    """
