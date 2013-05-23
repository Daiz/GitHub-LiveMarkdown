require \chai .should!
require! lsc: \LiveScript

Linkify = require '../src/linkify'

suite \Linkify !->
  context = 'User/Test-Repo'

  suite '#sha(text, context)' !->
    
    test 'should turn full-hash into [`hash`](/context/commit/full-hash)' !->
      (Linkify.sha 'd4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'
    
    test 'should turn context-user@full-hash into [context-user@`hash`](/context/commit/full-hash)' !->
      (Linkify.sha 'User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[User@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'
    
    test 'should turn user/repo@full-hash into [user/repo@`hash`](/user/repo/commit/full-hash' !->
      (Linkify.sha 'User/Another-Repo@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal '[User/Another-Repo@`d4c58ff2`](/User/Another-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)'
    
    test 'should not do anything to not-context-user@full-hash' !->
      (Linkify.sha 'Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9' context)
      .should.equal 'Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9'

    test 'should deal with multiple instances properly' !->
      (Linkify.sha """
        test 1: d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test 2: User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test 3: User/Another-Repo@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
        test 4: Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      """ context).should.equal """
        test 1: [`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test 2: [User@`d4c58ff2`](/User/Test-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test 3: [User/Another-Repo@`d4c58ff2`](/User/Another-Repo/commit/d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9)
        test 4: Not-User@d4c58ff2cd197dc2e53e4d1fee1ca4332fdda5d9
      """

