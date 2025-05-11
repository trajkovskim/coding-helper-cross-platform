import { useCallback, useState } from 'react';

const useRequest = <T>() => {
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<unknown>();

  const send = useCallback((...promise: Promise<T>[]) => {
    setLoading(true);

    // promise.push(new Promise((resolve) => {
    //   // @ts-ignore
    //   setTimeout(() => resolve(), 5000);
    // }))

    return Promise.all(promise)
      .catch(setError)
      .finally(() => setLoading(false));
  }, []);

  return { loading, error, send };
};

export default useRequest;