import React, { useEffect, useState } from 'react';
import type { UserRanking } from '../../../generated/core-api/index.ts';
import { publicCoreService } from '../../../services';
import useRequest from '../../hooks/useRequest.ts';
import Spinner from '.././Spinner.tsx';
import { RankingsTable } from './RankingsTable.tsx';

const Rankings: React.FC = () => {
  const [rankings, setRankings] = useState<UserRanking[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getRankings()
        .then((response) => response.rankings)
        .then(setRankings)
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return <RankingsTable rankings={rankings} />;
};

export default Rankings;
