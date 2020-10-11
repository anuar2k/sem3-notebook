# sem3-notebook
One image to rule them all (RPiS and PF). 😎

This image is a combined R + Haskell Jupyter Notebook. It uses `crosscompass/ihaskell-notebook` as its base and adds R to it using exact recipe as `jupyter/r-notebook`.

🙏 God bless the people behind Jupyter Docker Stacks. 🙏

### HoW dO i UsE iT ❓❓❓❓🤔
`docker create --name sem3-notebook -p 8888:8888 anuar2k/sem3-notebook` if you want to use classic Jupyter.

To enable JupyterLab do it like: `docker create --name sem3-notebook -p 8888:8888 anuar2k/sem3-notebook jupyter lab --LabApp.token=''` and visit `localhost:8888` in your browser.

You can also bind your current working dir to `/home/jovyan/work/` with `-v $(pwd):/home/jovyan/work` as an option of `docker create`.

Paste this to your terminal to do all above at once: `docker create --name sem3-notebook -p 8888:8888 -v $(pwd):/home/jovyan/work anuar2k/sem3-notebook jupyter lab --LabApp.token=''`. Now that's a humongous command.
