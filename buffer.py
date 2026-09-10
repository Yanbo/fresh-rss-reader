from eaf.core.webengine import BrowserBuffer


class AppBuffer(BrowserBuffer):
    """Fresh RSS Reader 专用 Buffer（阶段 1 骨架）。"""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
