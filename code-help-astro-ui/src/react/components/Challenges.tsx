import React, { useEffect, useState } from 'react';
import { publicCoreService } from '../../services';
import type { ProblemEntry } from '../../generated/core-api';
import useRequest from '../hooks/useRequest.ts';
import Spinner from './Spinner.tsx';
import ChallengeCard from './ChallengeCard.tsx';

const Challenges: React.FC = () => {
  const [challenges, setChallenges] = useState<ProblemEntry[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getProblems({ page: 0, size: 10, sortBy: ['likes=asc'] })
        .then((response) => response.problems)
        .then(setChallenges),
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return (
    <>
      {challenges.map((challenge) => (
        <ChallengeCard key={challenge.id} {...challenge} category={challenge.category.name} />
      ))}
    </>
  );
};

export default Challenges;
