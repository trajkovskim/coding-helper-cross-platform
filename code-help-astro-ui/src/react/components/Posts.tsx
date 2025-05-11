import React, { useEffect, useState } from 'react';
import useRequest from '../hooks/useRequest.ts';
import Spinner from './Spinner.tsx';
import PostCard from './PostCard.tsx';
import type { ShortPost } from '../../generated/forum-api';
import { publicForumService } from '../../services';

const Posts: React.FC = () => {
  const [posts, setPosts] = useState<ShortPost[]>([]);
  const { loading, error, send } = useRequest();

  useEffect(() => {
    send(
      publicForumService
        .getPosts()
        .then((response) => response.posts)
        .then(setPosts),
    );
  }, []);

  if (loading) {
    return <Spinner />;
  }

  return (
    <>
      {posts.map((post) => (
        <PostCard key={post.uid} {...post} username={post.user.username} />
      ))}
    </>
  );
};

export default Posts;
