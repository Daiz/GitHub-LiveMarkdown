require! {
  should: \chai .should!
  lsc: \LiveScript
}

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

    test 'should turn context-user@full-hash into [context-user@`hash`](/context/commit/full-hash)' !->
      (Linkify.sha 'User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[User@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'
    
    test 'should turn user/repo@full-hash into [user/repo@`hash`](/user/repo/commit/full-hash' !->
      (Linkify.sha 'User/Another-Repo@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[User/Another-Repo@`d4c58ff2`](/User/Another-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'
    
    test 'should turn other-user@full-hash into [other-user/context-repo@`hash`](/other-user/context-repo/commit/full-hash)' !->
      (Linkify.sha 'Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[Not-User@`d4c58ff2`](/Not-User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should not linkify /full-hash' !->
      (Linkify.sha '/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9'

    test 'should not touch existing markdown links' !->
      (Linkify.sha '[`d4c58ff2`](/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)' context)
      .should.equal '[`d4c58ff2`](/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'

    test 'should not touch URL links' !->
      (Linkify.sha 'https://github.com/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal 'https://github.com/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9'

    test 'should deal with multiple instances properly' !->
      (Linkify.sha """
        test: d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: User/Another-Repo@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: [`d4c58ff2`](/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: @d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: /d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: https://github.com/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: This should appear in the output
      """ context).should.equal """
        test: [`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [User@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [User/Another-Repo@`d4c58ff2`](/User/Another-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [Not-User@`d4c58ff2`](/Not-User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [`d4c58ff2`](/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: [@`d4c58ff2`](/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test: /d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: https://github.com/User/Test-Repo/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test: This should appear in the output
      """

