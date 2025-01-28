# Notes
Follow release format : `vMAJOR.MINOR.PATCH-alpha.NUMBER`

# Release
Example of a release :
1. update `pkgmeta.yml`
2. create a tag and push it
```
git tag v1.0.0-alpha
git push origin v1.0.0-alpha
```

When pushing multiple, alphas use the dot notation
```
git tag v1.0.0-alpha.1
git tag v1.0.0-alpha.2
```