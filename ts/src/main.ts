// First we have to install typescript, npm i typescript

// Second we have to init a tsconfing.json, we make this with the command tsc --init. This would create a tsconfig.json: Most common settings:
// {
//   "compilerOptions":{
//     "rootDir": "./src"
//     "outDir": "./dist",
//     "target": "es2017",
//     "strict": true,
//     "module": "commonjs"
//   }
// }

// Third create a scr/main.js with a main function
// Go to the console and type tsc in the root of the project, this would create a .js file in the dist folder
// Now you can execute the js file [ transpiled code from our ts file ]

const main = () => {
  variables_and_values();
  function_args_and_return_values();
}

const variables_and_values = () => {
  // Declaration of mutable variables, have type inference
  let age: number = 6;

  // Declaration of const variables, have type inference but it shows the literal type
  // This is because they cannot be reasigned
  const name = "Nicolas"; // const name: "Nicolas" = "Nicolas"
  const n = 6; // const name: 6 = 6

  // If we do this, any allows any type to be reassigned to the variable
  let endTime; // let endType: any
  let end_time: number; // let end_time: number
}

const function_args_and_return_values = () => {
 // This will be type (a: any, b: any): any. This function will let us sum up anything, ( string, number, etc) and also we dont know what type will be returned
  const add_without_types = (a, b) {
    return a + b;
  }  

  // This will only add number, and return a number
  const add_with_types = (a: number, b: number): number {
    return a + b; 
  }

}

main();
