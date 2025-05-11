import React, { useEffect, useState } from 'react';
import { publicCoreService } from '../../services';
import type { ContestEntry } from '../../generated/core-api';
import useRequest from '../hooks/useRequest.ts';
import Spinner from './Spinner.tsx';
import UpcomingContestCard from './UpcomingContestCard.tsx';

const UpcomingContests: React.FC = () => {
  const [contests, setContests] = useState<ContestEntry[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getContests({ page: 0, size: 2, sortBy: ['contest.startDate=asc'] })
        .then((response) => response.contests)
        .then(setContests)
        .catch(() =>
          setContests([
            {
              id: 0,
              name: 'Error',
              description: 'Failed to load contests',
              startDate: new Date(),
              duration: '0',
              status: 'OPEN',
              problems: [],
            },
          ])
        )
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return (
    <>
      {contests.map((contest) => (
        <UpcomingContestCard key={contest.id} {...contest} />
      ))}
    </>
  );
};

export default UpcomingContests;
