package mk.com.codehelp.core.api.controller;

import lombok.RequiredArgsConstructor;

import mk.com.codehelp.core.api.factory.LinksFactory;
import mk.com.codehelp.core.api.mappers.UserMapper;
import mk.com.codehelp.core.rest.model.PaginationLinks;
import mk.com.codehelp.core.rest.model.UserRankingsResponse;
import mk.com.codehelp.core.service.dto.PageInfoDto;
import mk.com.codehelp.core.service.dto.UserRankingDto;
import mk.com.codehelp.core.service.dto.UserStatisticsDto;
import mk.com.codehelp.core.rest.api.UserApi;
import mk.com.codehelp.core.rest.model.UserStatistics;
import mk.com.codehelp.core.service.service.StatisticsService;
import mk.com.codehelp.core.service.util.AuthenticationUtil;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequiredArgsConstructor
public class UserController implements UserApi {

  private final StatisticsService statisticsService;
  private final UserMapper userMapper;

  private final LinksFactory linksFactory;
  private final AuthenticationUtil authenticationUtil;

  @Override
  public ResponseEntity<UserRankingsResponse> getRankings(Integer page, Integer size, String authorization) {

    String user = authenticationUtil.getUserId();

    PageInfoDto<UserRankingDto> rankingsPage = statisticsService.getRankings(user, page, size);
    PaginationLinks paginationLinks = linksFactory.createPaginationLinks(
      rankingsPage,
      (pageNumber, pageSize) -> methodOn(UserController.class).getRankings(pageNumber, pageSize, authorization));

    UserRankingsResponse userRankingsResponse = new UserRankingsResponse()
      .rankings(userMapper.convert(rankingsPage.getItems()))
      .totalPages(rankingsPage.getTotalPages())
      .totalElements(rankingsPage.getTotalElements())
      .pageNumber(rankingsPage.getPageNumber())
      .pageSize(rankingsPage.getPageSize())
      .links(paginationLinks);

    return ResponseEntity.ok(userRankingsResponse);
  }

  @Override
  public ResponseEntity<UserStatistics> getStatistics(String authorization, String user) {

    String name = user != null ? user : authenticationUtil.getUserId();

    UserStatisticsDto userStatistics = statisticsService.getStatistics(name);
    UserStatistics entry = userMapper.convert(userStatistics);

    return ResponseEntity.ok(entry);
  }
}
