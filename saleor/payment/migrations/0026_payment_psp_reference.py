# Generated by Django 3.1.8 on 2021-05-12 09:14

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("payment", "0025_auto_20210506_0750"),
    ]

    operations = [
        migrations.AddField(
            model_name="payment",
            name="psp_reference",
            field=models.CharField(
                blank=True, db_index=True, max_length=512, null=True
            ),
        ),
    ]
