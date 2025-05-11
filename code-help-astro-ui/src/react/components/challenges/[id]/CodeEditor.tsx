import { Editor } from '@monaco-editor/react';
import { useState } from 'react';

interface CodeEditorProps {
  initialValue?: string;
  language?: string;
  onChange?: (value: string | undefined) => void;
}

const CodeEditor: React.FC<CodeEditorProps> = ({ initialValue = '', language = 'javascript', onChange }) => {
  const [value, setValue] = useState(initialValue);

  const handleEditorChange = (value: string | undefined) => {
    setValue(value || '');
    onChange?.(value);
  };

  return (
    <Editor
      width="100%"
      height="500px"
      defaultLanguage={language}
      defaultValue={initialValue}
      theme="light"
      onChange={handleEditorChange}
      options={{
        minimap: { enabled: false },
        fontSize: 14,
        scrollBeyondLastLine: false,
        wordWrap: 'on',
        automaticLayout: true,
      }}
    />
  );
};

export default CodeEditor;
