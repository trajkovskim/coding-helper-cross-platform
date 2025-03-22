package com.codehelp.courses.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpHeaders;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Locale;

@WebFilter
public class LocaleFilter extends OncePerRequestFilter {

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
      throws ServletException, IOException {

    String acceptLanguageHeader = request.getHeader(HttpHeaders.ACCEPT_LANGUAGE);
    if(acceptLanguageHeader != null) {
      LocaleContextHolder.setLocale(Locale.forLanguageTag(acceptLanguageHeader));
    }

    filterChain.doFilter(request, response);
  }
}
