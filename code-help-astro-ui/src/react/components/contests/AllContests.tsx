import React, { useEffect, useState } from 'react';
import type { ContestEntry } from '../../../generated/core-api/index.ts';
import { publicCoreService } from '../../../services';
import useRequest from '../../hooks/useRequest.ts';
import Spinner from '.././Spinner.tsx';
import ContestsTable from './ContestsTable.tsx';

const AllContests: React.FC = () => {
  const [contests, setContests] = useState<ContestEntry[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicCoreService
        .getContests()
        .then((response) => response.contests)
        .then(setContests)
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return <ContestsTable contests={contests} />;
};

export default AllContests;
