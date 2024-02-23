import os
import base64
from pathlib import Path

import requests


def dir_to_json(path):
    children = []

    if not os.path.isdir(path):
        return children

    for entry in os.listdir(path):
        entry_path = os.path.join(path, entry)

        if os.path.isdir(entry_path):
            children.append({
                "name": os.path.basename(entry_path),
                "type": "folder",
                "children": dir_to_json(entry_path),
            })
        else:
            children.append({
                "name": entry,
                "type": "file",
                "content": base64.b64encode(Path(entry_path).read_bytes()).decode(
                    "utf-8"
                ),
            })

    return children


# class config:
#     token = "1123"
#     url = "http://127.0.0.1:8000/turing/api/object"


class config:
    url = "https://eb.dev.withdata.io/turing/api/object"
    token = "bca274b9-51fc-4e08-aed0-d3c7a14bbced"


for subdir in Path("StatisticalRethinkingJulia").iterdir():
    if not subdir.is_dir():
        continue
    # if str(subdir) in [
    #     "StatisticalRethinkingJulia/varying-intercepts-admission",
    #     "StatisticalRethinkingJulia/multi-multilevel-chimpanzees",
    # ]:
    #     continue
    print("#" * 10, subdir)
    rsp = requests.post(
        config.url,
        json={
            "name": str(subdir),
            "content": {
                "meta": {
                    "entrance": "main.jl",
                    "iteration_count": 10,
                },
                "tree": dir_to_json(str(subdir)),
            },
        },
        headers={"Authorization": f"Bearer {config.token}"},
    )
    print(rsp.content)
    break
