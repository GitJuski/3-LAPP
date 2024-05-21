from django.db import models


class HelloWorld(models.Model):

    title = models.CharField(max_length=100)

    description = models.TextField(null=True)


    COOLNESS = (
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
    )

    coolness = models.IntegerField(null=True, choices=COOLNESS, default=0)

    def __str__(self):
        return self.title