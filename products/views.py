from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework import status
from .models import Produit, Categorie
from .serializers import ProduitSerializer, CategorieSerializer

# Create your views here.

class CategorieViewSet(viewsets.ModelViewSet):
    queryset = Categorie.objects.all()
    serializer_class = CategorieSerializer

class ProduitViewSet(viewsets.ModelViewSet):
    queryset = Produit.objects.all()
    serializer_class = ProduitSerializer

    def get_queryset(self):
        queryset = Produit.objects.all()
        categorie_id = self.request.query_params.get('categorie_id', None)
        if categorie_id is not None:
            queryset = queryset.filter(categorie_id=categorie_id)
        return queryset
