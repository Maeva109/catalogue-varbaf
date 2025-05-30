from django.db import models

# Create your models here.

class Categorie(models.Model):
    nom = models.CharField(max_length=100)

    def __str__(self):
        return self.nom

    class Meta:
        verbose_name = "Catégorie"
        verbose_name_plural = "Catégories"

class Produit(models.Model):
    nom = models.CharField(max_length=200)
    description = models.TextField()
    prix = models.FloatField()
    url_image = models.CharField(max_length=500)
    stock = models.IntegerField()
    categorie = models.ForeignKey(Categorie, on_delete=models.CASCADE, related_name='produits')
    is_favorite = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.nom

    class Meta:
        verbose_name = "Produit"
        verbose_name_plural = "Produits"
