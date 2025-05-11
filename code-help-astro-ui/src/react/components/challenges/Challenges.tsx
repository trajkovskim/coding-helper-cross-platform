import React, { useEffect, useState } from 'react';
import type { ProblemEntry, ProblemEntryBase } from '../../../generated/core-api/index.ts';
import { publicCoreService } from '../../../services/index.ts';
import useRequest from '../../hooks/useRequest.ts';
import Spinner from '../Spinner.tsx';
import ChallengesTable from './ChallengesTable.tsx';

const ChallengesTableOverview: React.FC = () => {
  const [challenges, setChallenges] = useState<ProblemEntryBase[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getProblems()
        .then((response) => response.problems)
        .then(setChallenges)
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return <ChallengesTable challenges={challenges} />;
};

export default ChallengesTableOverview;
