# Hugo + Papermod

## Initialization

### Install Hugo, and create Hugo yaml site

```Bash
hugo new site blog --format yaml
```

### Install & configure PaperMod

```Bash
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive # needed when you reclone your repo (submodules may not get cloned automatically)
```

## Run

```Bash
hugo server -D
```

## Links

[Hugo](https://gohugo.io/getting-started/quick-start/)

[PaperMod](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation)

[PaperMod Features](https://github.com/adityatelange/hugo-PaperMod/wiki/Features)
