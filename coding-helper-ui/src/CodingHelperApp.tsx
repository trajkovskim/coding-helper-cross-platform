import { Provider } from 'components/ui/provider';
import Footer from 'components/layout/Footer';
import Header from 'components/layout/Header';
import { Outlet } from 'react-router-dom';

const CodingHelperApp: React.FC = () => {
  return (
    <Provider>
      <Header />
      <main>
        <Outlet />
      </main>
      <Footer />
    </Provider>
  );
};

export default CodingHelperApp;
