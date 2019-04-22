import os

import tornado.ioloop
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        folder = self.get_argument("folder", "")
        target = os.getcwd() + "/" + folder
        objs = next(os.walk(target))
        self.finish({"folders": objs[1],
                    "files": objs[2],
                    "current":folder,
                    "parent":os.path.dirname(folder)})


def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(8000)
    tornado.ioloop.IOLoop.current().start()

