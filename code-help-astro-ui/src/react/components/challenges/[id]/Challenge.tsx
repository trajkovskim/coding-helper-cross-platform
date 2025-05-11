import React, { useEffect, useState } from 'react';
import type { ProblemEntry } from '../../../../generated/core-api';
import { publicCoreService } from '../../../../services/index.ts';
import useRequest from '../../../hooks/useRequest.ts';
import Spinner from '../../Spinner.tsx';
import { ChallengeDetail } from './ChallengeDetail.tsx';

interface Props {
    id: number;
}

const Challenge: React.FC<Props> = (props) => {
  const [challenge, setChallenge] = useState<ProblemEntry>();
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getProblem(props.id, 'javascript')
        .then(setChallenge)
    );
  }, []);

    if (error) {
        return <div>Error loading challenge {JSON.stringify(error)}</div>;
    }

  if (loading) {
    return <Spinner />;
  }

  if (!challenge) {
    return <div>Challenge not found</div>;
  }

  return <ChallengeDetail challenge={challenge} />;
};

export default Challenge;
