from rest_framework import serializers
from .models import Categorie, Produit

class CategorieSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categorie
        fields = ['id', 'nom']

class ProduitSerializer(serializers.ModelSerializer):
    categorie = CategorieSerializer(read_only=True)
    categorie_id = serializers.PrimaryKeyRelatedField(
        queryset=Categorie.objects.all(),
        source='categorie',
        write_only=True
    )

    class Meta:
        model = Produit
        fields = ['id', 'nom', 'description', 'prix', 'url_image', 
                 'stock', 'categorie', 'categorie_id', 'is_favorite',
                 'created_at', 'updated_at'] 