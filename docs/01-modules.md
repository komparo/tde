To enable dockerhub push and pull:

```bash
travis encrypt DOCKERHUB_USERNAME=... --add
travis encrypt DOCKERHUB_PASSWORD=... --add
```


To make sure devtools can download repositories without hitting a limit:
```bash
travis encrypt GITHUB_PAT=... --add
```
