import React from 'react';
import css from './PostCard.module.css';

interface Props {
  title: string;
  content: string;
  username: string;
}

const PostCard: React.FC<Props> = (props) => {
  return (
    <div>
      <div className={`text-lg ${css.title}`}>{props.title}</div>
      <div>{props.content}</div>
      <div className={`${css.footer} text-sm`}>
        <div>By {props.username}</div>
      </div>
    </div>
  );
};

export default PostCard;
