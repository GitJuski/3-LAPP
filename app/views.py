from django.template import loader
from django.http import HttpResponse
from . models import HelloWorld


def frontpage(request):
    notes = HelloWorld.objects.all().values()
    template = loader.get_template('helloworld.html')
    context = {
        'notes': notes,
    }

    return HttpResponse(template.render(context, request))