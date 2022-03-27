docker build -t excalidraw/excalidraw .
docker run --rm -dit --name excalidraw -p 5000:80 excalidraw/excalidraw:latest

## for sub directory
modify index.html

```html
<head>
<base href="/draw/">
...


"static/js/" -> "draw/static/js/"

```

