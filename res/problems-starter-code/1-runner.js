const readline = require('readline');
const readLine = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

readLine.question('', (line) => {
  console.log(main(JSON.parse(`[${line}]`)));
  readLine.close();
});

const main = (args) => {
  return twoSum(args[0], args[1]);
};
