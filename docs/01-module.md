Add dockerhub username and password (encrypted)

```
travis encrypt DOCKERHUB_USERNAME=... --add env.globa
travis encrypt DOCKERHUB_PASSWORD=... --add env.global
```

Add github pattern (so that devtools install github does not hit the request limits)

```
travis encrypt GITHUB_PAT=... --add env.global
```