import React from 'react';
import { Route } from 'react-router-dom';
import CodingHelperApp from 'CodingHelperApp';
import { Home } from 'pages/home';

export enum Routes {
  INDEX = '/',
  PROBLEMS_OVERVIEW = '/problems',
  PROBLEM_VIEW = '/problems/:id',
  CONTESTS_OVERVIEW = '/contests',
  CONTEST_VIEW = '/contests/:id',
  FORUM_OVERVIEW = '/forum',
  FORUM_COMMUNITIES_VIEW = '/forum/communities',
  FORUM_COMMUNITY_VIEW = '/forum/communities/:id',
  ANY_OTHER = '*',
}

export type RouteOption = Omit<React.ComponentProps<typeof Route>, 'children'> & {
  children?: Record<string, RouteOption>;
};

export type RouteOptions = Record<string, RouteOption>;

const routes: RouteOptions = {
  [Routes.INDEX]: {
    element: React.createElement(CodingHelperApp),
    children: {
      [Routes.INDEX]: {
        element: React.createElement(Home),
      },
    },
  },
};

export default routes;
