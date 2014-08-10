"""
Django settings for sm8 project.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.6/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))

from django.conf.global_settings import TEMPLATE_CONTEXT_PROCESSORS


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.6/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '7#%fv18+f7mgkae!87j06rrkshv6absv#-creg=3s1^6xp7=10'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'posting',
    'rest_framework',
    'south',
    'pipeline',
    'djcelery',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'pipeline.middleware.MinifyHTMLMiddleware',
)

TEMPLATE_CONTEXT_PROCESSORS += (
    'utils.context_processors.core_context_processor',
)

ROOT_URLCONF = 'sm8.urls'

WSGI_APPLICATION = 'sm8.wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.6/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}


REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': ('rest_framework.renderers.JSONRenderer',),
    'DEFAULT_PERMISSION_CLASSES': ('rest_framework.permissions.DjangoModelPermissionsOrAnonReadOnly',),
    'PAGINATE_BY': 10,
    'PAGINATE_BY_PARAM': 'page_size',
    'MAX_PAGINATE_BY': 100,
}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


TEMPLATE_DIRS = [os.path.join(BASE_DIR, 'templates')]


MEDIA_ROOT = os.path.join(BASE_DIR, "media")
MEDIA_URL = '/media/'


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.6/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = 'staticfiles/'
STATICFILES_DIRS = (
    os.path.join(BASE_DIR, "static"),
)
STATICFILES_STORAGE = 'pipeline.storage.PipelineStorage'


PIPELINE_CSS = {
    'all': {
        'source_filenames': (
          'css/*.css',
          'scss/*.scss',
          'scss/font-awesome/font-awesome.scss',
        ),
        'output_filename': 'css/all.css',
    },
}

PIPELINE_JS = {
    'all': {
        'source_filenames': (
          'js/jquery*',
          'js/underscore*',
          'js/*.js',
          'eco/*.eco',
          'coffee/init.coffee',
          'coffee/models/*.coffee',
          'coffee/collections/*.coffee',
          'coffee/routers/*.coffee',
          'coffee/views/*.coffee',
          'coffee/core.coffee',
        ),
        'output_filename': 'js/all.js',
    }
}

PIPELINE_COMPILERS = (
    'pipeline.compilers.coffee.CoffeeScriptCompiler',
    'pipeline.compilers.sass.SASSCompiler',
    'pipeline_eco.compiler.EcoCompiler',
)

RECAPTCHA_PUBLIC_KEY = '6LduFvUSAAAAAFJZALp8_T5V8kLKR3TTZeCV2jmL'
RECAPTCHA_PRIVATE_KEY = '6LduFvUSAAAAAMLNW1bydZ1dnAZAl5pC9idyknOB'

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}

CELERY_RESULT_BACKEND='djcelery.backends.database:DatabaseBackend'
