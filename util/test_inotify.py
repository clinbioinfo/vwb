import logging
import os
import inotify.adapters

_DEFAULT_LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

_LOGGER = logging.getLogger(__name__)


watch_directory = '/tmp/test-inotify'

def _configure_logging():
    _LOGGER.setLevel(logging.DEBUG)

    ch = logging.StreamHandler()

    formatter = logging.Formatter(_DEFAULT_LOG_FORMAT)
    ch.setFormatter(formatter)

    _LOGGER.addHandler(ch)

def _main():
    i = inotify.adapters.InotifyTree(b'/tmp/test-inotify')

    # i.add_watch(b'/tmp/test-inotify')

    try:
        for event in i.event_gen():
            if event is not None:

                (header, type_names, watch_path, filename) = event
                
                file_path = os.path.join(watch_path.decode('utf-8'), filename.decode('utf-8'))
                
                if os.path.isfile(file_path):

                    if 'IN_CLOSE_WRITE' in type_names:

                        _LOGGER.info("WD=(%d) MASK=(%d) COOKIE=(%d) LEN=(%d) MASK->NAMES=%s "
                                 "WATCH-PATH=[%s] FILENAME=[%s]",
                                 header.wd, header.mask, header.cookie, header.len, type_names,
                                 watch_path.decode('utf-8'), filename.decode('utf-8'))

                        print("file was written to '%s'" % file_path)
    # finally:
    #     i.remove_watch(b'/tmp/test-inotify')

if __name__ == '__main__':
    _configure_logging()
    _main()