package com.codehelp.forum.exception

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(code = HttpStatus.NOT_MODIFIED)
class AlreadyCommunityMemberException(val username: String, val community: String): RuntimeException("$username is already a member of community $community")
