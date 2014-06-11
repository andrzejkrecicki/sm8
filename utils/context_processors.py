from django.conf import settings

def core_context_processor(request):
    return {
        "settings": settings,
    }