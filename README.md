# Simple web template W Purescript setup

## To run

Install dependencies.
```bash
npm i 
```
Run development server
```bash
npm run dev
```

## If you want to build just run 
Build static site
```bash
npm run build
```


If you want template without testing code, just take project from 2th commit for with purescript.
1th commit without purescript


## Possibility to code split with this
Input1 would be loaded in page1

Input2 would be loaded in page2

Anything which they share, would be put into separate chunk file and could be cached. 
More at https://esbuild.github.io/api/#splitting

``` bash
esbuild input1.js input2.js --bundle --splitting --outdir=outputFolder --format=esm
```
