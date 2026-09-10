from eaf.core.webengine import BrowserBuffer


class AppBuffer(BrowserBuffer):
    """Fresh RSS Reader 专用 Buffer（阶段 1 骨架）。"""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    # 后续阶段实现的业务方法
    def open_article(self):
        pass

    def close_article(self):
        pass

    def select_feed(self, index):
        pass

    def mark_article_read(self, feedlink_index, article_index, link):
        pass

    def add_feed(self, feed):
        pass

    def remove_feed(self, index):
        pass

    def refresh_feed(self):
        pass

    def import_opml(self, content):
        pass

    def export_opml(self):
        pass
