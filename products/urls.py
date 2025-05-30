from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProduitViewSet, CategorieViewSet

router = DefaultRouter()
router.register(r'produits', ProduitViewSet, basename='produit')
router.register(r'categories', CategorieViewSet, basename='categorie')

urlpatterns = [
    path('api/', include(router.urls)),
] 