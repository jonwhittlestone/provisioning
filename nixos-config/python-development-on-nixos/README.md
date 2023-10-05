# Python development on NixOS

Running a Python standalone script on NixOS may not be completely hassle-free.

Especially if we want to use Pandas.

Runing a standalone python script in a virtualenv, that uses Pandas on my NixOS machine, I'd get:

```sh
source .venv/bin/activate

(.venv) ❯ python script-using-pandas.py
Traceback (most recent call last):
  File "/home/jon/code/script-using-pandas.py", line 2, in <module>
    import pandas as pd
  File "/home/jon/code/.venv/lib/python3.11/site-packages/pandas/__init__.py", line 16, in <module>
    raise ImportError(
ImportError: Unable to import required dependencies:
numpy: Error importing numpy: you should not try to import numpy from
        its source directory; please exit the numpy source tree, and relaunch
        your python interpreter from there.
```

As we can see from the [Python page in the NixOS wiki](https://nixos.wiki/wiki/Python#Python_virtual_environment), using Pandas and NumPy may fail because these packages use C libraries that won't find dependencies in the expected places.

> Installing packages with pip that need to compile code or use C libraries will sometimes fail due to not finding dependencies in the expected places. In that case you can use buildFHSUserEnv to make yourself a sandbox that appears like a more typical Linux install

## Workaround? Use Docker

Run your python script in a a docker container if using Pandas/NumPy.

```sh
docker build -t "pydev" -q .; docker run pydev python main.py

🐍 Hello Data Science! 🐍
```
