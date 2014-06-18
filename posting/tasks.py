from __future__ import absolute_import

import opengraph 

from celery import shared_task
from urllib2 import URLError, HTTPError

@shared_task(bind=True, default_retry_delay=60, max_retries=5)
def get_opengraph(self, post, url):
    try:
        og = opengraph.OpenGraph(url=url)
        if og.is_valid():
            post.opengraph = og
            post.save()
    except (URLError, HTTPError), e:
        raise self.retry(exc=e)
