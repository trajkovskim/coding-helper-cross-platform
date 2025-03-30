import { Flex } from '@chakra-ui/react';
import React from 'react';

const Header: React.FC = () => {
  return (
    <header>
      <Flex>
        <span>Coding helper</span>
        <nav>Navigation</nav>
      </Flex>
    </header>
  );
};

export default Header;
