from django.contrib import admin
from .models import Produit, Categorie

@admin.register(Categorie)
class CategorieAdmin(admin.ModelAdmin):
    list_display = ('id', 'nom')
    search_fields = ('nom',)

@admin.register(Produit)
class ProduitAdmin(admin.ModelAdmin):
    list_display = ('id', 'nom', 'prix', 'stock', 'categorie', 'is_favorite')
    list_filter = ('categorie', 'is_favorite')
    search_fields = ('nom', 'description')
    list_editable = ('prix', 'stock', 'is_favorite')
