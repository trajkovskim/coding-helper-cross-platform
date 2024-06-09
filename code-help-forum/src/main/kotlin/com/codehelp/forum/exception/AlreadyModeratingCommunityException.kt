package com.codehelp.forum.exception

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(code = HttpStatus.NOT_MODIFIED)
class AlreadyModeratingCommunityException(val community: String): RuntimeException("Already moderating community $community")