package com.codehelp.forum.exception

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(code = HttpStatus.FORBIDDEN, reason = "Forbidden")
class ForbiddenException: RuntimeException("Forbidden")