import React, { useEffect, useState } from 'react';
import useRequest from '../hooks/useRequest.ts';
import Spinner from './Spinner.tsx';
import CommunityCard from './CommunityCard.tsx';
import type { ShortCommunity } from '../../generated/forum-api';
import { publicForumService } from '../../services';

const Communities: React.FC = () => {
  const [communities, setCommunities] = useState<ShortCommunity[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicForumService
        .getCommunities()
        .then((response) => response.communities)
        .then(setCommunities),
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return (
    <>
      {communities.map((community) => (
        <CommunityCard key={community.name} name={community.name} description={community.description} />
      ))}
    </>
  );
};

export default Communities;
