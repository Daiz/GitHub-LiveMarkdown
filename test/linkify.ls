should = require \chai .should!

Linkify = require '../src/linkify'

suite \Linkify !->
  context = 'User/Test-Repo'

  suite '#sha(text, context)' !->

    test 'should turn full-hash into [`hash`](/context/commit/full-hash)' !->
      (Linkify.sha 'd4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should turn @full-hash into [@`hash`](/context/commit/full-hash)' !->
      (Linkify.sha '@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should turn /@full-hash into /@[`hash`](/context/commit/full-hash)' !->
      (Linkify.sha '/@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '/@[`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should turn context-user@full-hash into [context-user@`hash`](/context/commit/full-hash)' !->
      (Linkify.sha 'User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[User@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'
    
    test 'should turn user/repo@full-hash into [user/repo@`hash`](/user/repo/commit/full-hash)' !->
      (Linkify.sha 'User/Another-Repo@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[User/Another-Repo@`d4c58ff2`](/User/Another-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should turn user/@full-hash into [user/@`hash`](/user//commit/full-hash)' !->
      (Linkify.sha 'User/@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[User/@`d4c58ff2`](/User//commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'    
    
    test 'should turn other-user@full-hash into [other-user/context-repo@`hash`](/other-user/context-repo/commit/full-hash)' !->
      (Linkify.sha 'Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[Not-User@`d4c58ff2`](/Not-User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should not linkify /full-hash' !->
      (Linkify.sha '/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9'

    test 'should not touch existing markdown links' !->
      (Linkify.sha '[`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)' context)
      .should.equal '[`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should not touch URL links' !->
      (Linkify.sha 'https://github.com/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal 'https://github.com/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9'

    test 'should not touch anything inside code tags' !->
      (Linkify.sha '`d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9`' context)
      .should.equal '`d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9`'

      (Linkify.sha """
        ```
        test d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        ```
      """ context).should.equal """
        ```
        test d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        ```
      """

      (Linkify.sha """
        test

            d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9

        test

        \td4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9

        test
      """ context).should.equal """
        test

            d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9

        test

        \td4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9

        test
      """

      (Linkify.sha """
        test

            test

        d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9

            test

        d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9

        \ttest
        """ context).should.equal """
        test

            test

        [`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)

            test

        [`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)

        \ttest
      """

    test 'should not mangle code tags with multiple instances' !->
    (Linkify.sha """
      ```
      d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      ```
    """ context).should.equal """
      ```
      d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      ```
    """

    test 'should deal with multiple instances properly' !->
      (Linkify.sha """
        test: d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: User/Another-Repo@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: [`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: `d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9`
        ```
        test: d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        ```
        test: @d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: /@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: /d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: https://github.com/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: This should appear in the output
      """ context).should.equal """
        test: [`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [User@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [User/Another-Repo@`d4c58ff2`](/User/Another-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [Not-User@`d4c58ff2`](/Not-User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: `d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9`
        ```
        test: d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        ```
        test: [@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: /@[`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: /d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: https://github.com/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: This should appear in the output
      """

  suite '#issue(text, context)' !->

    test 'should turn #number into [#number](/context/issues/number' !->
      (Linkify.issue '#34' context)
      .should.equal '[#34](/User/Test-Repo/issues/34)'

    test 'should turn context-user#number into [context-user#number](/context/issues/number)' !->
      (Linkify.issue 'User#34' context)
      .should.equal '[User#34](/User/Test-Repo/issues/34)'

    test 'should turn user#number into [user#number](/user/context-repo/issues/number)' !->
      (Linkify.issue 'Not-User#34' context)
      .should.equal '[Not-User#34](/Not-User/Test-Repo/issues/34)'

    test 'should turn user/repo#number into [user/repo#number](/user/repo/issues/number)' !->
      (Linkify.issue 'Not-User/Another-Repo#34' context)
      .should.equal '[Not-User/Another-Repo#34](/Not-User/Another-Repo/issues/34)'

    test 'should turn issue URLs for context into [#number](/context/issues/number)' !->
      (Linkify.issue 'https://github.com/User/Test-Repo/issues/34' context)
      .should.equal '[#34](/User/Test-Repo/issues/34)'

    test 'should turn issue URLs for user/context-repo into [user#number](/user/context-repo/issues/number)' !->
      (Linkify.issue 'https://github.com/Not-User/Test-Repo/issues/34' context)
      .should.equal '[Not-User#34](/Not-User/Test-Repo/issues/34)'

    test 'should turn issue URLs for user/repo into [#number](/user/repo/issues/number)' !->
      (Linkify.issue 'https://github.com/Not-User/Another-Repo/issues/34' context)
      .should.equal '[#34](/Not-User/Another-Repo/issues/34)'

    test 'should not mangle code tags with multiple instances' !->
    (Linkify.issue '''
      ```
      #34 #34 #34
      ```
    ''' context).should.equal '''
      ```
      #34 #34 #34
      ```
    '''

    test 'should deal with multiple instances properly' !->
      (Linkify.issue '''
        test: #34
        test: User#34
        test: Not-User#34
        test: Not-User/Another-Repo#34
        test: https://github.com/User/Test-Repo/issues/34
        test: https://github.com/Not-User/Test-Repo/issues/34
        test: https://github.com/Not-User/Another-Repo/issues/34
        test: `#34`
        ```
        test: User#34
        ```
      ''' context).should.equal '''
        test: [#34](/User/Test-Repo/issues/34)
        test: [User#34](/User/Test-Repo/issues/34)
        test: [Not-User#34](/Not-User/Test-Repo/issues/34)
        test: [Not-User/Another-Repo#34](/Not-User/Another-Repo/issues/34)
        test: [#34](/User/Test-Repo/issues/34)
        test: [Not-User#34](/Not-User/Test-Repo/issues/34)
        test: [#34](/Not-User/Another-Repo/issues/34)
        test: `#34`
        ```
        test: User#34
        ```
      '''

  suite '#mention(text)' !->

    test 'should turn @mention into [@mention](blog-post)' !->
      (Linkify.mention '@mention')
      .should.equal "<a class='user-mention' href='/blog/821'>@mention</a>"

      (Linkify.mention 'test @mention')
      .should.equal "test <a class='user-mention' href='/blog/821'>@mention</a>"

    test 'should turn @user into [@user](/user)' !->
      (Linkify.mention '@User')
      .should.equal "<a class='user-mention' href='/User'>@User</a>"

      (Linkify.mention 'test @User')
      .should.equal "test <a class='user-mention' href='/User'>@User</a>"

      (Linkify.mention '-@User')
      .should.equal "-<a class='user-mention' href='/User'>@User</a>"

    test 'should not touch text@user' !->
      (Linkify.mention 'text@User')
      .should.equal 'text@User'

    test 'should not touch anything inside code tags' !->
      (Linkify.mention '`@User`')
      .should.equal '`@User`'

      (Linkify.mention """
        ```
        @User
        ```
      """).should.equal """
        ```
        @User
        ```
      """

    test 'should not mangle code tags with multiple instances' !->
    (Linkify.mention """
      ```
      @User @User @User
      ```
    """).should.equal """
      ```
      @User @User @User
      ```
    """

    test 'should deal with multiple instances properly' !->
      (Linkify.mention """
        test: @mention
        test: @User
        test: @User?
        test: text@User
        test: user@example.com
        test: -@User
        test: `@User`
        ```
        test: @User
        ```
      """).should.equal """
        test: <a class='user-mention' href='/blog/821'>@mention</a>
        test: <a class='user-mention' href='/User'>@User</a>
        test: <a class='user-mention' href='/User'>@User</a>?
        test: text@User
        test: user@example.com
        test: -<a class='user-mention' href='/User'>@User</a>
        test: `@User`
        ```
        test: @User
        ```
      """


